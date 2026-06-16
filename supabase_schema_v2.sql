-- ============================================
-- 公会管理工具 v2 - Supabase 完整建表语句
-- 在 Supabase SQL Editor 中一次性执行
-- ============================================

-- 0. 启用 pgcrypto 扩展（用于密码哈希）
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- 1. 创建 members 表
DROP TABLE IF EXISTS members CASCADE;

CREATE TABLE members (
  id              UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  display_name    TEXT UNIQUE NOT NULL,          -- 登录时选择的中文昵称
  uid             TEXT UNIQUE NOT NULL,          -- 管理员分配的唯一ID
  password_hash   TEXT NOT NULL,                 -- 加密后的密码
  is_full_like    BOOLEAN DEFAULT FALSE,         -- 是否全赞
  level           INTEGER DEFAULT 0,            -- 等级
  vip_level       INTEGER DEFAULT 0,            -- VIP等级
  is_admin        BOOLEAN DEFAULT FALSE,        -- 是否管理员
  created_at      TIMESTAMPTZ DEFAULT NOW(),
  updated_at      TIMESTAMPTZ DEFAULT NOW()
);

-- 2. 索引
CREATE INDEX idx_members_display_name ON members(display_name);
CREATE INDEX idx_members_uid ON members(uid);
CREATE INDEX idx_members_is_admin ON members(is_admin);

-- 3. 自动更新 updated_at 的触发器
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_members_updated_at
  BEFORE UPDATE ON members
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- ============================================
-- 4. 密码验证 RPC 函数（安全：服务端比对，密码哈希不离开数据库）
-- ============================================
CREATE OR REPLACE FUNCTION verify_member_login(
  display_name_input TEXT,
  password_input     TEXT
)
RETURNS TABLE(
  id            UUID,
  display_name  TEXT,
  uid           TEXT,
  is_admin      BOOLEAN,
  is_full_like  BOOLEAN,
  level         INTEGER,
  vip_level     INTEGER
)
LANGUAGE plpgsql
SECURITY DEFINER   -- 绕过 RLS，函数以创建者权限运行
SET search_path = 'public, extensions, pg_catalog'
AS $$
BEGIN
  RETURN QUERY
  SELECT
    m.id,
    m.display_name,
    m.uid,
    m.is_admin,
    m.is_full_like,
    m.level,
    m.vip_level
  FROM public.members m
  WHERE m.display_name = display_name_input
    AND m.password_hash = crypt(password_input, m.password_hash);
END;
$$;

-- ============================================
-- 5. 创建成员 RPC 函数（管理员用，因为 RLS 会阻止 anon 直接 INSERT）
-- ============================================
CREATE OR REPLACE FUNCTION admin_create_member(
  p_display_name TEXT,
  p_uid          TEXT,
  p_password     TEXT DEFAULT '0000'
)
RETURNS SETOF public.members
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = 'public, extensions, pg_catalog'
AS $$
BEGIN
  RETURN QUERY
  INSERT INTO public.members (display_name, uid, password_hash)
  VALUES (
    p_display_name,
    p_uid,
    crypt(p_password, gen_salt('bf'))
  )
  RETURNING *;
END;
$$;

-- ============================================
-- 6. 初始化第一个管理员账号
--    display_name = '会长', password = '0000', is_admin = true
-- ============================================
INSERT INTO members (display_name, uid, password_hash, is_admin, is_full_like, level, vip_level)
VALUES (
  '会长',
  'admin_001',
  crypt('0000', gen_salt('bf')),
  TRUE,
  FALSE,
  99,
  10
)
ON CONFLICT (display_name) DO NOTHING;

-- ============================================
-- 7. RLS 策略说明（见下方注释）
-- ============================================

/*
 * 由于本项目不使用 Supabase Auth（不注册邮箱），
 * 而使用自定义的 display_name + 密码方式登录，
 * 因此无法使用 auth.uid() 进行 RLS 鉴权。
 *
 * 推荐方案（内部公会工具）：
 *   → 直接 DISABLE RLS on members 表
 *   → 敏感操作通过 SECURITY DEFINER 函数（如上面的 verify_member_login）执行
 *   → 客户端使用 anon key 访问
 *
 * 如果将来希望启用 Supabase Auth（邮箱登录），
 * 可以使用以下 RLS 策略：
 *
 * 启用 RLS 的 SQL（需要先启用 Supabase Auth）：
 *
 * ALTER TABLE members ENABLE ROW LEVEL SECURITY;
 *
 * -- 所有认证用户可读
 * CREATE POLICY "authenticated_read_all" ON members
 *   FOR SELECT TO authenticated USING (true);
 *
 * -- 用户只能更新自己的记录
 * CREATE POLICY "update_own_record" ON members
 *   FOR UPDATE TO authenticated
 *   USING (auth.uid() = id)
 *   WITH CHECK (auth.uid() = id);
 *
 * -- 只有管理员可以删除
 * CREATE POLICY "admin_delete" ON members
 *   FOR DELETE TO authenticated
 *   USING (EXISTS (
 *     SELECT 1 FROM members
 *     WHERE id = auth.uid() AND is_admin = TRUE
 *   ));
 *
 * -- 只有管理员可以创建
 * CREATE POLICY "admin_insert" ON members
 *   FOR INSERT TO authenticated
 *   WITH CHECK (EXISTS (
 *     SELECT 1 FROM members
 *     WHERE id = auth.uid() AND is_admin = TRUE
 *   ));
 */

-- 当前：保持 RLS 关闭（默认），登录通过 RPC 函数 verify_member_login()
-- 成员数据读取通过 anon key 直接访问 Supabase REST API

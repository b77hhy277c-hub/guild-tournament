-- ============================================
-- 公会任务管理工具 - Supabase 数据库建表 SQL
-- 在 Supabase SQL Editor 中执行此文件
-- ============================================

-- 1. 成员表
CREATE TABLE IF NOT EXISTS members (
  id              UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  display_id      TEXT UNIQUE NOT NULL,
  passcode_hash   TEXT,
  passcode_set    BOOLEAN DEFAULT FALSE,
  nickname        TEXT DEFAULT '',
  role            TEXT DEFAULT '',
  level           TEXT DEFAULT '',
  available_time  TEXT DEFAULT '',
  contact         TEXT DEFAULT '',
  is_admin        BOOLEAN DEFAULT FALSE,
  created_at      TIMESTAMPTZ DEFAULT NOW(),
  updated_at      TIMESTAMPTZ DEFAULT NOW()
);

-- 2. 任务表
CREATE TABLE IF NOT EXISTS tasks (
  id              UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  title           TEXT NOT NULL,
  description     TEXT DEFAULT '',
  category        TEXT DEFAULT 'daily',
  requirements    TEXT DEFAULT '',
  status          TEXT DEFAULT 'open'
                  CHECK (status IN ('open', 'in_progress', 'completed', 'verified', 'stale')),
  claimed_by      UUID REFERENCES members(id) ON DELETE SET NULL,
  completed_at    TIMESTAMPTZ,
  verified_by     UUID REFERENCES members(id) ON DELETE SET NULL,
  created_by      UUID REFERENCES members(id) ON DELETE SET NULL,
  stale_since     TIMESTAMPTZ,
  notes           TEXT DEFAULT '',
  created_at      TIMESTAMPTZ DEFAULT NOW(),
  updated_at      TIMESTAMPTZ DEFAULT NOW()
);

-- 3. 成员任务能力表
CREATE TABLE IF NOT EXISTS member_task_capabilities (
  id              UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  member_id       UUID NOT NULL REFERENCES members(id) ON DELETE CASCADE,
  task_id         UUID NOT NULL REFERENCES tasks(id) ON DELETE CASCADE,
  can_do          BOOLEAN DEFAULT FALSE,
  notes           TEXT DEFAULT '',
  updated_at      TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(member_id, task_id)
);

-- 4. 任务操作日志表
CREATE TABLE IF NOT EXISTS task_history (
  id              UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  task_id         UUID NOT NULL REFERENCES tasks(id) ON DELETE CASCADE,
  member_id       UUID NOT NULL REFERENCES members(id) ON DELETE CASCADE,
  action          TEXT NOT NULL
                  CHECK (action IN ('created', 'claimed', 'completed', 'verified', 'staled', 'deleted')),
  detail          TEXT DEFAULT '',
  created_at      TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- 索引
-- ============================================
CREATE INDEX IF NOT EXISTS idx_members_display_id ON members(display_id);
CREATE INDEX IF NOT EXISTS idx_members_is_admin ON members(is_admin);
CREATE INDEX IF NOT EXISTS idx_tasks_status ON tasks(status);
CREATE INDEX IF NOT EXISTS idx_tasks_category ON tasks(category);
CREATE INDEX IF NOT EXISTS idx_tasks_claimed_by ON tasks(claimed_by);
CREATE INDEX IF NOT EXISTS idx_tasks_created_by ON tasks(created_by);
CREATE INDEX IF NOT EXISTS idx_capabilities_member ON member_task_capabilities(member_id);
CREATE INDEX IF NOT EXISTS idx_capabilities_task ON member_task_capabilities(task_id);
CREATE INDEX IF NOT EXISTS idx_history_task ON task_history(task_id);
CREATE INDEX IF NOT EXISTS idx_history_member ON task_history(member_id);

-- ============================================
-- 自动更新 updated_at
-- ============================================
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

CREATE TRIGGER trg_tasks_updated_at
  BEFORE UPDATE ON tasks
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER trg_capabilities_updated_at
  BEFORE UPDATE ON member_task_capabilities
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- ============================================
-- Row Level Security (RLS) 策略
-- ============================================
ALTER TABLE members ENABLE ROW LEVEL SECURITY;
ALTER TABLE tasks ENABLE ROW LEVEL SECURITY;
ALTER TABLE member_task_capabilities ENABLE ROW LEVEL SECURITY;
ALTER TABLE task_history ENABLE ROW LEVEL SECURITY;

-- members 表：所有人可读（需要 ID 列表），只有本人或管理员可写
CREATE POLICY "members_read_all" ON members
  FOR SELECT USING (true);

CREATE POLICY "members_insert_admin" ON members
  FOR INSERT WITH CHECK (TRUE);  -- 允许插入（实际通过 API 控制）

CREATE POLICY "members_update_self_or_admin" ON members
  FOR UPDATE USING (
    auth.uid() = id OR
    EXISTS (SELECT 1 FROM members WHERE id = auth.uid() AND is_admin = TRUE)
  );

CREATE POLICY "members_delete_admin" ON members
  FOR DELETE USING (
    EXISTS (SELECT 1 FROM members WHERE id = auth.uid() AND is_admin = TRUE)
  );

-- tasks 表：所有人可读，管理员可写，成员可更新认领状态
CREATE POLICY "tasks_read_all" ON tasks
  FOR SELECT USING (true);

CREATE POLICY "tasks_insert_admin" ON tasks
  FOR INSERT WITH CHECK (
    EXISTS (SELECT 1 FROM members WHERE id = auth.uid() AND is_admin = TRUE)
  );

CREATE POLICY "tasks_update_admin_or_claimer" ON tasks
  FOR UPDATE USING (
    EXISTS (SELECT 1 FROM members WHERE id = auth.uid() AND is_admin = TRUE) OR
    claimed_by = auth.uid()
  );

CREATE POLICY "tasks_delete_admin" ON tasks
  FOR DELETE USING (
    EXISTS (SELECT 1 FROM members WHERE id = auth.uid() AND is_admin = TRUE)
  );

-- member_task_capabilities：所有人可读，只能编辑自己的
CREATE POLICY "capabilities_read_all" ON member_task_capabilities
  FOR SELECT USING (true);

CREATE POLICY "capabilities_insert_own" ON member_task_capabilities
  FOR INSERT WITH CHECK (member_id = auth.uid());

CREATE POLICY "capabilities_update_own" ON member_task_capabilities
  FOR UPDATE USING (member_id = auth.uid());

CREATE POLICY "capabilities_delete_own_or_admin" ON member_task_capabilities
  FOR DELETE USING (
    member_id = auth.uid() OR
    EXISTS (SELECT 1 FROM members WHERE id = auth.uid() AND is_admin = TRUE)
  );

-- task_history：所有人可读，系统自动写入
CREATE POLICY "history_read_all" ON task_history
  FOR SELECT USING (true);

CREATE POLICY "history_insert_all" ON task_history
  FOR INSERT WITH CHECK (true);

-- ============================================
-- 初始管理员账号（请修改为自己的 display_id）
-- ============================================
-- INSERT INTO members (display_id, nickname, is_admin) VALUES ('admin', '公会管理', true);
-- 注意：管理员也需要通过 login 页面首次登录设置口令

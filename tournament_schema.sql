-- ============================================
-- 公会竞标赛 v2 - 新结构
-- L1: 人才/艺人/守护神/其他 (4个)
-- 人才&艺人下: 属性筛选 农/商/文/娱
-- 皮肤合并到人才/艺人的 L3 勾选项中
-- ============================================

-- ==================== 建表（先删后建，确保列最新） ====================
DROP TABLE IF EXISTS member_task_abilities CASCADE;
DROP TABLE IF EXISTS member_season_config CASCADE;
DROP TABLE IF EXISTS task_definitions CASCADE;
DROP TABLE IF EXISTS task_categories CASCADE;

CREATE TABLE task_categories (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  parent_id UUID REFERENCES task_categories(id) ON DELETE CASCADE,
  level INTEGER DEFAULT 1,
  name TEXT NOT NULL,
  sort_order INTEGER DEFAULT 0
);

CREATE TABLE task_definitions (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  category_id UUID NOT NULL REFERENCES task_categories(id) ON DELETE CASCADE,
  task_code TEXT NOT NULL,
  task_name TEXT NOT NULL,
  display_name TEXT,
  default_score INTEGER DEFAULT 0,
  is_skin BOOLEAN DEFAULT FALSE,
  is_recommended BOOLEAN DEFAULT TRUE,
  sort_order INTEGER DEFAULT 0
);

CREATE TABLE member_task_abilities (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  member_id UUID NOT NULL REFERENCES members(id) ON DELETE CASCADE,
  task_definition_id UUID NOT NULL REFERENCES task_definitions(id) ON DELETE CASCADE,
  is_able BOOLEAN DEFAULT FALSE,
  quantity INTEGER DEFAULT 0,
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(member_id, task_definition_id)
);

CREATE TABLE member_season_config (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  member_id UUID NOT NULL REFERENCES members(id) ON DELETE CASCADE,
  season_id UUID NOT NULL REFERENCES seasons(id) ON DELETE CASCADE,
  can_accept BOOLEAN DEFAULT TRUE,
  target_score INTEGER DEFAULT 0,
  available_attempts INTEGER DEFAULT 1,
  avg_score INTEGER DEFAULT 0,
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(member_id, season_id)
);

-- ================================================================
-- ██ L1: 4大分类
-- ================================================================
INSERT INTO task_categories (id, parent_id, level, name, sort_order) VALUES
  ('c1000000-0000-4000-8000-000000000001', null, 1, '人才',   1),
  ('c1000000-0000-4000-8000-000000000002', null, 1, '艺人',   2),
  ('c1000000-0000-4000-8000-000000000003', null, 1, '守护神', 3),
  ('c1000000-0000-4000-8000-000000000004', null, 1, '其他',   4);

-- ================================================================
-- ██ L2: 人才下 4个属性
-- ================================================================
INSERT INTO task_categories (id, parent_id, level, name, sort_order) VALUES
  ('c2000a00-0000-4000-8000-000000000001', 'c1000000-0000-4000-8000-000000000001', 2, '农', 1),
  ('c2000a00-0000-4000-8000-000000000002', 'c1000000-0000-4000-8000-000000000001', 2, '商', 2),
  ('c2000a00-0000-4000-8000-000000000003', 'c1000000-0000-4000-8000-000000000001', 2, '文', 3),
  ('c2000a00-0000-4000-8000-000000000004', 'c1000000-0000-4000-8000-000000000001', 2, '娱', 4);

-- ██ L2: 艺人下 4个属性
INSERT INTO task_categories (id, parent_id, level, name, sort_order) VALUES
  ('c2000b00-0000-4000-8000-000000000001', 'c1000000-0000-4000-8000-000000000002', 2, '农', 1),
  ('c2000b00-0000-4000-8000-000000000002', 'c1000000-0000-4000-8000-000000000002', 2, '商', 2),
  ('c2000b00-0000-4000-8000-000000000003', 'c1000000-0000-4000-8000-000000000002', 2, '文', 3),
  ('c2000b00-0000-4000-8000-000000000004', 'c1000000-0000-4000-8000-000000000002', 2, '娱', 4);

-- ██ L2: 守护神下 2个组合
INSERT INTO task_categories (id, parent_id, level, name, sort_order) VALUES
  ('c2000c00-0000-4000-8000-000000000001', 'c1000000-0000-4000-8000-000000000003', 2, '四灵传说', 1),
  ('c2000c00-0000-4000-8000-000000000002', 'c1000000-0000-4000-8000-000000000003', 2, '上古神兽', 2);

-- ██ L2: 其他下 5个分类
INSERT INTO task_categories (id, parent_id, level, name, sort_order) VALUES
  ('c2000d00-0000-4000-8000-000000000001', 'c1000000-0000-4000-8000-000000000004', 2, '活动任务', 1),
  ('c2000d00-0000-4000-8000-000000000002', 'c1000000-0000-4000-8000-000000000004', 2, '限时挑战', 2),
  ('c2000d00-0000-4000-8000-000000000003', 'c1000000-0000-4000-8000-000000000004', 2, '副本通关', 3),
  ('c2000d00-0000-4000-8000-000000000004', 'c1000000-0000-4000-8000-000000000004', 2, '收集材料', 4),
  ('c2000d00-0000-4000-8000-000000000005', 'c1000000-0000-4000-8000-000000000004', 2, '成就完成', 5);

-- ================================================================
-- ██ L3: 每个属性下的人才/艺人/守护神
-- ================================================================

-- 人才 - 农
INSERT INTO task_categories (id, parent_id, level, name, sort_order) VALUES
  ('c3000a10-0000-4000-8000-000000000001', 'c2000a00-0000-4000-8000-000000000001', 3, '诸葛亮', 1),
  ('c3000a10-0000-4000-8000-000000000002', 'c2000a00-0000-4000-8000-000000000001', 3, '关羽',   2);
-- 人才 - 商
INSERT INTO task_categories (id, parent_id, level, name, sort_order) VALUES
  ('c3000a20-0000-4000-8000-000000000001', 'c2000a00-0000-4000-8000-000000000002', 3, '吕布', 1),
  ('c3000a20-0000-4000-8000-000000000002', 'c2000a00-0000-4000-8000-000000000002', 3, '貂蝉', 2);
-- 人才 - 文
INSERT INTO task_categories (id, parent_id, level, name, sort_order) VALUES
  ('c3000a30-0000-4000-8000-000000000001', 'c2000a00-0000-4000-8000-000000000003', 3, '周瑜', 1);
-- 人才 - 娱
INSERT INTO task_categories (id, parent_id, level, name, sort_order) VALUES
  ('c3000a40-0000-4000-8000-000000000001', 'c2000a00-0000-4000-8000-000000000004', 3, '孙尚香', 1);

-- 艺人 - 农
INSERT INTO task_categories (id, parent_id, level, name, sort_order) VALUES
  ('c3000b10-0000-4000-8000-000000000001', 'c2000b00-0000-4000-8000-000000000001', 3, '周杰伦', 1);
-- 艺人 - 商
INSERT INTO task_categories (id, parent_id, level, name, sort_order) VALUES
  ('c3000b20-0000-4000-8000-000000000001', 'c2000b00-0000-4000-8000-000000000002', 3, '林俊杰', 1);
-- 艺人 - 文
INSERT INTO task_categories (id, parent_id, level, name, sort_order) VALUES
  ('c3000b30-0000-4000-8000-000000000001', 'c2000b00-0000-4000-8000-000000000003', 3, '蔡依林', 1);
-- 艺人 - 娱
INSERT INTO task_categories (id, parent_id, level, name, sort_order) VALUES
  ('c3000b40-0000-4000-8000-000000000001', 'c2000b00-0000-4000-8000-000000000004', 3, '邓紫棋', 1),
  ('c3000b40-0000-4000-8000-000000000002', 'c2000b00-0000-4000-8000-000000000004', 3, '陈奕迅', 2);

-- 守护神 - 四灵传说
INSERT INTO task_categories (id, parent_id, level, name, sort_order) VALUES
  ('c3000c10-0000-4000-8000-000000000001', 'c2000c00-0000-4000-8000-000000000001', 3, '青龙', 1),
  ('c3000c10-0000-4000-8000-000000000002', 'c2000c00-0000-4000-8000-000000000001', 3, '白虎', 2),
  ('c3000c10-0000-4000-8000-000000000003', 'c2000c00-0000-4000-8000-000000000001', 3, '朱雀', 3),
  ('c3000c10-0000-4000-8000-000000000004', 'c2000c00-0000-4000-8000-000000000001', 3, '玄武', 4);
-- 守护神 - 上古神兽
INSERT INTO task_categories (id, parent_id, level, name, sort_order) VALUES
  ('c3000c20-0000-4000-8000-000000000001', 'c2000c00-0000-4000-8000-000000000002', 3, '饕餮', 1),
  ('c3000c20-0000-4000-8000-000000000002', 'c2000c00-0000-4000-8000-000000000002', 3, '穷奇', 2),
  ('c3000c20-0000-4000-8000-000000000003', 'c2000c00-0000-4000-8000-000000000002', 3, '梼杌', 3),
  ('c3000c20-0000-4000-8000-000000000004', 'c2000c00-0000-4000-8000-000000000002', 3, '混沌', 4);


-- ================================================================
-- ██ Task Definitions (L3 → 具体勾选项)
-- ================================================================

-- ──── 人才：7个等级任务 ────
DO $$
DECLARE
  r RECORD;
BEGIN
  FOR r IN
    SELECT id FROM task_categories
    WHERE parent_id IN (
      'c2000a00-0000-4000-8000-000000000001',
      'c2000a00-0000-4000-8000-000000000002',
      'c2000a00-0000-4000-8000-000000000003',
      'c2000a00-0000-4000-8000-000000000004'
    )
  LOOP
    INSERT INTO task_definitions (category_id, task_code, task_name, default_score, sort_order) VALUES
      (r.id, 'own',     '拥有人才', 10, 1),
      (r.id, 'lv500',   '满500级',  20, 2),
      (r.id, 'lv600',   '满600级',  30, 3),
      (r.id, 'lv700',   '满700级',  50, 4),
      (r.id, 'lv750',   '满750级',  80, 5),
      (r.id, 'awaken1', '觉醒+1',  100, 6),
      (r.id, 'awaken2', '觉醒+2',  150, 7);
  END LOOP;
END $$;

-- ──── 人才：3个皮肤任务 (is_skin=true) ────
DO $$
DECLARE
  r RECORD;
BEGIN
  FOR r IN
    SELECT id FROM task_categories
    WHERE parent_id IN (
      'c2000a00-0000-4000-8000-000000000001',
      'c2000a00-0000-4000-8000-000000000002',
      'c2000a00-0000-4000-8000-000000000003',
      'c2000a00-0000-4000-8000-000000000004'
    )
  LOOP
    INSERT INTO task_definitions (category_id, task_code, task_name, default_score, is_skin, sort_order) VALUES
      (r.id, 'skin_classic', '经典皮肤', 15,  TRUE, 8),
      (r.id, 'skin_epic',    '史诗皮肤', 40,  TRUE, 9),
      (r.id, 'skin_legend',  '传说皮肤', 100, TRUE, 10);
  END LOOP;
END $$;

-- ──── 艺人：1个拥有任务 + 3个皮肤 ────
DO $$
DECLARE
  r RECORD;
BEGIN
  FOR r IN
    SELECT id FROM task_categories
    WHERE parent_id IN (
      'c2000b00-0000-4000-8000-000000000001',
      'c2000b00-0000-4000-8000-000000000002',
      'c2000b00-0000-4000-8000-000000000003',
      'c2000b00-0000-4000-8000-000000000004'
    )
  LOOP
    INSERT INTO task_definitions (category_id, task_code, task_name, default_score, is_skin, sort_order) VALUES
      (r.id, 'own',          '拥有艺人', 25,  FALSE, 1),
      (r.id, 'skin_stage',   '舞台造型',  20,  TRUE,  2),
      (r.id, 'skin_mv',      'MV造型',    50,  TRUE,  3),
      (r.id, 'skin_legend',  '传奇造型',  120, TRUE,  4);
  END LOOP;
END $$;

-- ──── 守护神：每个1个任务 ────
DO $$
DECLARE
  r RECORD;
BEGIN
  FOR r IN
    SELECT id FROM task_categories
    WHERE parent_id IN (
      'c2000c00-0000-4000-8000-000000000001',
      'c2000c00-0000-4000-8000-000000000002'
    )
  LOOP
    INSERT INTO task_definitions (category_id, task_code, task_name, default_score, sort_order) VALUES
      (r.id, 'own', '拥有守护神', 60, 1);
  END LOOP;
END $$;

-- ──── 其他：每个子分类下具体任务 ────
INSERT INTO task_definitions (category_id, task_code, task_name, default_score, sort_order) VALUES
  ('c2000d00-0000-4000-8000-000000000001', 'event_daily',  '每日签到',  5,  1),
  ('c2000d00-0000-4000-8000-000000000001', 'event_weekly', '周活跃',    15, 2),
  ('c2000d00-0000-4000-8000-000000000002', 'boss',   '击败世界Boss', 80, 1),
  ('c2000d00-0000-4000-8000-000000000002', 'arena',  '竞技场连胜',   50, 2),
  ('c2000d00-0000-4000-8000-000000000003', 'hell',   '通关地狱副本', 100, 1),
  ('c2000d00-0000-4000-8000-000000000003', 'speed',  '限时通关',     70, 2),
  ('c2000d00-0000-4000-8000-000000000004', 'rare',   '收集稀有材料', 30, 1),
  ('c2000d00-0000-4000-8000-000000000004', 'epic',   '收集史诗材料', 60, 2),
  ('c2000d00-0000-4000-8000-000000000005', 'ach100', '达成100成就',  40, 1),
  ('c2000d00-0000-4000-8000-000000000005', 'ach500', '达成500成就',  200, 2);

-- ==================== 索引 ====================
CREATE INDEX IF NOT EXISTS idx_tc_parent  ON task_categories(parent_id);
CREATE INDEX IF NOT EXISTS idx_td_cat     ON task_definitions(category_id);
CREATE INDEX IF NOT EXISTS idx_mta_member ON member_task_abilities(member_id);
CREATE INDEX IF NOT EXISTS idx_mta_def    ON member_task_abilities(task_definition_id);
CREATE INDEX IF NOT EXISTS idx_msc_member ON member_season_config(member_id);
CREATE INDEX IF NOT EXISTS idx_msc_season ON member_season_config(season_id);

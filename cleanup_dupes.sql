-- 自动清理 task_categories 中同 parent_id + name 的重复记录
-- 使用 row_number 窗口函数替代 MIN(id)

-- 1. 先删除重复 category 对应的 task_definitions
DELETE FROM task_definitions
WHERE category_id IN (
  SELECT id FROM (
    SELECT id, ROW_NUMBER() OVER (PARTITION BY parent_id, name ORDER BY sort_order ASC, id ASC) AS rn
    FROM task_categories WHERE level = 3
  ) sub WHERE rn > 1
);

-- 2. 删除重复的 category 行（保留 sort_order 最小、id 最小的）
DELETE FROM task_categories
WHERE id IN (
  SELECT id FROM (
    SELECT id, ROW_NUMBER() OVER (PARTITION BY parent_id, name ORDER BY sort_order ASC, id ASC) AS rn
    FROM task_categories WHERE level = 3
  ) sub WHERE rn > 1
);

-- 3. 验证：应该返回 0 行
SELECT parent_id, name, COUNT(*) as cnt
FROM task_categories
WHERE level = 3
GROUP BY parent_id, name
HAVING COUNT(*) > 1;

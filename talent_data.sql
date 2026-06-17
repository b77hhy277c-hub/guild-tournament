-- 清空现有人才/艺人数据，重新录入
DELETE FROM task_definitions WHERE category_id IN (
  SELECT id FROM task_categories WHERE parent_id IN (
    'c2000a00-0000-4000-8000-000000000001',
    'c2000a00-0000-4000-8000-000000000002',
    'c2000a00-0000-4000-8000-000000000003'
  )
);
DELETE FROM task_categories WHERE parent_id IN (
  'c2000a00-0000-4000-8000-000000000001',
  'c2000a00-0000-4000-8000-000000000002',
  'c2000a00-0000-4000-8000-000000000003'
);

-- ==================== 农 ====================
INSERT INTO task_categories (id, parent_id, level, name, sort_order) VALUES
  ('74671e75-df9e-4d3e-8a2d-8dab81b303d0', 'c2000a00-0000-4000-8000-000000000001', 3, '乾隆', 1),
  ('6bf4899a-70f1-4f99-82cb-63fe611fa3e5', 'c2000a00-0000-4000-8000-000000000001', 3, '小燕子', 2),
  ('8fdb110e-5a33-4b6e-94f7-991a7a7bb918', 'c2000a00-0000-4000-8000-000000000001', 3, '武松', 3),
  ('d99dc466-271b-4a8e-bce6-ed785e54942a', 'c2000a00-0000-4000-8000-000000000001', 3, '白素贞', 4),
  ('418c0c9e-a992-4dbd-9613-2c8e61986051', 'c2000a00-0000-4000-8000-000000000001', 3, '丽萍', 5),
  ('db02d2a5-d600-4909-9d27-39411354f26b', 'c2000a00-0000-4000-8000-000000000001', 3, '登山员', 6),
  ('7999a102-afbc-489c-9fc4-e8d767a4b7c3', 'c2000a00-0000-4000-8000-000000000001', 3, '何律师', 7),
  ('4e3ff573-5b43-4a53-be91-3766c2a5a49a', 'c2000a00-0000-4000-8000-000000000001', 3, '一代大侠', 8),
  ('47f6ec69-ea35-41f5-9686-e2eaa62fdec6', 'c2000a00-0000-4000-8000-000000000001', 3, '菜雕师', 9),
  ('e4373067-1228-43c2-a64a-26f70472b574', 'c2000a00-0000-4000-8000-000000000001', 3, '唐志强', 10),
  ('957a095b-b1dd-411e-9008-d8af45648729', 'c2000a00-0000-4000-8000-000000000001', 3, '渔三哥', 11),
  ('41e5dda5-cc8e-45d8-9fde-b1d65ce483df', 'c2000a00-0000-4000-8000-000000000001', 3, '非主流', 12),
  ('bf2cca2c-184b-4f1b-a225-d1e7933ecc05', 'c2000a00-0000-4000-8000-000000000001', 3, '白铁匠', 13),
  ('0906747a-6249-4df9-81bb-fba5e137c6d3', 'c2000a00-0000-4000-8000-000000000001', 3, '阿星', 14);

-- ==================== 商 ====================
INSERT INTO task_categories (id, parent_id, level, name, sort_order) VALUES
  ('023a5c69-3d94-47ed-8d2e-19904f1f4ecc', 'c2000a00-0000-4000-8000-000000000002', 3, '高启强', 1),
  ('4345fcb8-9ec5-48b0-ae05-725948042a92', 'c2000a00-0000-4000-8000-000000000002', 3, '聂小倩', 2),
  ('9d1fe261-5ad6-44bf-8bdf-a218365aa5fe', 'c2000a00-0000-4000-8000-000000000002', 3, '强哥', 3),
  ('03ba9230-86b9-4a1c-a3ad-d7d7c02f0719', 'c2000a00-0000-4000-8000-000000000002', 3, '永琪', 4),
  ('137319b0-3aab-4830-ad48-66be95d8686d', 'c2000a00-0000-4000-8000-000000000002', 3, '郑经理', 5),
  ('5fee9ed7-1619-42bb-ae37-540a0fbc826f', 'c2000a00-0000-4000-8000-000000000002', 3, '倪冬梅', 6),
  ('ad30e6b7-7b01-4eea-a804-52bfeafc113f', 'c2000a00-0000-4000-8000-000000000002', 3, '宋江', 7),
  ('8f349363-5936-4cbe-a82a-02d4ef7d116b', 'c2000a00-0000-4000-8000-000000000002', 3, '张良', 8),
  ('f6cca1fa-59d7-4e7e-ad05-bfc8cf32b367', 'c2000a00-0000-4000-8000-000000000002', 3, '青丘神女', 9),
  ('2480bc9e-99b3-4be5-be04-c349a5e4c05e', 'c2000a00-0000-4000-8000-000000000002', 3, '摇滚明星', 10),
  ('234736c1-fb30-4ac8-be04-4d37463a8e58', 'c2000a00-0000-4000-8000-000000000002', 3, '周大头', 11),
  ('084f5766-0a1a-4deb-aa11-fec655cba812', 'c2000a00-0000-4000-8000-000000000002', 3, '彪子', 12),
  ('ba1980ee-06c6-46bf-9477-caa526142e61', 'c2000a00-0000-4000-8000-000000000002', 3, '电工陈', 13),
  ('a01c7c79-88ee-4491-87a6-fa9b586ed57c', 'c2000a00-0000-4000-8000-000000000002', 3, '赵阿棉', 14),
  ('7ec27b9e-c2c5-49e1-bc40-7df4ebff7516', 'c2000a00-0000-4000-8000-000000000002', 3, '潘远航', 15),
  ('570bd846-b67c-49bf-b863-25bd71adeaef', 'c2000a00-0000-4000-8000-000000000002', 3, '韩信', 16);

-- ==================== 文 ====================
INSERT INTO task_categories (id, parent_id, level, name, sort_order) VALUES
  ('2dd2eafd-701b-440f-ad11-73822a132973', 'c2000a00-0000-4000-8000-000000000003', 3, '武则天', 1),
  ('c3fed66e-03e9-446e-a3d7-cdf48f6771ce', 'c2000a00-0000-4000-8000-000000000003', 3, '红衣教主', 2),
  ('d2d4fc21-fffb-4043-a28d-4740545ffcf9', 'c2000a00-0000-4000-8000-000000000003', 3, '林冲', 3),
  ('1c82b273-0c6a-4c0f-bdbd-fcec04c3488e', 'c2000a00-0000-4000-8000-000000000003', 3, '步惊云', 4),
  ('e88c57b4-755e-4439-ab32-f074eec73be6', 'c2000a00-0000-4000-8000-000000000003', 3, '聂风', 5),
  ('a5ef0044-3697-43ea-ab3f-566f581262ea', 'c2000a00-0000-4000-8000-000000000003', 3, '夏紫薇', 6),
  ('c6318cfa-8b3b-46d2-a34b-6570e70a29bd', 'c2000a00-0000-4000-8000-000000000003', 3, '书文', 7),
  ('6e02e582-7b3a-4f88-a808-be61a44a4db7', 'c2000a00-0000-4000-8000-000000000003', 3, '曾守信', 8),
  ('50be72e7-12f2-46cd-8c31-82b9ce09a4f8', 'c2000a00-0000-4000-8000-000000000003', 3, '主持人', 9),
  ('640d4e7b-a8dc-4555-922d-054b61e22aa6', 'c2000a00-0000-4000-8000-000000000003', 3, '陈医生', 10),
  ('f0c9d1f7-9779-4170-a0b9-c489e1c9766e', 'c2000a00-0000-4000-8000-000000000003', 3, '刚毅', 11),
  ('ad753105-54f9-4d63-a0d1-216b3ba69550', 'c2000a00-0000-4000-8000-000000000003', 3, '多情浪子', 12),
  ('53c3bbea-ed6b-46e1-b51c-120bb3c8e1e2', 'c2000a00-0000-4000-8000-000000000003', 3, '李双', 13),
  ('097470af-e1e4-42ed-a2bd-65b57072262d', 'c2000a00-0000-4000-8000-000000000003', 3, '火炬手', 14),
  ('8fbe3f5f-6e3a-4eb9-a1eb-4e313432b04e', 'c2000a00-0000-4000-8000-000000000003', 3, '肖卫平', 15),
  ('c331f595-7d4a-480d-8391-2fbb91a0a6ea', 'c2000a00-0000-4000-8000-000000000003', 3, '孙糖画', 16),
  ('ab1c2876-3863-421c-866d-eb91fe374135', 'c2000a00-0000-4000-8000-000000000003', 3, '李书虫', 17);

-- ==================== 7个等级任务(所有人才) ====================
DO $$
DECLARE r RECORD;
BEGIN
  FOR r IN SELECT id FROM task_categories
    WHERE parent_id IN (
      'c2000a00-0000-4000-8000-000000000001',
      'c2000a00-0000-4000-8000-000000000002',
      'c2000a00-0000-4000-8000-000000000003'
    )
  LOOP
    INSERT INTO task_definitions (category_id, task_code, task_name, default_score, sort_order) VALUES
      (r.id, 'own',     '拥有人才', 10, 1),
      (r.id, 'lv400',   '满400级',  15, 2),
      (r.id, 'lv500',   '满500级',  20, 3),
      (r.id, 'lv600',   '满600级',  30, 4),
      (r.id, 'lv700',   '满700级',  50, 5),
      (r.id, 'lv750',   '满750级',  80, 6),
      (r.id, 'awaken1', '觉醒+1',  100, 7),
      (r.id, 'awaken2', '觉醒+2',  150, 8);
  END LOOP;
END $$;

-- ==================== 皮肤任务 ====================
-- 农 - 乾隆 (6 skins)
INSERT INTO task_definitions (category_id, task_code, task_name, default_score, is_skin, sort_order) VALUES
  ('74671e75-df9e-4d3e-8a2d-8dab81b303d0','skin_ssdd','盛世大帝',15,TRUE,9),('74671e75-df9e-4d3e-8a2d-8dab81b303d0','skin_ywss','遥望盛世',15,TRUE,10),('74671e75-df9e-4d3e-8a2d-8dab81b303d0','skin_dmhp','大明湖畔',15,TRUE,11),
  ('74671e75-df9e-4d3e-8a2d-8dab81b303d0','skin_yjqz','御驾亲征',15,TRUE,12),('74671e75-df9e-4d3e-8a2d-8dab81b303d0','skin_xyyq','闲游雅趣',15,TRUE,13),('74671e75-df9e-4d3e-8a2d-8dab81b303d0','skin_wysz','文渊圣主',15,TRUE,14);
-- 农 - 小燕子 (1 skin)
INSERT INTO task_definitions (category_id, task_code, task_name, default_score, is_skin, sort_order) VALUES
  ('6bf4899a-70f1-4f99-82cb-63fe611fa3e5','skin_qyht','雀跃欢腾',15,TRUE,9);
-- 农 - 武松 (1 skin)
INSERT INTO task_definitions (category_id, task_code, task_name, default_score, is_skin, sort_order) VALUES
  ('8fdb110e-5a33-4b6e-94f7-991a7a7bb918','skin_qrrh','侵略如火',15,TRUE,9);
-- 农 - 白素贞 (4 skins)
INSERT INTO task_definitions (category_id, task_code, task_name, default_score, is_skin, sort_order) VALUES
  ('d99dc466-271b-4a8e-bce6-ed785e54942a','skin_smjs','水漫金山',15,TRUE,9),('d99dc466-271b-4a8e-bce6-ed785e54942a','skin_xhxx','西湖夏憩',15,TRUE,10),
  ('d99dc466-271b-4a8e-bce6-ed785e54942a','skin_chxm','沧海仙梦',15,TRUE,11),('d99dc466-271b-4a8e-bce6-ed785e54942a','skin_jrnf','金蕊凝芳',15,TRUE,12);
-- 农 - 丽萍 (1 skin)
INSERT INTO task_definitions (category_id, task_code, task_name, default_score, is_skin, sort_order) VALUES
  ('418c0c9e-a992-4dbd-9613-2c8e61986051','skin_sjyh','市井烟火',15,TRUE,9);

-- 商 - 高启强 (7 skins)
INSERT INTO task_definitions (category_id, task_code, task_name, default_score, is_skin, sort_order) VALUES
  ('023a5c69-3d94-47ed-8d2e-19904f1f4ecc','skin_hhww','瀚海帷幄',15,TRUE,9),('023a5c69-3d94-47ed-8d2e-19904f1f4ecc','skin_fmbl','锋芒毕露',15,TRUE,10),('023a5c69-3d94-47ed-8d2e-19904f1f4ecc','skin_dsbf','电视风波',15,TRUE,11),
  ('023a5c69-3d94-47ed-8d2e-19904f1f4ecc','skin_xdcy','兄弟创业',15,TRUE,12),('023a5c69-3d94-47ed-8d2e-19904f1f4ecc','skin_sgxx','三国枭雄',15,TRUE,13),('023a5c69-3d94-47ed-8d2e-19904f1f4ecc','skin_qykc','权御狂潮',15,TRUE,14),
  ('023a5c69-3d94-47ed-8d2e-19904f1f4ecc','skin_qyss','权倾一世',15,TRUE,15);
-- 商 - 聂小倩 (4 skins)
INSERT INTO task_definitions (category_id, task_code, task_name, default_score, is_skin, sort_order) VALUES
  ('4345fcb8-9ec5-48b0-ae05-725948042a92','skin_bayh','彼岸幽魂',15,TRUE,9),('4345fcb8-9ec5-48b0-ae05-725948042a92','skin_axhm','皑雪寒梅',15,TRUE,10),
  ('4345fcb8-9ec5-48b0-ae05-725948042a92','skin_jyss','镜缘双生',15,TRUE,11),('4345fcb8-9ec5-48b0-ae05-725948042a92','skin_qzly','青竹流萤',15,TRUE,12);
-- 商 - 强哥 (1 skin)
INSERT INTO task_definitions (category_id, task_code, task_name, default_score, is_skin, sort_order) VALUES
  ('9d1fe261-5ad6-44bf-8bdf-a218365aa5fe','skin_fhsh','繁华盛会',15,TRUE,9);
-- 商 - 永琪 (1 skin)
INSERT INTO task_definitions (category_id, task_code, task_name, default_score, is_skin, sort_order) VALUES
  ('03ba9230-86b9-4a1c-a3ad-d7d7c02f0719','skin_cmzf','策马追风',15,TRUE,9);
-- 商 - 郑经理 (1 skin)
INSERT INTO task_definitions (category_id, task_code, task_name, default_score, is_skin, sort_order) VALUES
  ('137319b0-3aab-4830-ad48-66be95d8686d','skin_yqff','意气风发',15,TRUE,9);
-- 商 - 倪冬梅 (1 skin)
INSERT INTO task_definitions (category_id, task_code, task_name, default_score, is_skin, sort_order) VALUES
  ('5fee9ed7-1619-42bb-ae37-540a0fbc826f','skin_mspw','美食评委',15,TRUE,9);
-- 商 - 宋江 (2 skins)
INSERT INTO task_definitions (category_id, task_code, task_name, default_score, is_skin, sort_order) VALUES
  ('ad30e6b7-7b01-4eea-a804-52bfeafc113f','skin_jyls','聚义梁山',15,TRUE,9),('ad30e6b7-7b01-4eea-a804-52bfeafc113f','skin_qrjf','其疾如风',15,TRUE,10);
-- 商 - 张良 (1 skin)
INSERT INTO task_definitions (category_id, task_code, task_name, default_score, is_skin, sort_order) VALUES
  ('8f349363-5936-4cbe-a82a-02d4ef7d116b','skin_ycww','运筹帷幄',15,TRUE,9);
-- 商 - 青丘神女 (1 skin)
INSERT INTO task_definitions (category_id, task_code, task_name, default_score, is_skin, sort_order) VALUES
  ('f6cca1fa-59d7-4e7e-ad05-bfc8cf32b367','skin_cljx','重临九霄',15,TRUE,9);

-- 文 - 武则天 (5 skins)
INSERT INTO task_definitions (category_id, task_code, task_name, default_score, is_skin, sort_order) VALUES
  ('2dd2eafd-701b-440f-ad11-73822a132973','skin_zsnd','治世女帝',15,TRUE,9),('2dd2eafd-701b-440f-ad11-73822a132973','skin_lyjh','丽影惊鸿',15,TRUE,10),('2dd2eafd-701b-440f-ad11-73822a132973','skin_msqt','媚色倾唐',15,TRUE,11),
  ('2dd2eafd-701b-440f-ad11-73822a132973','skin_hssq','寒寺诗情',15,TRUE,12),('2dd2eafd-701b-440f-ad11-73822a132973','skin_hhhs','号令花神',15,TRUE,13);
-- 文 - 红衣教主 (3 skins)
INSERT INTO task_definitions (category_id, task_code, task_name, default_score, is_skin, sort_order) VALUES
  ('c3fed66e-03e9-446e-a3d7-cdf48f6771ce','skin_ytjh','一统江湖',15,TRUE,9),('c3fed66e-03e9-446e-a3d7-cdf48f6771ce','skin_xdqs','绣断秋色',15,TRUE,10),
  ('c3fed66e-03e9-446e-a3d7-cdf48f6771ce','skin_hmyx','红梅映雪',15,TRUE,11);
-- 文 - 林冲 (1 skin)
INSERT INTO task_definitions (category_id, task_code, task_name, default_score, is_skin, sort_order) VALUES
  ('d2d4fc21-fffb-4043-a28d-4740545ffcf9','skin_qxrl','其徐如林',15,TRUE,9);
-- 文 - 步惊云 (6 skins)
INSERT INTO task_definitions (category_id, task_code, task_name, default_score, is_skin, sort_order) VALUES
  ('1c82b273-0c6a-4c0f-bdbd-fcec04c3488e','skin_fyhb','风云合璧',15,TRUE,9),('1c82b273-0c6a-4c0f-bdbd-fcec04c3488e','skin_pyz','排云掌',15,TRUE,10),('1c82b273-0c6a-4c0f-bdbd-fcec04c3488e','skin_ylcc','云栖良辰',15,TRUE,11),
  ('1c82b273-0c6a-4c0f-bdbd-fcec04c3488e','skin_jshj','绝世好剑',15,TRUE,12),('1c82b273-0c6a-4c0f-bdbd-fcec04c3488e','skin_wsbj','无上霸剑',15,TRUE,13),('1c82b273-0c6a-4c0f-bdbd-fcec04c3488e','skin_htsl','骇浪屠龙',15,TRUE,14);
-- 文 - 聂风 (5 skins)
INSERT INTO task_definitions (category_id, task_code, task_name, default_score, is_skin, sort_order) VALUES
  ('e88c57b4-755e-4439-ab32-f074eec73be6','skin_fyhb2','风云合璧',15,TRUE,9),('e88c57b4-755e-4439-ab32-f074eec73be6','skin_jsmd','绝世魔刀',15,TRUE,10),('e88c57b4-755e-4439-ab32-f074eec73be6','skin_fst','风神腿',15,TRUE,11),
  ('e88c57b4-755e-4439-ab32-f074eec73be6','skin_xkdk','雪饮狂刀',15,TRUE,12),('e88c57b4-755e-4439-ab32-f074eec73be6','skin_qlfm','麒麟疯魔',15,TRUE,13);
-- 文 - 夏紫薇 (1 skin)
INSERT INTO task_definitions (category_id, task_code, task_name, default_score, is_skin, sort_order) VALUES
  ('a5ef0044-3697-43ea-ab3f-566f581262ea','skin_qysq','琴音诉情',15,TRUE,9);
-- 文 - 书文 (1 skin)
INSERT INTO task_definitions (category_id, task_code, task_name, default_score, is_skin, sort_order) VALUES
  ('c6318cfa-8b3b-46d2-a34b-6570e70a29bd','skin_mysx','墨韵书贤',15,TRUE,9);

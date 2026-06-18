-- 清空旧艺人数据（只删L3+任务，保留L1艺人和L2属性农/商/文/娱）
DELETE FROM task_definitions WHERE category_id IN (SELECT id FROM task_categories WHERE parent_id IN ('c2000b00-0000-4000-8000-000000000001','c2000b00-0000-4000-8000-000000000002','c2000b00-0000-4000-8000-000000000003','c2000b00-0000-4000-8000-000000000004'));
DELETE FROM task_categories WHERE parent_id IN ('c2000b00-0000-4000-8000-000000000001','c2000b00-0000-4000-8000-000000000002','c2000b00-0000-4000-8000-000000000003','c2000b00-0000-4000-8000-000000000004');

-- ====== 农 ======
INSERT INTO task_categories (id, parent_id, level, name, sort_order) VALUES
  ('fd7d7f7b-c407-4608-9ce8-f0b7393cc9b2', 'c2000b00-0000-4000-8000-000000000001', 3, '小燕子', 1),
  ('97a2e7bb-75e2-4c38-9459-21151f57fa1e', 'c2000b00-0000-4000-8000-000000000001', 3, '白素贞', 2),
  ('1ece9fec-292e-4b32-9089-b2e7277154f0', 'c2000b00-0000-4000-8000-000000000001', 3, '葬爱', 3),
  ('e43cccc1-8710-469f-9bd6-0b20285339b6', 'c2000b00-0000-4000-8000-000000000001', 3, '静静', 4),
  ('9c781540-6b8d-4d63-9419-1ce009c10e0f', 'c2000b00-0000-4000-8000-000000000001', 3, '英姿', 5),
  ('98c34f30-196b-40d7-96f9-a80d52943b8c', 'c2000b00-0000-4000-8000-000000000001', 3, '阿诗玛', 6),
  ('a9d14790-aac0-4b0e-afeb-db0ec6940dd0', 'c2000b00-0000-4000-8000-000000000001', 3, '素芬', 7),
  ('b67fcce2-d0b7-4e84-9d87-76ad4692dcca', 'c2000b00-0000-4000-8000-000000000001', 3, '云雪晴', 8),
  ('89d5451a-4cb7-4ddf-a962-97d1821e3210', 'c2000b00-0000-4000-8000-000000000001', 3, '吕销售', 9),
  ('e607c311-12f4-4874-a031-87cb5606b280', 'c2000b00-0000-4000-8000-000000000001', 3, '丫蛋', 10),
  ('51ecb27c-d429-45dd-b4de-f971d3117e85', 'c2000b00-0000-4000-8000-000000000001', 3, '艺术生', 11);
-- 农 拥有艺人
INSERT INTO task_definitions (category_id, task_code, task_name, default_score, sort_order) VALUES
  ('fd7d7f7b-c407-4608-9ce8-f0b7393cc9b2','own','拥有艺人',20,1),('97a2e7bb-75e2-4c38-9459-21151f57fa1e','own','拥有艺人',20,1),('1ece9fec-292e-4b32-9089-b2e7277154f0','own','拥有艺人',20,1),('e43cccc1-8710-469f-9bd6-0b20285339b6','own','拥有艺人',20,1),('9c781540-6b8d-4d63-9419-1ce009c10e0f','own','拥有艺人',20,1),('98c34f30-196b-40d7-96f9-a80d52943b8c','own','拥有艺人',20,1),('a9d14790-aac0-4b0e-afeb-db0ec6940dd0','own','拥有艺人',20,1),('b67fcce2-d0b7-4e84-9d87-76ad4692dcca','own','拥有艺人',20,1),('89d5451a-4cb7-4ddf-a962-97d1821e3210','own','拥有艺人',20,1),('e607c311-12f4-4874-a031-87cb5606b280','own','拥有艺人',20,1),('51ecb27c-d429-45dd-b4de-f971d3117e85','own','拥有艺人',20,1);
-- 农 - 小燕子 (2 skins)
INSERT INTO task_definitions (category_id, task_code, task_name, default_score, is_skin, sort_order) VALUES
  ('fd7d7f7b-c407-4608-9ce8-f0b7393cc9b2','skin_小燕子_0','雀跃不已',20,TRUE,1),('fd7d7f7b-c407-4608-9ce8-f0b7393cc9b2','skin_小燕子_1','莺歌飒爽',20,TRUE,2);
-- 农 - 白素贞 (2 skins)
INSERT INTO task_definitions (category_id, task_code, task_name, default_score, is_skin, sort_order) VALUES
  ('97a2e7bb-75e2-4c38-9459-21151f57fa1e','skin_白素贞_0','龙伴端阳',20,TRUE,1),('97a2e7bb-75e2-4c38-9459-21151f57fa1e','skin_白素贞_1','西湖之约',20,TRUE,2);
-- 农 - 葬爱 (2 skins)
INSERT INTO task_definitions (category_id, task_code, task_name, default_score, is_skin, sort_order) VALUES
  ('1ece9fec-292e-4b32-9089-b2e7277154f0','skin_葬爱_0','哥特公主',20,TRUE,1),('1ece9fec-292e-4b32-9089-b2e7277154f0','skin_葬爱_1','圣诞快乐',20,TRUE,2);
-- 农 - 静静 (1 skins)
INSERT INTO task_definitions (category_id, task_code, task_name, default_score, is_skin, sort_order) VALUES
  ('e43cccc1-8710-469f-9bd6-0b20285339b6','skin_静静_0','孟钰',20,TRUE,1);
-- 农 - 英姿 (2 skins)
INSERT INTO task_definitions (category_id, task_code, task_name, default_score, is_skin, sort_order) VALUES
  ('9c781540-6b8d-4d63-9419-1ce009c10e0f','skin_英姿_0','沙排青春',20,TRUE,1),('9c781540-6b8d-4d63-9419-1ce009c10e0f','skin_英姿_1','棋逢对手',20,TRUE,2);
-- 农 - 阿诗玛 (2 skins)
INSERT INTO task_definitions (category_id, task_code, task_name, default_score, is_skin, sort_order) VALUES
  ('98c34f30-196b-40d7-96f9-a80d52943b8c','skin_阿诗玛_0','苗寨风光',20,TRUE,1),('98c34f30-196b-40d7-96f9-a80d52943b8c','skin_阿诗玛_1','绚烂花火',20,TRUE,2);

-- ====== 商 ======
INSERT INTO task_categories (id, parent_id, level, name, sort_order) VALUES
  ('1d0b439c-acaa-40cd-ba0d-e610e3dc2a14', 'c2000b00-0000-4000-8000-000000000002', 3, '玫瑰小姐', 1),
  ('2afd30bc-944a-4b3c-b9c3-fe0f62b58f7b', 'c2000b00-0000-4000-8000-000000000002', 3, '春三十娘', 2),
  ('a5d85ad2-cad7-472a-a8ff-76c5e522acf3', 'c2000b00-0000-4000-8000-000000000002', 3, '港星', 3),
  ('f44a15b6-9495-4e4a-96b1-d0de4856b193', 'c2000b00-0000-4000-8000-000000000002', 3, '艳红', 4),
  ('dc46c1a7-2167-4564-8fbd-72fc68997b57', 'c2000b00-0000-4000-8000-000000000002', 3, '新娘子', 5),
  ('e65adbdd-26c5-485a-9dbc-fe9f92d6e36c', 'c2000b00-0000-4000-8000-000000000002', 3, '彩霞', 6),
  ('c2651790-4c15-4250-a2e9-bb9b00eabe99', 'c2000b00-0000-4000-8000-000000000002', 3, '聂小倩', 7),
  ('535e8cfb-dc08-4f7e-9ad4-e0a6b23f90e7', 'c2000b00-0000-4000-8000-000000000002', 3, '舞狮少女', 8),
  ('f3b16e66-abd1-44ba-b7d4-9e54153d53fe', 'c2000b00-0000-4000-8000-000000000002', 3, '桂芸', 9),
  ('d0390f0e-b246-4ad0-92b1-bba19245917c', 'c2000b00-0000-4000-8000-000000000002', 3, '机车女郎', 10),
  ('12e3f404-1f18-4adf-b9da-68769d261dbc', 'c2000b00-0000-4000-8000-000000000002', 3, '若楠', 11),
  ('d4bde5fe-b856-481c-a24b-cfbdb6a100aa', 'c2000b00-0000-4000-8000-000000000002', 3, '马教练', 12),
  ('f315ba1b-a80f-462d-ae0a-4841418631f1', 'c2000b00-0000-4000-8000-000000000002', 3, '校园歌手', 13),
  ('5a5a9d27-b27d-4d87-8fd5-fb940b5bcb68', 'c2000b00-0000-4000-8000-000000000002', 3, '青青', 14);
-- 商 拥有艺人
INSERT INTO task_definitions (category_id, task_code, task_name, default_score, sort_order) VALUES
  ('1d0b439c-acaa-40cd-ba0d-e610e3dc2a14','own','拥有艺人',20,1),('2afd30bc-944a-4b3c-b9c3-fe0f62b58f7b','own','拥有艺人',20,1),('a5d85ad2-cad7-472a-a8ff-76c5e522acf3','own','拥有艺人',20,1),('f44a15b6-9495-4e4a-96b1-d0de4856b193','own','拥有艺人',20,1),('dc46c1a7-2167-4564-8fbd-72fc68997b57','own','拥有艺人',20,1),('e65adbdd-26c5-485a-9dbc-fe9f92d6e36c','own','拥有艺人',20,1),('c2651790-4c15-4250-a2e9-bb9b00eabe99','own','拥有艺人',20,1),('535e8cfb-dc08-4f7e-9ad4-e0a6b23f90e7','own','拥有艺人',20,1),('f3b16e66-abd1-44ba-b7d4-9e54153d53fe','own','拥有艺人',20,1),('d0390f0e-b246-4ad0-92b1-bba19245917c','own','拥有艺人',20,1),('12e3f404-1f18-4adf-b9da-68769d261dbc','own','拥有艺人',20,1),('d4bde5fe-b856-481c-a24b-cfbdb6a100aa','own','拥有艺人',20,1),('f315ba1b-a80f-462d-ae0a-4841418631f1','own','拥有艺人',20,1),('5a5a9d27-b27d-4d87-8fd5-fb940b5bcb68','own','拥有艺人',20,1);
-- 商 - 玫瑰小姐 (3 skins)
INSERT INTO task_definitions (category_id, task_code, task_name, default_score, is_skin, sort_order) VALUES
  ('1d0b439c-acaa-40cd-ba0d-e610e3dc2a14','skin_玫瑰小姐_0','破棘盛放',20,TRUE,1),('1d0b439c-acaa-40cd-ba0d-e610e3dc2a14','skin_玫瑰小姐_1','流音韶光',20,TRUE,2),('1d0b439c-acaa-40cd-ba0d-e610e3dc2a14','skin_玫瑰小姐_2','自由飞驰',20,TRUE,3);
-- 商 - 春三十娘 (2 skins)
INSERT INTO task_definitions (category_id, task_code, task_name, default_score, is_skin, sort_order) VALUES
  ('2afd30bc-944a-4b3c-b9c3-fe0f62b58f7b','skin_春三十娘_0','牵丝迷情',20,TRUE,1),('2afd30bc-944a-4b3c-b9c3-fe0f62b58f7b','skin_春三十娘_1','一池春色',20,TRUE,2);
-- 商 - 港星 (2 skins)
INSERT INTO task_definitions (category_id, task_code, task_name, default_score, is_skin, sort_order) VALUES
  ('a5d85ad2-cad7-472a-a8ff-76c5e522acf3','skin_港星_0','蓦然回首',20,TRUE,1),('a5d85ad2-cad7-472a-a8ff-76c5e522acf3','skin_港星_1','帝女花',20,TRUE,2);
-- 商 - 新娘子 (1 skins)
INSERT INTO task_definitions (category_id, task_code, task_name, default_score, is_skin, sort_order) VALUES
  ('dc46c1a7-2167-4564-8fbd-72fc68997b57','skin_新娘子_0','荡起双桨',20,TRUE,1);
-- 商 - 彩霞 (1 skins)
INSERT INTO task_definitions (category_id, task_code, task_name, default_score, is_skin, sort_order) VALUES
  ('e65adbdd-26c5-485a-9dbc-fe9f92d6e36c','skin_彩霞_0','夜玫瑰',20,TRUE,1);
-- 商 - 聂小倩 (2 skins)
INSERT INTO task_definitions (category_id, task_code, task_name, default_score, is_skin, sort_order) VALUES
  ('c2651790-4c15-4250-a2e9-bb9b00eabe99','skin_聂小倩_0','林间倩影',20,TRUE,1),('c2651790-4c15-4250-a2e9-bb9b00eabe99','skin_聂小倩_1','皑雪琴声',20,TRUE,2);

-- ====== 文 ======
INSERT INTO task_categories (id, parent_id, level, name, sort_order) VALUES
  ('6a3f3195-8e13-4c92-8e52-5b3aa5cf6fcb', 'c2000b00-0000-4000-8000-000000000003', 3, '陈书婷', 1),
  ('6caabf9b-9be7-439f-8f52-c3be18fc6a93', 'c2000b00-0000-4000-8000-000000000003', 3, '高启兰', 2),
  ('9ba057d7-b1c3-4e6a-9361-17325b52b493', 'c2000b00-0000-4000-8000-000000000003', 3, '红衣教主', 3),
  ('6b51f407-7a8d-42a3-8783-e211577ed6de', 'c2000b00-0000-4000-8000-000000000003', 3, '淑珍', 4),
  ('a8908276-48bd-430e-8ae1-981120365d1d', 'c2000b00-0000-4000-8000-000000000003', 3, '童心', 5),
  ('5e9968c3-abd8-47c3-aaaa-cdc8a2119ed7', 'c2000b00-0000-4000-8000-000000000003', 3, '白居易', 6),
  ('b8256b50-519a-40f0-a617-56a69c185fca', 'c2000b00-0000-4000-8000-000000000003', 3, '铃儿', 7),
  ('118a3492-e455-44cc-bcfd-334ba4fa8b10', 'c2000b00-0000-4000-8000-000000000003', 3, '奕君', 8),
  ('a6c6a146-5da4-46b7-8290-10e25f3ebd2d', 'c2000b00-0000-4000-8000-000000000003', 3, '阿莲', 9),
  ('b4023752-6855-4fff-b1ee-73e738f60823', 'c2000b00-0000-4000-8000-000000000003', 3, '苏秘书', 10),
  ('7a4d0bd6-0453-484a-b69a-350a6b6f6a92', 'c2000b00-0000-4000-8000-000000000003', 3, '百灵鸟', 11),
  ('8d8ec04b-d5a6-474a-b077-02d3f9f82471', 'c2000b00-0000-4000-8000-000000000003', 3, '阿雅', 12),
  ('3b7f9008-2bd3-445a-996c-008eff6ff3f3', 'c2000b00-0000-4000-8000-000000000003', 3, '思敏', 13),
  ('89537e7e-1ac9-453a-971f-4821bbb4d44b', 'c2000b00-0000-4000-8000-000000000003', 3, '兰心', 14),
  ('7343595d-4e58-4c91-b7be-2021b0ea9c00', 'c2000b00-0000-4000-8000-000000000003', 3, '厂花', 15),
  ('35918e62-b276-4710-98a8-ab25d4903b84', 'c2000b00-0000-4000-8000-000000000003', 3, '小芳', 16);
-- 文 拥有艺人
INSERT INTO task_definitions (category_id, task_code, task_name, default_score, sort_order) VALUES
  ('6a3f3195-8e13-4c92-8e52-5b3aa5cf6fcb','own','拥有艺人',20,1),('6caabf9b-9be7-439f-8f52-c3be18fc6a93','own','拥有艺人',20,1),('9ba057d7-b1c3-4e6a-9361-17325b52b493','own','拥有艺人',20,1),('6b51f407-7a8d-42a3-8783-e211577ed6de','own','拥有艺人',20,1),('a8908276-48bd-430e-8ae1-981120365d1d','own','拥有艺人',20,1),('5e9968c3-abd8-47c3-aaaa-cdc8a2119ed7','own','拥有艺人',20,1),('b8256b50-519a-40f0-a617-56a69c185fca','own','拥有艺人',20,1),('118a3492-e455-44cc-bcfd-334ba4fa8b10','own','拥有艺人',20,1),('a6c6a146-5da4-46b7-8290-10e25f3ebd2d','own','拥有艺人',20,1),('b4023752-6855-4fff-b1ee-73e738f60823','own','拥有艺人',20,1),('7a4d0bd6-0453-484a-b69a-350a6b6f6a92','own','拥有艺人',20,1),('8d8ec04b-d5a6-474a-b077-02d3f9f82471','own','拥有艺人',20,1),('3b7f9008-2bd3-445a-996c-008eff6ff3f3','own','拥有艺人',20,1),('89537e7e-1ac9-453a-971f-4821bbb4d44b','own','拥有艺人',20,1),('7343595d-4e58-4c91-b7be-2021b0ea9c00','own','拥有艺人',20,1),('35918e62-b276-4710-98a8-ab25d4903b84','own','拥有艺人',20,1);
-- 文 - 陈书婷 (3 skins)
INSERT INTO task_definitions (category_id, task_code, task_name, default_score, is_skin, sort_order) VALUES
  ('6a3f3195-8e13-4c92-8e52-5b3aa5cf6fcb','skin_陈书婷_0','瀚海女王',20,TRUE,1),('6a3f3195-8e13-4c92-8e52-5b3aa5cf6fcb','skin_陈书婷_1','旖旎春睡',20,TRUE,2),('6a3f3195-8e13-4c92-8e52-5b3aa5cf6fcb','skin_陈书婷_2','鎏金夜宴',20,TRUE,3);
-- 文 - 高启兰 (2 skins)
INSERT INTO task_definitions (category_id, task_code, task_name, default_score, is_skin, sort_order) VALUES
  ('6caabf9b-9be7-439f-8f52-c3be18fc6a93','skin_高启兰_0','茶楼相会',20,TRUE,1),('6caabf9b-9be7-439f-8f52-c3be18fc6a93','skin_高启兰_1','千傩万象',20,TRUE,2);
-- 文 - 红衣教主 (2 skins)
INSERT INTO task_definitions (category_id, task_code, task_name, default_score, is_skin, sort_order) VALUES
  ('9ba057d7-b1c3-4e6a-9361-17325b52b493','skin_红衣教主_0','破剑秋月',20,TRUE,1),('9ba057d7-b1c3-4e6a-9361-17325b52b493','skin_红衣教主_1','秋光散断',20,TRUE,2);
-- 文 - 淑珍 (2 skins)
INSERT INTO task_definitions (category_id, task_code, task_name, default_score, is_skin, sort_order) VALUES
  ('6b51f407-7a8d-42a3-8783-e211577ed6de','skin_淑珍_0','璀璨时代',20,TRUE,1),('6b51f407-7a8d-42a3-8783-e211577ed6de','skin_淑珍_1','马术冠军',20,TRUE,2);
-- 文 - 童心 (1 skins)
INSERT INTO task_definitions (category_id, task_code, task_name, default_score, is_skin, sort_order) VALUES
  ('a8908276-48bd-430e-8ae1-981120365d1d','skin_童心_0','午后闲扰',20,TRUE,1);
-- 文 - 白居易 (1 skins)
INSERT INTO task_definitions (category_id, task_code, task_name, default_score, is_skin, sort_order) VALUES
  ('5e9968c3-abd8-47c3-aaaa-cdc8a2119ed7','skin_白居易_0','天涯故交',20,TRUE,1);
-- 文 - 铃儿 (1 skins)
INSERT INTO task_definitions (category_id, task_code, task_name, default_score, is_skin, sort_order) VALUES
  ('b8256b50-519a-40f0-a617-56a69c185fca','skin_铃儿_0','浆漾童夏',20,TRUE,1);
-- 文 - 奕君 (1 skins)
INSERT INTO task_definitions (category_id, task_code, task_name, default_score, is_skin, sort_order) VALUES
  ('118a3492-e455-44cc-bcfd-334ba4fa8b10','skin_奕君_0','风光留影',20,TRUE,1);
-- 文 - 阿莲 (1 skins)
INSERT INTO task_definitions (category_id, task_code, task_name, default_score, is_skin, sort_order) VALUES
  ('a6c6a146-5da4-46b7-8290-10e25f3ebd2d','skin_阿莲_0','喜收硕果',20,TRUE,1);
-- 文 - 百灵鸟 (1 skins)
INSERT INTO task_definitions (category_id, task_code, task_name, default_score, is_skin, sort_order) VALUES
  ('7a4d0bd6-0453-484a-b69a-350a6b6f6a92','skin_百灵鸟_0','晨曦鸟语',20,TRUE,1);

-- ====== 娱 ======
INSERT INTO task_categories (id, parent_id, level, name, sort_order) VALUES
  ('b56bf4fe-75d0-40c6-8712-701f30532998', 'c2000b00-0000-4000-8000-000000000004', 3, '含香', 1),
  ('62cca4a9-1193-4fbe-96dd-fa5ebf91aec6', 'c2000b00-0000-4000-8000-000000000004', 3, '夏雨荷', 2),
  ('f8ed1cb9-8ea3-4fa7-8df1-e38f0397622f', 'c2000b00-0000-4000-8000-000000000004', 3, '古丽', 3),
  ('68f27102-bc7f-4140-b376-faea43b148be', 'c2000b00-0000-4000-8000-000000000004', 3, '秋菊', 4),
  ('2283523f-519c-438a-98fc-2b966ce61c53', 'c2000b00-0000-4000-8000-000000000004', 3, '白晶晶', 5),
  ('6d970b0c-eed0-4b52-a12f-2094740beb78', 'c2000b00-0000-4000-8000-000000000004', 3, '海燕', 6),
  ('abc7f752-ea9e-4896-a372-0aabdb0cdb57', 'c2000b00-0000-4000-8000-000000000004', 3, '紫霞仙子', 7),
  ('29afd7e7-a2b3-415d-8083-50ba38676c6e', 'c2000b00-0000-4000-8000-000000000004', 3, '铁扇公主', 8),
  ('05d330d3-5c82-4bb0-a96f-6319f148372c', 'c2000b00-0000-4000-8000-000000000004', 3, '选美皇后', 9),
  ('e45d8027-3b8e-448f-8326-95616c75d64c', 'c2000b00-0000-4000-8000-000000000004', 3, '上官婉儿', 10),
  ('da1cfcef-3e05-462b-8710-badeacd811bf', 'c2000b00-0000-4000-8000-000000000004', 3, '杜鹃', 11),
  ('098d859d-3fe6-4a67-83a9-956213a09c3c', 'c2000b00-0000-4000-8000-000000000004', 3, '歌婷', 12),
  ('77f495bf-295a-40a9-a04a-80b02d57a9f9', 'c2000b00-0000-4000-8000-000000000004', 3, '玉兰', 13),
  ('bbee7050-b892-48d4-a1dd-57ed2df91552', 'c2000b00-0000-4000-8000-000000000004', 3, '邻家女孩', 14);
-- 娱 拥有艺人
INSERT INTO task_definitions (category_id, task_code, task_name, default_score, sort_order) VALUES
  ('b56bf4fe-75d0-40c6-8712-701f30532998','own','拥有艺人',20,1),('62cca4a9-1193-4fbe-96dd-fa5ebf91aec6','own','拥有艺人',20,1),('f8ed1cb9-8ea3-4fa7-8df1-e38f0397622f','own','拥有艺人',20,1),('68f27102-bc7f-4140-b376-faea43b148be','own','拥有艺人',20,1),('2283523f-519c-438a-98fc-2b966ce61c53','own','拥有艺人',20,1),('6d970b0c-eed0-4b52-a12f-2094740beb78','own','拥有艺人',20,1),('abc7f752-ea9e-4896-a372-0aabdb0cdb57','own','拥有艺人',20,1),('29afd7e7-a2b3-415d-8083-50ba38676c6e','own','拥有艺人',20,1),('05d330d3-5c82-4bb0-a96f-6319f148372c','own','拥有艺人',20,1),('e45d8027-3b8e-448f-8326-95616c75d64c','own','拥有艺人',20,1),('da1cfcef-3e05-462b-8710-badeacd811bf','own','拥有艺人',20,1),('098d859d-3fe6-4a67-83a9-956213a09c3c','own','拥有艺人',20,1),('77f495bf-295a-40a9-a04a-80b02d57a9f9','own','拥有艺人',20,1),('bbee7050-b892-48d4-a1dd-57ed2df91552','own','拥有艺人',20,1);
-- 娱 - 含香 (3 skins)
INSERT INTO task_definitions (category_id, task_code, task_name, default_score, is_skin, sort_order) VALUES
  ('b56bf4fe-75d0-40c6-8712-701f30532998','skin_含香_0','蝶翼破茧',20,TRUE,1),('b56bf4fe-75d0-40c6-8712-701f30532998','skin_含香_1','破茧化蝶',20,TRUE,2),('b56bf4fe-75d0-40c6-8712-701f30532998','skin_含香_2','离别故土',20,TRUE,3);
-- 娱 - 夏雨荷 (3 skins)
INSERT INTO task_definitions (category_id, task_code, task_name, default_score, is_skin, sort_order) VALUES
  ('62cca4a9-1193-4fbe-96dd-fa5ebf91aec6','skin_夏雨荷_0','画境生欢',20,TRUE,1),('62cca4a9-1193-4fbe-96dd-fa5ebf91aec6','skin_夏雨荷_1','青荷雨待',20,TRUE,2),('62cca4a9-1193-4fbe-96dd-fa5ebf91aec6','skin_夏雨荷_2','轻舟画扇',20,TRUE,3);
-- 娱 - 秋菊 (1 skins)
INSERT INTO task_definitions (category_id, task_code, task_name, default_score, is_skin, sort_order) VALUES
  ('68f27102-bc7f-4140-b376-faea43b148be','skin_秋菊_0','冬日烟花',20,TRUE,1);
-- 娱 - 白晶晶 (2 skins)
INSERT INTO task_definitions (category_id, task_code, task_name, default_score, is_skin, sort_order) VALUES
  ('2283523f-519c-438a-98fc-2b966ce61c53','skin_白晶晶_0','白骨红颜',20,TRUE,1),('2283523f-519c-438a-98fc-2b966ce61c53','skin_白晶晶_1','刻骨铭心',20,TRUE,2);
-- 娱 - 海燕 (3 skins)
INSERT INTO task_definitions (category_id, task_code, task_name, default_score, is_skin, sort_order) VALUES
  ('6d970b0c-eed0-4b52-a12f-2094740beb78','skin_海燕_0','海上弦音',20,TRUE,1),('6d970b0c-eed0-4b52-a12f-2094740beb78','skin_海燕_1','海燕归巢',20,TRUE,2),('6d970b0c-eed0-4b52-a12f-2094740beb78','skin_海燕_2','贺岁佳人',20,TRUE,3);
-- 娱 - 紫霞仙子 (2 skins)
INSERT INTO task_definitions (category_id, task_code, task_name, default_score, is_skin, sort_order) VALUES
  ('abc7f752-ea9e-4896-a372-0aabdb0cdb57','skin_紫霞仙子_0','嫦娥',20,TRUE,1),('abc7f752-ea9e-4896-a372-0aabdb0cdb57','skin_紫霞仙子_1','明曦春霞',20,TRUE,2);
-- 娱 - 铁扇公主 (1 skins)
INSERT INTO task_definitions (category_id, task_code, task_name, default_score, is_skin, sort_order) VALUES
  ('29afd7e7-a2b3-415d-8083-50ba38676c6e','skin_铁扇公主_0','云阶春晖',20,TRUE,1);
-- 娱 - 选美皇后 (1 skins)
INSERT INTO task_definitions (category_id, task_code, task_name, default_score, is_skin, sort_order) VALUES
  ('05d330d3-5c82-4bb0-a96f-6319f148372c','skin_选美皇后_0','佳人茶韵',20,TRUE,1);
-- 娱 - 上官婉儿 (1 skins)
INSERT INTO task_definitions (category_id, task_code, task_name, default_score, is_skin, sort_order) VALUES
  ('e45d8027-3b8e-448f-8326-95616c75d64c','skin_上官婉儿_0','素心守正',20,TRUE,1);

-- Done

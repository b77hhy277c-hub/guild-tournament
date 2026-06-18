# 公会小助手 - 开发文档

## 项目概述
公会竞标赛管理工具，纯前端 + Supabase 后端，Vercel 部署。

- **生产地址**：https://www.sgqingyun.xyz
- **GitHub**：https://github.com/b77hhy277c-hub/guild-tournament

## 技术架构
| 层级 | 技术 |
|------|------|
| 前端 | 纯 HTML/CSS/JS，Apple Sequoia 设计风格，暗色/亮色自适应 |
| 后端 | Supabase（PostgreSQL + REST API + RPC） |
| 认证 | 自定义 display_name + 口令码，bcrypt 哈希 |
| 部署 | Vercel 自动部署 |

## 页面清单（14个页面）
| 文件 | 功能 | 权限 |
|------|------|------|
| `login.html` | 登录页 | 所有人 |
| `index.html` | 主界面（侧边栏+功能卡片+今日副业） | 所有人 |
| `profile.html` | 个人信息修改+改密码 | 所有人 |
| `guide.html` | 点赞指南（满赞/无满赞分组） | 所有人 |
| `business.html` | 副业查询 | 所有人看，超管/副会长编辑 |
| `tournament/index.html` | 竞标赛入口 | 所有人 |
| `tournament/input.html` | 我的竞标赛（任务勾选+目标配置） | 所有人 |
| `tournament/query.html` | 查询可接成员 | 所有人 |
| `admin/members.html` | 成员总览 | 所有人看，管理员操作 |
| `admin/tasks.html` | 任务管理（树形CRUD+搜索） | 竞标赛管理员+ |
| `admin/season.html` | 赛季配置 | 管理员 |
| `admin/logs.html` | 操作日志 | 管理员 |
| `visits.html` | 访问记录 | 超管/副会长 |
| `admin.html` | 管理员后台 | 超管/副会长 |

## 数据库
### 业务表
- `members` - 成员（display_name, uid, password_hash, position, is_admin, is_task_admin, is_full_like, level, vip_level）
- `seasons` - 赛季（season_name, target_rank, total_score, announcement, open_time, extra_time, stats_updated_at）
- `task_categories` - 任务分类（parent_id 三级树形）
- `task_definitions` - 任务定义（default_score, is_skin, sort_order）
- `member_task_abilities` - 成员任务能力
- `member_season_config` - 成员赛季配置（target_score, available_attempts, avg_score, can_accept）
- `side_business_versions` - 副业版本
- `side_business_allocation` - 副业分配

### 日志表
- `operation_logs` - 操作日志（operator_name, operation_type, changes JSONB）
- `visit_logs` - 访问记录

## 权限体系
| 角色 | 标识 | 权限 |
|------|------|------|
| 超级管理员 | `is_admin=true` | 全部权限 |
| 副会长 | `position='副会长'` | 与超级管理员同等 |
| 竞标赛管理员 | `is_task_admin=true` | 任务管理+成员总览+操作日志 |
| 普通成员 | 默认 | 查看+录入自己的竞标赛 |

## 数据规模
- 人才 63人 + 艺人 55人 + 守护神 38个 + 其他任务若干
- 每人8个等级任务 + N个皮肤任务，全部默认 20 分

## SQL 文件
- `supabase_schema_v2.sql` - 核心建表（members + RPC）
- `tournament_schema.sql` - 任务系统建表+示例数据
- `talent_data.sql` - 人才导入
- `artist_data.sql` - 艺人导入

-- 人才盘点工具 - Supabase 数据库 Schema
-- 在 Supabase SQL Editor 中执行此文件

-- 1. 岗位表
CREATE TABLE IF NOT EXISTS positions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- 2. 人选表
CREATE TABLE IF NOT EXISTS candidates (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  position_id UUID NOT NULL REFERENCES positions(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  gender TEXT DEFAULT '',
  phone TEXT DEFAULT '',
  email TEXT DEFAULT '',
  current_company TEXT DEFAULT '',
  current_position TEXT DEFAULT '',
  status TEXT DEFAULT 'new',
  source TEXT DEFAULT 'other',
  manual_years INTEGER,
  education JSONB DEFAULT '[]'::jsonb,
  work_experience JSONB DEFAULT '[]'::jsonb,
  notes TEXT DEFAULT '',
  resume_raw TEXT DEFAULT '',
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- 3. 索引
CREATE INDEX IF NOT EXISTS idx_candidates_position_id ON candidates(position_id);
CREATE INDEX IF NOT EXISTS idx_candidates_current_company ON candidates(current_company);

-- 4. 启用 RLS
ALTER TABLE positions ENABLE ROW LEVEL SECURITY;
ALTER TABLE candidates ENABLE ROW LEVEL SECURITY;

-- 5. RLS 策略：允许匿名用户所有操作（个人工具，通过公开链接访问）
-- 如果你希望加密码保护，可以改为使用 service_role key
CREATE POLICY "Allow all on positions" ON positions FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all on candidates" ON candidates FOR ALL USING (true) WITH CHECK (true);

-- 6. 演示数据（可选）
INSERT INTO positions (name) VALUES ('高级前端工程师');

DO $$
DECLARE
  pid UUID;
BEGIN
  SELECT id INTO pid FROM positions WHERE name = '高级前端工程师' LIMIT 1;
  
  INSERT INTO candidates (position_id, name, gender, phone, email, current_company, current_position, status, source, manual_years, education, work_experience, notes) VALUES
  (pid, '张明远', '男', '13811112222', 'zhangmy@email.com', '腾讯科技', '高级前端工程师', 'interviewing', 'lp', 3,
   '[{"school":"北京大学","degree":"硕士","major":"计算机科学与技术","startDate":"2019.09","endDate":"2022.06"},{"school":"武汉大学","degree":"本科","major":"软件工程","startDate":"2015.09","endDate":"2019.06"}]'::jsonb,
   '[{"company":"腾讯科技","position":"高级前端工程师","startDate":"2022.07","endDate":"至今"},{"company":"字节跳动","position":"前端开发实习生","startDate":"2021.03","endDate":"2021.09"}]'::jsonb,
   '沟通中，技术面已过一轮'),
  (pid, '李雨桐', '女', '13922223333', 'liyutong@email.com', '阿里巴巴', '前端技术专家', 'contacted', 'mm', 5,
   '[{"school":"浙江大学","degree":"本科","major":"计算机科学","startDate":"2016.09","endDate":"2020.06"}]'::jsonb,
   '[{"company":"阿里巴巴","position":"前端技术专家","startDate":"2020.07","endDate":"至今"}]'::jsonb,
   '脉脉上联系，意向积极'),
  (pid, '王浩然', '男', '13633334444', 'wanghr@email.com', '字节跳动', '资深前端工程师', 'new', 'lp', 3,
   '[{"school":"上海交通大学","degree":"硕士","major":"软件工程","startDate":"2020.09","endDate":"2023.03"},{"school":"华中科技大学","degree":"本科","major":"电子信息工程","startDate":"2016.09","endDate":"2020.06"}]'::jsonb,
   '[{"company":"字节跳动","position":"资深前端工程师","startDate":"2023.04","endDate":"至今"},{"company":"美团","position":"前端开发实习生","startDate":"2022.06","endDate":"2022.09"}]'::jsonb,
   '猎头推荐，简历已看，尚未联系'),
  (pid, '陈思琪', '女', '13755556666', 'chensq@email.com', '腾讯科技', '前端开发工程师', 'passed', 'rec', 4,
   '[{"school":"复旦大学","degree":"本科","major":"计算机科学与技术","startDate":"2017.09","endDate":"2021.06"}]'::jsonb,
   '[{"company":"腾讯科技","position":"前端开发工程师","startDate":"2021.07","endDate":"至今"}]'::jsonb,
   '已通过所有面试，待发offer'),
  (pid, '赵鹏飞', '男', '18577778888', 'zhaopf@email.com', '美团', '前端Tech Lead', 'new', 'bs', 7,
   '[{"school":"南京大学","degree":"硕士","major":"计算机应用技术","startDate":"2018.09","endDate":"2021.06"},{"school":"西安电子科技大学","degree":"本科","major":"计算机科学","startDate":"2014.09","endDate":"2018.06"}]'::jsonb,
   '[{"company":"美团","position":"前端Tech Lead","startDate":"2021.07","endDate":"至今"},{"company":"网易","position":"前端开发工程师","startDate":"2018.07","endDate":"2018.08"}]'::jsonb,
   'Boss上收到的简历，待筛选'),
  (pid, '刘子涵', '男', '18699990000', 'liuzh@email.com', '字节跳动', '前端开发工程师', 'rejected', 'lp', 5,
   '[{"school":"哈尔滨工业大学","degree":"本科","major":"软件工程","startDate":"2016.09","endDate":"2020.06"}]'::jsonb,
   '[{"company":"字节跳动","position":"前端开发工程师","startDate":"2020.07","endDate":"至今"},{"company":"腾讯科技","position":"前端实习生","startDate":"2019.06","endDate":"2019.09"}]'::jsonb,
   '技术面未通过，React深度不足'),
  (pid, '孙悦然', '女', '15811113333', 'sunyr@email.com', '阿里巴巴', '高级前端工程师', 'contacted', 'rec', 2,
   '[{"school":"清华大学","degree":"硕士","major":"计算机科学","startDate":"2020.09","endDate":"2023.06"},{"school":"北京邮电大学","degree":"本科","major":"通信工程","startDate":"2016.09","endDate":"2020.06"}]'::jsonb,
   '[{"company":"阿里巴巴","position":"高级前端工程师","startDate":"2023.07","endDate":"至今"}]'::jsonb,
   '清华背景，内推渠道，已加微信');
END $$;

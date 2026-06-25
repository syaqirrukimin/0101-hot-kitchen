-- ═══════════════════════════════════════════════════
-- 0101 HOT KITCHEN — DATABASE SETUP (v2 with login)
-- Run this in Supabase → SQL Editor → New query
-- ═══════════════════════════════════════════════════

-- 1. ORDERS TABLE
create table if not exists orders (
  id         text primary key,
  date       text not null,
  data       jsonb not null,
  created_at timestamptz default now()
);

-- 2. SETTINGS TABLE
create table if not exists settings (
  id         text primary key,
  data       jsonb not null,
  updated_at timestamptz default now()
);

-- 3. USERS TABLE (for login system)
create table if not exists users (
  id              uuid primary key default gen_random_uuid(),
  username        text unique not null,
  password        text not null,        -- plain text for simplicity (small private system)
  must_change_pw  boolean default true,  -- true = temp password, must change on first login
  expiry_date     date,                  -- null = never expires
  active          boolean default true,  -- admin can deactivate without deleting
  created_at      timestamptz default now(),
  last_login      timestamptz
);

-- 4. INSERT DEFAULT SETTINGS
insert into settings (id, data) values (
  'global',
  '{
    "ckt": [
      {"name": "Dry",         "price": 8},
      {"name": "Wet",         "price": 8},
      {"name": "Black sauce", "price": 9},
      {"name": "Extra spicy", "price": 9}
    ],
    "addon": [
      {"name": "Extra egg",       "price": 1.5},
      {"name": "Prawn",           "price": 3},
      {"name": "Cockles",         "price": 2},
      {"name": "No bean sprouts", "price": 0},
      {"name": "Extra chilli",    "price": 0}
    ],
    "payment": ["QR / DuitNow", "Cash", "Online transfer"],
    "status":  ["In queue", "Done"],
    "soldout": []
  }'::jsonb
) on conflict (id) do nothing;

-- 5. CREATE A SAMPLE USER (username: owner, password: welcome123)
--    You can create more / change this from the Admin page
insert into users (username, password, must_change_pw, expiry_date)
values ('owner', 'welcome123', true, null)
on conflict (username) do nothing;

-- 6. ENABLE ROW LEVEL SECURITY
alter table orders   enable row level security;
alter table settings enable row level security;
alter table users    enable row level security;

-- 7. ALLOW ALL OPERATIONS WITH ANON KEY (private stall app, no public access)
create policy "Allow all for anon" on orders   for all to anon using (true) with check (true);
create policy "Allow all for anon" on settings for all to anon using (true) with check (true);
create policy "Allow all for anon" on users    for all to anon using (true) with check (true);

-- ═══════════════════════════════════════════════════
-- DONE! Your database now supports login.
-- Default login: username "owner" / password "welcome123"
-- (You'll be asked to set a new password on first login)
-- ═══════════════════════════════════════════════════

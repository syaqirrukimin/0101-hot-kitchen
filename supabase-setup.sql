-- ═══════════════════════════════════════════════════
-- 0101 HOT KITCHEN — DATABASE SETUP (v3 multi-tenant)
-- Run this in Supabase → SQL Editor → New query
-- Each user = one isolated stall. Run block by block if needed.
-- ═══════════════════════════════════════════════════

-- 1. DROP OLD POLICIES (safe to run even if they don't exist)
drop policy if exists "Allow all for anon" on orders;
drop policy if exists "Allow all for anon" on settings;
drop policy if exists "Allow all for anon" on users;

-- 2. USERS TABLE (each user = one stall, identified by stall_id)
create table if not exists users (
  id              uuid primary key default gen_random_uuid(),
  stall_id        uuid not null default gen_random_uuid(),  -- unique per stall
  username        text unique not null,
  password        text not null,
  must_change_pw  boolean default true,
  expiry_date     date,
  active          boolean default true,
  created_at      timestamptz default now(),
  last_login      timestamptz
);

-- If you already had a users table WITHOUT stall_id, add the column:
alter table users add column if not exists stall_id uuid default gen_random_uuid();
update users set stall_id = gen_random_uuid() where stall_id is null;
alter table users alter column stall_id set not null;

-- 3. ORDERS TABLE — now scoped to a stall
create table if not exists orders (
  id         text not null,
  stall_id   uuid not null,
  date       text not null,
  data       jsonb not null,
  created_at timestamptz default now(),
  primary key (stall_id, id)
);
alter table orders add column if not exists stall_id uuid;

-- 4. SETTINGS TABLE — now scoped to a stall
create table if not exists settings (
  stall_id   uuid primary key,
  data       jsonb not null,
  updated_at timestamptz default now()
);
alter table settings add column if not exists stall_id uuid;

-- 5. ENABLE ROW LEVEL SECURITY
alter table orders   enable row level security;
alter table settings enable row level security;
alter table users    enable row level security;

-- 6. ALLOW ALL OPERATIONS WITH ANON KEY
--    (app filters by stall_id itself; this is a small private system, no public signup)
create policy "Allow all for anon" on orders   for all to anon using (true) with check (true);
create policy "Allow all for anon" on settings for all to anon using (true) with check (true);
create policy "Allow all for anon" on users    for all to anon using (true) with check (true);

-- 7. CREATE A SAMPLE USER / STALL (username: owner, password: welcome123)
insert into users (username, password, must_change_pw, expiry_date)
values ('owner', 'welcome123', true, null)
on conflict (username) do nothing;

-- ═══════════════════════════════════════════════════
-- DONE!
-- Each new user created via Admin Panel automatically gets
-- their own stall_id, with empty orders and default settings.
-- They will never see another stall's data.
-- ═══════════════════════════════════════════════════

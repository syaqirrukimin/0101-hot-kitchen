-- ═══════════════════════════════════════════════════
-- 0101 HOT KITCHEN — SUPABASE DATABASE SETUP
-- Run this in Supabase → SQL Editor → New query
-- ═══════════════════════════════════════════════════

-- 1. ORDERS TABLE
create table if not exists orders (
  id         text primary key,          -- e.g. 20250618-001
  date       text not null,             -- e.g. 20250618
  data       jsonb not null,            -- full order object
  created_at timestamptz default now()
);

-- 2. SETTINGS TABLE
create table if not exists settings (
  id         text primary key,          -- always 'global'
  data       jsonb not null,            -- full settings object
  updated_at timestamptz default now()
);

-- 3. INSERT DEFAULT SETTINGS
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
    "status":  ["In queue", "Done"]
  }'::jsonb
) on conflict (id) do nothing;

-- 4. ENABLE ROW LEVEL SECURITY (keep data private)
alter table orders   enable row level security;
alter table settings enable row level security;

-- 5. ALLOW ALL OPERATIONS WITH ANON KEY
--    (since this is a private stall app, no login needed)
create policy "Allow all for anon" on orders
  for all to anon using (true) with check (true);

create policy "Allow all for anon" on settings
  for all to anon using (true) with check (true);

-- ═══════════════════════════════════════════════════
-- DONE! Your database is ready.
-- ═══════════════════════════════════════════════════

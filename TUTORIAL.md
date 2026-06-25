# 🍳 0101 Hot Kitchen — Full Deployment Tutorial (v3 — Multi-Stall)
## Now with Login System + Admin Panel + Isolated Data Per Stall
## Total cost: FREE | Time needed: ~35 minutes

---

## ⚠️ IMPORTANT — IF YOU ALREADY HAVE DATA FROM BEFORE

This version adds **`stall_id`** to every table so each user's orders are private.
Run the new `supabase-setup.sql` — it safely adds the `stall_id` column to your
existing tables without deleting your old orders. Your existing `owner` account
and its old orders will automatically get assigned a `stall_id` and keep working.

---

## WHAT'S NEW IN THIS VERSION

1. **Login required** — `login.html` guards access to the main app
2. **Admin panel** — `admin.html` to create/manage users (separate page)
3. **Collection date picker** — choose any date, not just today
4. **Chef day tabs** — Yesterday / Today / Tomorrow views
5. **Sold-out tracking** — chef marks items sold out, greys out in order form, owner restocks from Settings
6. **Report by custom date range** — pick any "from" and "to" date

---

## FILES YOU HAVE

| File | Purpose |
|---|---|
| `login.html` | Login screen for 0101 system users |
| `index.html` | Main app (requires login) |
| `admin.html` | Admin panel — create users, reset passwords, set expiry |
| `manifest.json` | PWA install config |
| `supabase-setup.sql` | Database setup script (run once) |

---

## STEP 1 — GITHUB

1. Go to **https://github.com** → Sign up (if you haven't)
2. Create new repository: `0101-hot-kitchen` (Public)
3. Upload **all 5 files**: `login.html`, `index.html`, `admin.html`, `manifest.json`, `supabase-setup.sql`
4. Click **Commit changes**

---

## STEP 2 — SUPABASE

### 2.1 Create project (skip if you already have one from before)
1. Go to **https://supabase.com** → Sign up → New project
2. Name: `0101-hot-kitchen`, Region: Singapore
3. Wait ~2 minutes

### 2.2 Run the SQL setup
1. Click **SQL Editor** → **New query**
2. Open `supabase-setup.sql` with Notepad → copy all → paste into SQL Editor
3. Click **Run**
4. This creates: `orders`, `settings`, and **`users`** tables
5. A default test user is created: **username `owner`, password `welcome123`**

### 2.3 Get your credentials
1. **Project Settings** → **API**
2. Copy your **Project URL** and **anon public key**

---

## STEP 3 — UPDATE ALL 3 HTML FILES WITH YOUR KEYS

You need to paste your Supabase keys into **3 files** this time (not just 1):

### 3.1 login.html
Find:
```
const SUPABASE_URL = 'YOUR_SUPABASE_URL';
const SUPABASE_KEY = 'YOUR_SUPABASE_ANON_KEY';
```
Replace with your real values.

### 3.2 index.html
Same two lines, same replacement.

### 3.3 admin.html
Same two lines, same replacement.

### 3.4 Re-upload all 3 to GitHub
GitHub → click each file → pencil icon (Edit) → paste updated content → Commit changes.

---

## STEP 4 — VERCEL (deploy)

1. Go to **https://vercel.com** → Sign up with GitHub
2. **Add New** → **Project** → Import `0101-hot-kitchen`
3. Click **Deploy**
4. Your links will be:
   - Main app: `https://0101-hot-kitchen.vercel.app/login.html`
   - Admin panel: `https://0101-hot-kitchen.vercel.app/admin.html`

> 💡 Tip: Set `login.html` as your homepage by renaming it to `index.html` and renaming the app's `index.html` to `app.html` — then update the redirect link inside `login.html` from `index.html` to `app.html`. Optional, just for a cleaner URL.

---

## STEP 5 — ADMIN PANEL — CREATE YOUR FIRST REAL USER

1. Open `https://yourapp.vercel.app/admin.html`
2. Login with:
   - **Username:** `admin`
   - **Password:** `system@dmin0101`
3. Click **Create new user**
   - Enter a username (e.g. `chef1` or your own name)
   - Optionally set an expiry date
   - Click **Create user**
4. A **temporary password** will be shown on screen — copy it and share with that user (WhatsApp etc.)

---

## STEP 6 — FIRST LOGIN (for you / chef)

1. Open `https://yourapp.vercel.app/login.html`
2. Enter the username + temporary password given by admin
3. System will ask you to **set a new password**
4. Enter new password (min 6 characters) → confirm → continue
5. You're in! 🎉

From now on, login with username + your own new password.

---

## ADMIN PANEL — WHAT YOU CAN DO

| Action | How |
|---|---|
| **Create user** | Top of admin page → enter username + expiry → Create |
| **Reset password** | Click 🔑 key icon next to a user → new temp password shown |
| **Set/change expiry** | Click 📅 calendar icon → pick new date → Save |
| **Deactivate user** | Click 🔒 lock icon → instantly blocks their login |
| **Reactivate user** | Click 🔓 unlock icon |
| **Delete user permanently** | Click 🗑️ trash icon → confirm |

**Expired accounts** automatically see: *"Your account has expired. Please contact admin."* — they cannot get in until admin updates the expiry date or resets their password.

---

## 🔒 HOW DATA ISOLATION WORKS (NEW)

Each user account created in the Admin Panel automatically gets its own hidden
`stall_id`. Every order and setting they create is tagged with that ID.

- **You** (e.g. username `owner`) only ever see your own orders
- **Another stall owner** you create (e.g. username `stall2`) gets a 100% empty,
  separate system — they cannot see your orders, menu, or reports, and you
  cannot see theirs
- This all happens automatically — you don't need to configure anything per user

---

## NEW FEATURE GUIDE

### 📅 Collection date (Orders tab)
When creating an order, you now pick **both date and time**. Defaults to today. Useful for advance orders (e.g. customer orders today for collection tomorrow).

### 👨‍🍳 Chef day tabs (Chef tab)
Three tabs: **Yesterday / Today / Tomorrow**. Chef can prep ahead by checking tomorrow's queue, or catch up on yesterday's unfinished orders.

### 🚫 Sold out tracking
- In the **Chef tab**, tap any CKT type or add-on to mark it sold out (turns red with a 🚫)
- That item immediately greys out in the **New Order** form — owner can still see it but can't select it
- To bring it back: go to **Settings → Restock sold-out items** → tap the × on the item

### 📊 Report by custom date
In the **Report tab**, tap **"By date"** → pick a "from" and "to" date → see orders, revenue, and top items for that exact range. Great for checking last month's specific week, etc.

---

## TOTAL COST BREAKDOWN

| Service | Plan | Cost |
|---|---|---|
| GitHub | Free | RM 0 |
| Supabase | Free | RM 0 (500MB, more than enough) |
| Vercel | Hobby | RM 0 |
| **TOTAL** | | **RM 0/month** |

---

## TROUBLESHOOTING

**"Invalid username or password"**
→ Double check with admin panel that the user exists and is Active

**Stuck on "Set a new password" screen**
→ Make sure password is 6+ characters and both fields match

**Admin page won't login**
→ Username is exactly `admin`, password is exactly `system@dmin0101` (case-sensitive)

**User says "Account expired"**
→ Go to Admin → click 📅 next to their name → update expiry date (or clear it for "never expires")

**Chef marked something sold out by mistake**
→ Owner: Settings → Restock sold-out items → tap × next to it

---

## SECURITY NOTE

This is a simple, private system designed for a small hawker stall — passwords are stored in plain text in the database (not encrypted) for simplicity, since this is not a public-facing commercial app. Keep your Supabase dashboard access private, and don't share your anon key publicly beyond this app's code.

---
*0101 Hot Kitchen System v2 — Built with ❤️*

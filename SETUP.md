# New Karki Art — Setup Guide (Option 1: Supabase CMS)

## Demo mode (test without Supabase)
While config.js still has the placeholder values, admin.html runs in DEMO MODE:
- Open admin.html → login with ANY email + password `Balkrishna`
- All tabs work with the default content; Save and photo upload are simulated
  (yellow banner reminds you nothing is actually stored)
- Login persists for the browser session (sessionStorage); Logout clears it
- The moment you put real keys in config.js, demo mode disables itself and
  real Supabase login is required. The demo password does NOT work in real mode.

## Files
- `index.html` — public website (loads content from Supabase, falls back to baked-in defaults)
- `admin.html` — client admin panel (login → edit text/contacts/team/reviews → upload photos)
- `config.js`  — Supabase URL + anon key (edit this, shared by both pages)
- `schema.sql` — run once in Supabase

## Setup (10 minutes)

1. **Create Supabase project** → supabase.com → New project (free tier).

2. **Run schema** → Dashboard → SQL Editor → paste `schema.sql` → Run.
   This creates `site_content` (seeded with all current website text),
   `portfolio` table, the public `portfolio` storage bucket, and RLS policies.

3. **Create the client's login**
   Dashboard → Authentication → Users → Add user:
   - Email: newkarkiart88@gmail.com
   - Password: BalkrishnaKarkiArt@2083
   - Auto Confirm ON.
   Both are changeable later from Admin → Profile. Note: changing the email
   sends a confirmation link to the new address (Supabase default) — the
   change applies only after clicking it. Password changes apply instantly.

4. **Lock signups**
   Dashboard → Authentication → Sign In / Up → turn OFF "Allow new users to sign up".
   (Critical — otherwise anyone could register and get write access, since RLS grants write to any authenticated user.)

5. **Configure** → edit `config.js`:
   - `SUPABASE_URL` → Project Settings → API → Project URL
   - `SUPABASE_ANON_KEY` → Project Settings → API → anon public key

6. **Deploy** to Vercel: index.html, admin.html, config.js, vercel.json
   (schema.sql and this file aren't needed on the host).
   vercel.json's cleanUrls + rewrite makes the admin reachable at
   `yoursite.com/admin` (the .html version also still works).

Password note: when creating the user in step 3, you choose the password
in the Supabase dashboard — it is never stored in these files. If using a
simple password like the owner's name, consider adding a number/symbol,
since the admin URL is publicly reachable.

## How the client uses it
1. Open `/admin.html` on his phone → login.
2. Tabs: About / Contact / Homepage / Stats / Reviews / Photos.
3. Edit → tap **Save** (bottom bar). Live site updates instantly on next page load.
4. Photos tab: pick photo from gallery/camera → choose category → titles (EN + NE) → Upload.
   Once he uploads his first photo, the stock sample photos disappear and only his photos show.

## Behavior notes
- If Supabase is unreachable, the site silently shows the baked-in default content (never blank).
- If `config.js` still has placeholder values, the site skips the fetch entirely.
- Photo uploads capped at 5 MB in the admin UI.
- Verified: JS syntax (node --check on all three scripts), tag balance, hook counts.
  NOT device-verified: actual Supabase round-trip (needs a real project + keys), photo upload flow, auth flow.

## Hardening (optional, later)
- Restrict writes to one specific user: change RLS policies from `to authenticated`
  to `using (auth.uid() = 'THE-USER-UUID')`.
- Add image compression before upload (client-side canvas resize) if his photos are huge.

## v2 additions (post-audit)
- Contact form now opens WhatsApp with the inquiry prefilled — messages reach the owner's phone, no backend.
- PWA: manifest.json, sw.js (network-first pages, cached shell), icons/ folder, apple-touch-icon. SW registers on https only.
- og-cover.jpg included — UPDATE the og:url/canonical domain in index.html after deploy.
- Admin: photo reorder (▲▼), image auto-compression before upload (max 1600px JPEG), password reveal, logout unsaved-changes guard.
- Deleting ALL items of anything in admin now empties it on the site (no stock-content resurrection); empty sections hide themselves.
- Language + theme persist across visits; splash plays once per session.
- Security: site renders admin content as text (hero headline allows only the color span); vercel.json adds security headers; /admin is noindex + frame-denied.

## v3 additions
- Service cards: tap any service -> WhatsApp opens prefilled ("Hello! I want to ask about Flex Printing.") in the visitor's language.
- Mobile sticky action bar: Call / WhatsApp / Directions at the bottom on phones (replaces the floating WhatsApp bubble there). All three follow admin-set contact details.
- Before/After photos: optional "before" image per portfolio item (upload form + Edit). Site shows a Before/After badge and a toggle button in the lightbox.
  IMPORTANT for existing databases: re-run the "v2 MIGRATION" line at the bottom of schema.sql (adds the before_url column; safe to re-run).
- Analytics: index.html loads Vercel Web Analytics. Enable it once: Vercel dashboard -> your project -> Analytics -> Enable. If not enabled, the script 404s silently and nothing breaks.

## Google Business Profile (do this — biggest impact, zero code)
1. business.google.com -> Add business -> "New Karki Art", category "Print shop" / "Digital printing service".
2. Set the map pin to exactly 27.751741, 85.823256, hours 7 AM-7 PM all week, phone 9860655490, website URL after deploy.
3. Verify (video or postcard, whatever Google offers for the area).
4. Upload 10+ real photos of work and the shop front — listings with photos get far more calls.
5. Ask every happy customer to leave a Google review (share the review link via WhatsApp).
6. Copy the best Google reviews into the site's admin -> Reviews tab so the website and Maps tell the same story.

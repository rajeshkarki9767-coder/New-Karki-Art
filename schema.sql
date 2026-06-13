-- ============================================================
-- NEW KARKI ART — Supabase schema
-- Run this once in: Supabase Dashboard → SQL Editor → New query
-- ============================================================

-- 1. SITE CONTENT (single JSON row, id = 1)
create table if not exists public.site_content (
  id int primary key,
  data jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.site_content enable row level security;

create policy "site_content public read"
  on public.site_content for select using (true);

create policy "site_content auth update"
  on public.site_content for update
  to authenticated using (true) with check (true);

-- Seed with current website content (safe to re-run: does nothing if row exists)
insert into public.site_content (id, data) values (1, '{
  "brand": {"name": "New Karki Art", "logo_url": "", "tagline_en": "Printing & Design", "tagline_ne": "प्रिन्टिङ तथा डिजाइन"},
  "hero": {
    "headline_en": "Transforming Ideas Into <span class=\"grad\">Stunning Prints</span> & Designs",
    "headline_ne": "विचारलाई <span class=\"grad\">आकर्षक प्रिन्ट</span> तथा डिजाइनमा रूपान्तरण",
    "sub_en": "Your trusted partner for professional printing, branding, advertising materials, custom merchandise, and creative design solutions.",
    "sub_ne": "व्यावसायिक प्रिन्टिङ, ब्रान्डिङ, विज्ञापन सामग्री, कस्टम उत्पादन तथा सिर्जनात्मक डिजाइन समाधानको लागि तपाईंको भरपर्दो साझेदार।"
  },
  "about": {
    "en": "New Karki Art is a professional printing and design company located in Khadichaur, Sindhupalchok. We provide high-quality printing, branding, advertising materials, custom merchandise, and creative design services for businesses and individuals. Our goal is to deliver quality work with creativity, professionalism, and customer satisfaction.",
    "ne": "न्यु कार्की आर्ट खाडीचौर, सिन्धुपाल्चोकमा अवस्थित एक व्यावसायिक प्रिन्टिङ तथा डिजाइन कम्पनी हो। हामी उच्च गुणस्तरीय प्रिन्टिङ, ब्रान्डिङ, विज्ञापन सामग्री, कस्टम उत्पादन तथा सिर्जनात्मक डिजाइन सेवा प्रदान गर्दछौं। हाम्रो उद्देश्य गुणस्तरीय सेवा र ग्राहक सन्तुष्टि सुनिश्चित गर्नु हो।"
  },
  "contact": {
    "phone": "9860655490",
    "whatsapp": "9860655490",
    "email": "newkarkiart88@gmail.com",
    "hours_en": "All week · 7:00 AM – 7:00 PM",
    "hours_ne": "हरेक दिन · बिहान ७ – बेलुका ७",
    "address_en": "Khadichaur, Sindhupalchok, Nepal",
    "address_ne": "खाडीचौर, सिन्धुपाल्चोक, नेपाल",
    "lat": "27.751741",
    "lng": "85.823256"
  },
  "services": {
    "print": [{"en":"Flex Printing","ne":"फ्लेक्स प्रिन्टिङ"},{"en":"Banner Printing","ne":"ब्यानर प्रिन्टिङ"},{"en":"Board Printing","ne":"बोर्ड प्रिन्टिङ"},{"en":"Cup Printing","ne":"कप प्रिन्टिङ"},{"en":"Mug Printing","ne":"मग प्रिन्टिङ"},{"en":"T-Shirt Printing","ne":"टि-शर्ट प्रिन्टिङ"},{"en":"Sticker Printing","ne":"स्टिकर प्रिन्टिङ"},{"en":"Invitation Cards","ne":"निमन्त्रणा कार्ड"},{"en":"ID Cards","ne":"आईडी कार्ड"}],
    "design": [{"en":"Logo Design","ne":"लोगो डिजाइन"},{"en":"Business Card Design","ne":"भिजिटिङ कार्ड डिजाइन"},{"en":"Poster Design","ne":"पोस्टर डिजाइन"},{"en":"Social Media Graphics","ne":"सोसल मिडिया ग्राफिक्स"},{"en":"Branding Design","ne":"ब्रान्डिङ डिजाइन"},{"en":"Packaging Design","ne":"प्याकेजिङ डिजाइन"}],
    "business": [{"en":"Rubber Stamps","ne":"रबर स्ट्याम्प"},{"en":"Bills & Invoices","ne":"बिल तथा इन्भ्वाइस"},{"en":"Receipt Books","ne":"रसिद बुक"},{"en":"Letterheads","ne":"लेटरहेड"},{"en":"Company Seals","ne":"कम्पनी सिल"}],
    "custom": [{"en":"Handwritten Boards","ne":"हस्तलिखित बोर्ड"},{"en":"Handwritten Signboards","ne":"हस्तलिखित साइनबोर्ड"},{"en":"Custom Artwork","ne":"कस्टम आर्टवर्क"},{"en":"Personalized Printing","ne":"व्यक्तिगत प्रिन्टिङ"}]
  },
  "hero_card": [
    {"en": "Flex & Banner Printing", "ne": "फ्लेक्स र ब्यानर प्रिन्ट", "tag": "HD"},
    {"en": "Logo & Branding", "ne": "लोगो र ब्रान्डिङ", "tag": "Custom"},
    {"en": "T-Shirt & Mug Print", "ne": "टि-शर्ट र मग प्रिन्ट", "tag": "★"},
    {"en": "Stamps & Invoices", "ne": "स्ट्याम्प र बिल", "tag": "Fast"}
  ],
  "why_feats": [{"en":"Fast Delivery","ne":"छिटो डेलिभरी"},{"en":"Affordable Pricing","ne":"किफायती मूल्य"},{"en":"High Quality Materials","ne":"उच्च गुणस्तर सामग्री"},{"en":"Professional Service","ne":"व्यावसायिक सेवा"}],
  "stats": [
    {"num": "1000", "suf": "+", "en": "Projects Completed", "ne": "पूरा भएका परियोजना"},
    {"num": "500", "suf": "+", "en": "Happy Customers", "ne": "सन्तुष्ट ग्राहक"},
    {"num": "7", "suf": "+", "en": "Years of Service", "ne": "सेवाका वर्ष"},
    {"num": "100", "suf": "%", "en": "Satisfaction Goal", "ne": "सन्तुष्टि लक्ष्य"}
  ],
  "testimonials": [
    {"en": "Excellent printing quality and professional service.", "ne": "उत्कृष्ट प्रिन्टिङ गुणस्तर र व्यावसायिक सेवा।", "who": "Ramesh K."},
    {"en": "Best design and printing service in the area.", "ne": "क्षेत्रकै उत्कृष्ट डिजाइन तथा प्रिन्टिङ सेवा।", "who": "Sita Tamang"},
    {"en": "Highly recommended for banners, logos, and custom printing.", "ne": "ब्यानर, लोगो र कस्टम प्रिन्टिङका लागि अत्यधिक सिफारिस।", "who": "Bikash Shrestha"}
  ]
}'::jsonb)
on conflict (id) do nothing;

-- 2. PORTFOLIO
create table if not exists public.portfolio (
  id uuid primary key default gen_random_uuid(),
  cat text not null check (cat in ('flex','banner','tshirt','logo','stamp','board','custom')),
  title_en text not null,
  title_ne text not null,
  img_url text not null,
  sort_order int not null default 0,
  created_at timestamptz not null default now()
);

alter table public.portfolio enable row level security;

create policy "portfolio public read"
  on public.portfolio for select using (true);

create policy "portfolio auth insert"
  on public.portfolio for insert to authenticated with check (true);

create policy "portfolio auth update"
  on public.portfolio for update to authenticated using (true) with check (true);

create policy "portfolio auth delete"
  on public.portfolio for delete to authenticated using (true);

-- 3. STORAGE BUCKET for portfolio photos (public read)
insert into storage.buckets (id, name, public)
values ('portfolio', 'portfolio', true)
on conflict (id) do nothing;

create policy "portfolio storage auth upload"
  on storage.objects for insert to authenticated
  with check (bucket_id = 'portfolio');

create policy "portfolio storage auth delete"
  on storage.objects for delete to authenticated
  using (bucket_id = 'portfolio');

-- ============================================================
-- AFTER RUNNING THIS:
-- 1. Dashboard → Authentication → Users → Add user
--    (create the client's login email + password, "Auto confirm" ON)
-- 2. Dashboard → Authentication → Sign In / Up → disable "Allow new users to sign up"
--    (so nobody else can create an account)
-- 3. Put your project URL + anon key in config.js
-- ============================================================

-- ============================================================
-- v2 MIGRATION: before/after photo pairs (safe to re-run;
-- run this even if you already ran the schema above)
-- ============================================================
alter table public.portfolio add column if not exists before_url text;

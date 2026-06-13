// New Karki Art — minimal offline shell
const CACHE = 'nka-v1';
const SHELL = ['/', '/index.html', '/config.js', '/manifest.json', '/icons/icon-192.png'];

self.addEventListener('install', e => {
  e.waitUntil(caches.open(CACHE).then(c => c.addAll(SHELL)).then(() => self.skipWaiting()));
});
self.addEventListener('activate', e => {
  e.waitUntil(caches.keys().then(keys =>
    Promise.all(keys.filter(k => k !== CACHE).map(k => caches.delete(k)))
  ).then(() => self.clients.claim()));
});
// Network-first for navigations (fresh content), cache fallback offline.
// Cache-first for static same-origin assets.
self.addEventListener('fetch', e => {
  if (e.request.method !== 'GET') return;
  const url = new URL(e.request.url);
  if (e.request.mode === 'navigate') {
    e.respondWith(fetch(e.request).then(r => {
      caches.open(CACHE).then(c => c.put('/index.html', r.clone()));
      return r;
    }).catch(() => caches.match('/index.html')));
    return;
  }
  if (url.origin === location.origin) {
    e.respondWith(caches.match(e.request).then(hit => hit || fetch(e.request).then(r => {
      caches.open(CACHE).then(c => c.put(e.request, r.clone()));
      return r;
    })));
  }
  // cross-origin (Supabase, fonts, unsplash): default browser behavior
});

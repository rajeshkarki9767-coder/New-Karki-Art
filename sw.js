// New Karki Art — minimal offline shell (v2)
const CACHE = 'nka-v14';
const SHELL = ['/', '/index.html', '/config.js', '/manifest.json', '/icons/icon-192.png'];

self.addEventListener('install', e => {
  e.waitUntil(
    caches.open(CACHE)
      .then(c => Promise.allSettled(SHELL.map(u => c.add(u)))) // don't fail install if one asset 404s
      .then(() => self.skipWaiting())
  );
});

self.addEventListener('activate', e => {
  e.waitUntil(
    caches.keys()
      .then(keys => Promise.all(keys.filter(k => k !== CACHE).map(k => caches.delete(k))))
      .then(() => self.clients.claim())
  );
});

// Only cache successful, basic (same-origin) GET responses. Clone BEFORE the body is read.
function cachePut(request, response) {
  if (!response || !response.ok || response.type === 'opaque') return;
  const copy = response.clone();           // clone first
  caches.open(CACHE).then(c => c.put(request, copy)).catch(() => {});
}

self.addEventListener('fetch', e => {
  if (e.request.method !== 'GET') return;
  const url = new URL(e.request.url);

  // Navigations: network-first, fall back to cached shell offline.
  if (e.request.mode === 'navigate') {
    e.respondWith(
      fetch(e.request)
        .then(r => { cachePut('/index.html', r); return r; })
        .catch(() => caches.match('/index.html'))
    );
    return;
  }

  // Same-origin static assets: cache-first, then network.
  if (url.origin === location.origin) {
    e.respondWith(
      caches.match(e.request).then(hit =>
        hit || fetch(e.request).then(r => { cachePut(e.request, r); return r; }).catch(() => hit)
      )
    );
  }
  // Cross-origin (Supabase, fonts, Unsplash): let the browser handle it normally.
});

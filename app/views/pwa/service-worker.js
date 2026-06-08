// ひびまる Service Worker
// App-shell caching for an installable, offline-capable PWA.
// Bump CACHE_VERSION whenever the caching logic or precached assets change.

const CACHE_VERSION = "v2";
const CACHE_NAME = `hibimaru-${CACHE_VERSION}`;

// Static, same-origin files that are safe to precache (no auth involved).
const PRECACHE_URLS = [
  "/icon.png",
  "/icon.svg",
  "/icon-192.png",
  "/icon-512.png",
  "/icon-maskable.png",
  "/apple-touch-icon.png",
  "/manifest.json",
];

// Cross-origin CDNs the app depends on (Tailwind / fonts / SortableJS).
// These are served once and cached so styles/scripts work offline.
const CDN_HOSTS = [
  "cdn.tailwindcss.com",
  "fonts.googleapis.com",
  "fonts.gstatic.com",
  "cdn.jsdelivr.net",
];

self.addEventListener("install", (event) => {
  event.waitUntil(
    (async () => {
      const cache = await caches.open(CACHE_NAME);
      // Best-effort: a single failed asset must not abort the whole install.
      await Promise.allSettled(PRECACHE_URLS.map((url) => cache.add(url)));
      await self.skipWaiting();
    })()
  );
});

self.addEventListener("activate", (event) => {
  event.waitUntil(
    (async () => {
      const keys = await caches.keys();
      await Promise.all(
        keys
          .filter((key) => key.startsWith("hibimaru-") && key !== CACHE_NAME)
          .map((key) => caches.delete(key))
      );
      await self.clients.claim();
    })()
  );
});

// Cache-first: serve from cache, fall back to network and store the result.
async function cacheFirst(request) {
  const cache = await caches.open(CACHE_NAME);
  const cached = await cache.match(request);
  if (cached) return cached;

  const response = await fetch(request);
  if (response && (response.ok || response.type === "opaque")) {
    cache.put(request, response.clone());
  }
  return response;
}

// Network-first: try the network, fall back to the cached copy when offline.
async function networkFirst(request) {
  const cache = await caches.open(CACHE_NAME);
  try {
    const response = await fetch(request);
    if (response && response.ok && request.method === "GET") {
      cache.put(request, response.clone());
    }
    return response;
  } catch (error) {
    const cached = await cache.match(request);
    if (cached) return cached;
    throw error;
  }
}

self.addEventListener("fetch", (event) => {
  const { request } = event;

  // Only handle GET; let the browser deal with POST/PUT/DELETE etc.
  if (request.method !== "GET") return;

  const url = new URL(request.url);

  // CDN assets → cache-first (immutable, shared across pages).
  if (CDN_HOSTS.includes(url.hostname)) {
    event.respondWith(cacheFirst(request));
    return;
  }

  // Only same-origin requests beyond this point.
  if (url.origin !== self.location.origin) return;

  // Fingerprinted build/asset files → cache-first (immutable).
  if (url.pathname.startsWith("/assets/")) {
    event.respondWith(cacheFirst(request));
    return;
  }

  // Page navigations and other same-origin GETs → network-first with
  // a cached fallback so previously visited pages open offline.
  event.respondWith(networkFirst(request));
});

// --- Web Push (left as a reference for future use) ---------------------------
//
// self.addEventListener("push", async (event) => {
//   const { title, options } = await event.data.json()
//   event.waitUntil(self.registration.showNotification(title, options))
// })
//
// self.addEventListener("notificationclick", function(event) {
//   event.notification.close()
//   event.waitUntil(
//     clients.matchAll({ type: "window" }).then((clientList) => {
//       for (let i = 0; i < clientList.length; i++) {
//         let client = clientList[i]
//         let clientPath = (new URL(client.url)).pathname
//
//         if (clientPath == event.notification.data.path && "focus" in client) {
//           return client.focus()
//         }
//       }
//
//       if (clients.openWindow) {
//         return clients.openWindow(event.notification.data.path)
//       }
//     })
//   )
// })

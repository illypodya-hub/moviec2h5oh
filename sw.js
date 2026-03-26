self.addEventListener('install', (e) => {
  e.waitUntil(
    caches.open('movie-c2h5oh-v1').then((cache) => cache.addAll([
      '/',
      '/index.html',
      // добавь сюда пути к своим основным файлам/картинкам, если хочешь оффлайн
    ]))
  );
});

self.addEventListener('fetch', (e) => {
  e.respondWith(
    caches.match(e.request).then((response) => response || fetch(e.request))
  );
});

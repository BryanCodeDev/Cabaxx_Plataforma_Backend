-- ============================================================
-- MAP — SEED DEMO PARA CABITAXX
-- ============================================================
-- Ejecutar DESPUES de database.sql y seed_data.sql.
-- Inserta contenido demo especifico para el artista cabitaxx
-- y resetea el password del admin.
-- ============================================================

USE map_platform;

SET SQL_SAFE_UPDATES = 0;

SET @artist = (SELECT id FROM artists WHERE slug = 'cabitaxx');
SET @admin = (SELECT id FROM users WHERE email = 'admin@mastercode.co');

-- Reset password admin a Mastercode2026!
UPDATE users SET password_hash = '$2b$10$g6BHkvGtip9t2rYiW1xqWOqhO1IaLI0578q0fB2P7lDX8UKLftfaW' WHERE id = @admin;

-- Artist settings (plan pro para probar checkPlan)
INSERT INTO artist_settings (artist_id, `key`, value, type) VALUES
  (@artist, 'plan', 'pro', 'string'),
  (@artist, 'currency', 'COP', 'string'),
  (@artist, 'timezone', 'America/Bogota', 'string')
ON DUPLICATE KEY UPDATE value = VALUES(value);

-- Artist theme
INSERT INTO artist_themes (artist_id, primary_color, secondary_color, accent_color, font_heading, font_body, dark_mode_default) VALUES
  (@artist, '#111111', '#ffffff', '#ff0000', 'Inter', 'Inter', 0)
ON DUPLICATE KEY UPDATE primary_color = VALUES(primary_color);

-- Artist SEO
INSERT INTO artist_seo (artist_id, meta_title, meta_description, keywords, og_image_url, robots) VALUES
  (@artist, 'Cabitaxx — Musica', 'Descubre la musica de Cabitaxx. Canciones, eventos, tienda y mas.', 'cabitaxx, musica, colombia', 'https://placehold.co/1200x630/111111/ffffff?text=Cabitaxx', 'index,follow')
ON DUPLICATE KEY UPDATE meta_title = VALUES(meta_title);

-- Social links
INSERT INTO artist_social_links (artist_id, platform, url, followers_count) VALUES
  (@artist, 'spotify', 'https://open.spotify.com/artist/cabitaxx', 12500),
  (@artist, 'youtube', 'https://youtube.com/@cabitaxx', 8900),
  (@artist, 'instagram', 'https://instagram.com/cabitaxx', 45000),
  (@artist, 'tiktok', 'https://tiktok.com/@cabitaxx', 32000)
ON DUPLICATE KEY UPDATE url = VALUES(url);

-- Product categories
INSERT INTO product_categories (artist_id, name, slug, description) VALUES
  (@artist, 'Merch', 'merch', 'Camisetas, hoodies y accesorios'),
  (@artist, 'Musica', 'musica', 'Discos, vinilos y descargas digitales')
ON DUPLICATE KEY UPDATE name = VALUES(name);

SET @cat_merch = (SELECT id FROM product_categories WHERE artist_id = @artist AND slug = 'merch');
SET @cat_music = (SELECT id FROM product_categories WHERE artist_id = @artist AND slug = 'musica');

-- Products
INSERT INTO products (artist_id, category_id, name, slug, description, price, compare_at_price, currency, sku, stock_quantity, type, cover_url, status) VALUES
  (@artist, @cat_merch, 'Camiseta Oficial Cabitaxx', 'camiseta-oficial-cabitaxx', 'Camiseta 100% algodon con logo oficial.', 89000, 120000, 'COP', 'MERCH-001', 50, 'physical', 'https://placehold.co/600x600/111111/ffffff?text=Camiseta', 'active'),
  (@artist, @cat_merch, 'Hoodie Edicion Limitada', 'hoodie-edicion-limitada', 'Hoodie exclusivo de la gira.', 149000, 199000, 'COP', 'MERCH-002', 25, 'physical', 'https://placehold.co/600x600/222222/ff0000?text=Hoodie', 'active'),
  (@artist, @cat_music, 'Album Vinilo Firmado', 'album-vinilo-firmado', 'Vinilo firmado por el artista.', 250000, NULL, 'COP', 'MUSIC-001', 10, 'physical', 'https://placehold.co/600x600/333333/ffffff?text=Vinilo', 'active'),
  (@artist, @cat_music, 'Descarga Digital Album', 'descarga-digital-album', 'Album completo en alta calidad.', 35000, NULL, 'COP', 'MUSIC-002', 999, 'digital', 'https://placehold.co/600x600/444444/ffffff?text=Digital', 'active')
ON DUPLICATE KEY UPDATE name = VALUES(name);

-- Album
INSERT INTO albums (artist_id, title, slug, description, cover_url, release_date, type, status) VALUES
  (@artist, 'Inicio', 'inicio', 'Album debut de Cabitaxx.', 'https://placehold.co/600x600/111111/ff0000?text=Inicio', '2025-03-15', 'album', 'published')
ON DUPLICATE KEY UPDATE title = VALUES(title);

SET @album = (SELECT id FROM albums WHERE artist_id = @artist AND slug = 'inicio');

-- Songs
INSERT INTO songs (artist_id, title, slug, duration_seconds, description, cover_url, audio_url, release_date, status, plays_count, likes_count, is_explicit) VALUES
  (@artist, 'Noches de Bogota', 'noches-de-bogota', 210, 'Primer sencillo del album.', 'https://placehold.co/600x600/111111/ffffff?text=Noches', 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3', '2025-03-15', 'published', 15420, 890, 0),
  (@artist, 'Fuego', 'fuego', 195, 'Segundo sencillo con ritmo urbano.', 'https://placehold.co/600x600/222222/ff0000?text=Fuego', 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3', '2025-04-01', 'published', 12300, 650, 0),
  (@artist, 'Amanecer', 'amanecer', 240, 'Balada acustica.', 'https://placehold.co/600x600/333333/ffffff?text=Amanecer', 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3', '2025-04-15', 'published', 9800, 420, 0),
  (@artist, 'No Me Olvides', 'no-me-olvides', 180, 'Colaboracion con Karol Santos.', 'https://placehold.co/600x600/444444/ff0000?text=NoMeOlvides', 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3', '2025-05-01', 'published', 22100, 1200, 0),
  (@artist, 'Ritmo Callejero', 'ritmo-callejero', 200, 'Pista bailable.', 'https://placehold.co/600x600/555555/ffffff?text=Ritmo', 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-5.mp3', '2025-05-15', 'published', 8700, 380, 0),
  (@artist, 'Sueno', 'sueno', 260, 'Track final del album.', 'https://placehold.co/600x600/666666/ff0000?text=Sueno', 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-6.mp3', '2025-06-01', 'published', 6400, 210, 0),
  (@artist, 'Demo Track', 'demo-track', 150, 'Track en borrador.', 'https://placehold.co/600x600/777777/ffffff?text=Demo', 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-7.mp3', '2025-06-15', 'draft', 0, 0, 0)
ON DUPLICATE KEY UPDATE title = VALUES(title);

SET @s1 = (SELECT id FROM songs WHERE artist_id = @artist AND slug = 'noches-de-bogota');
SET @s2 = (SELECT id FROM songs WHERE artist_id = @artist AND slug = 'fuego');
SET @s3 = (SELECT id FROM songs WHERE artist_id = @artist AND slug = 'amanecer');
SET @s4 = (SELECT id FROM songs WHERE artist_id = @artist AND slug = 'no-me-olvides');
SET @s5 = (SELECT id FROM songs WHERE artist_id = @artist AND slug = 'ritmo-callejero');
SET @s6 = (SELECT id FROM songs WHERE artist_id = @artist AND slug = 'sueno');

-- Album songs
INSERT INTO album_songs (album_id, song_id, track_number, disc_number) VALUES
  (@album, @s1, 1, 1),
  (@album, @s2, 2, 1),
  (@album, @s3, 3, 1),
  (@album, @s4, 4, 1),
  (@album, @s5, 5, 1),
  (@album, @s6, 6, 1)
ON DUPLICATE KEY UPDATE track_number = VALUES(track_number);

-- Streaming links
INSERT INTO song_streaming_links (song_id, platform, url) VALUES
  (@s1, 'spotify', 'https://open.spotify.com/track/noches'),
  (@s1, 'youtube', 'https://youtube.com/watch?v=noches'),
  (@s2, 'spotify', 'https://open.spotify.com/track/fuego'),
  (@s2, 'youtube', 'https://youtube.com/watch?v=fuego'),
  (@s3, 'spotify', 'https://open.spotify.com/track/amanecer'),
  (@s4, 'spotify', 'https://open.spotify.com/track/nomeolvides'),
  (@s5, 'youtube', 'https://youtube.com/watch?v=ritmo'),
  (@s6, 'spotify', 'https://open.spotify.com/track/sueno')
ON DUPLICATE KEY UPDATE url = VALUES(url);

-- Events
INSERT INTO events (artist_id, title, slug, description, venue_name, venue_address, city, country, start_datetime, end_datetime, timezone, banner_url, status, is_free, capacity) VALUES
  (@artist, 'Concierto en Bogota', 'concierto-en-bogota', 'Show en vivo en la capital.', 'Movistar Arena', 'Calle 63 #45-10', 'Bogota', 'CO', '2025-08-15T20:00:00', '2025-08-15T23:00:00', 'America/Bogota', 'https://placehold.co/1200x600/111111/ff0000?text=Bogota', 'published', 0, 5000),
  (@artist, 'Festival Medellin', 'festival-medellin', 'Participacion en festival.', 'Plaza Mayor', 'Calle 41 #55-30', 'Medellin', 'CO', '2025-09-20T18:00:00', '2025-09-20T23:00:00', 'America/Bogota', 'https://placehold.co/1200x600/222222/ffffff?text=Medellin', 'published', 1, 20000),
  (@artist, 'Lanzamiento Album', 'lanzamiento-album', 'Evento de lanzamiento oficial.', 'Auditorio Nacional', 'Calle 23 #10-20', 'Bogota', 'CO', '2025-07-30T19:00:00', '2025-07-30T22:00:00', 'America/Bogota', 'https://placehold.co/1200x600/333333/ff0000?text=Lanzamiento', 'published', 0, 800)
ON DUPLICATE KEY UPDATE title = VALUES(title);

SET @e1 = (SELECT id FROM events WHERE artist_id = @artist AND slug = 'concierto-en-bogota');
SET @e2 = (SELECT id FROM events WHERE artist_id = @artist AND slug = 'festival-medellin');
SET @e3 = (SELECT id FROM events WHERE artist_id = @artist AND slug = 'lanzamiento-album');

-- Tickets
INSERT INTO tickets (event_id, name, price, currency, quantity, sold, sort_order) VALUES
  (@e1, 'General', 85000, 'COP', 4000, 1200, 1),
  (@e1, 'VIP', 180000, 'COP', 800, 650, 2),
  (@e2, 'General', 60000, 'COP', 15000, 4300, 1),
  (@e3, 'Preventa', 70000, 'COP', 500, 200, 1),
  (@e3, 'Puerta', 90000, 'COP', 300, 50, 2)
ON DUPLICATE KEY UPDATE name = VALUES(name);

-- Posts (blog + news)
INSERT INTO posts (artist_id, user_id, type, title, slug, content, excerpt, cover_url, status, published_at, views_count) VALUES
  (@artist, @admin, 'news', 'Nuevo sencillo Fuego ya esta disponible', 'nuevo-sencillo-fuego', 'Estamos emocionados de presentar nuestro nuevo sencillo Fuego, disponible en todas las plataformas.', 'Fuego ya esta disponible en Spotify, YouTube y Apple Music.', 'https://placehold.co/1200x630/111111/ff0000?text=Fuego', 'published', '2025-04-01T10:00:00', 3450),
  (@artist, @admin, 'blog', 'Detras de camara: grabacion de Amanecer', 'detras-camara-amanecer', 'Amanecer fue grabado en los estudios de Bogota con produccion de XYZ.', 'Conoce el proceso creativo detras de nuestra balada acustica.', 'https://placehold.co/1200x630/333333/ffffff?text=Amanecer', 'published', '2025-04-20T14:00:00', 2100),
  (@artist, @admin, 'news', 'Gira 2025 anunciada', 'gira-2025-anunciada', 'Anunciamos las primeras fechas de la gira 2025 por Colombia.', 'Bogota, Medellin y Cali son las primeras ciudades confirmadas.', 'https://placehold.co/1200x630/222222/ff0000?text=Gira2025', 'published', '2025-05-10T09:00:00', 8900)
ON DUPLICATE KEY UPDATE title = VALUES(title);

SET @p1 = (SELECT id FROM posts WHERE artist_id = @artist AND slug = 'nuevo-sencillo-fuego');
SET @p2 = (SELECT id FROM posts WHERE artist_id = @artist AND slug = 'detras-camara-amanecer');
SET @p3 = (SELECT id FROM posts WHERE artist_id = @artist AND slug = 'gira-2025-anunciada');

-- Gallery items
INSERT INTO gallery_items (artist_id, title, description, file_url, file_type, category, sort_order, status) VALUES
  (@artist, 'Sesion de fotos Bogota', 'Sesion oficial para el album.', 'https://placehold.co/800x600/111111/ffffff?text=Session1', 'image', 'official', 1, 'active'),
  (@artist, 'Concierto Medellin 2024', 'Show en Medellin.', 'https://placehold.co/800x600/222222/ff0000?text=Concierto', 'image', 'live', 2, 'active'),
  (@artist, 'Backstage Festival', 'Momento backstage.', 'https://placehold.co/800x600/333333/ffffff?text=Backstage', 'image', 'live', 3, 'active'),
  (@artist, 'Video lyric Amanecer', 'Lyric video oficial.', 'https://placehold.co/800x600/444444/ff0000?text=Lyric', 'video', 'music', 4, 'active'),
  (@artist, 'Foto estudio', 'Grabacion en estudio.', 'https://placehold.co/800x600/555555/ffffff?text=Estudio', 'image', 'official', 5, 'active'),
  (@artist, 'Fans en concierto', 'Publico en vivo.', 'https://placehold.co/800x600/666666/ff0000?text=Fans', 'image', 'live', 6, 'active')
ON DUPLICATE KEY UPDATE title = VALUES(title);

-- Coupons
INSERT INTO coupons (artist_id, code, discount_type, discount_value, min_amount, max_uses, used_count, expires_at, status) VALUES
  (@artist, 'CABITAXX10', 'percentage', 10, 50000, 100, 12, '2025-12-31', 'active'),
  (@artist, 'BIENVENIDA', 'fixed', 20000, 100000, 50, 5, '2025-12-31', 'active')
ON DUPLICATE KEY UPDATE code = VALUES(code);

-- Comments demo
INSERT INTO comments (user_id, artist_id, reference_id, reference_type, content, status, parent_id) VALUES
  ((SELECT id FROM users WHERE email='fan1@cabitaxx.com'), @artist, (SELECT id FROM songs WHERE slug='noches-de-bogota'), 'song', 'Tema increible!', 'approved', NULL),
  ((SELECT id FROM users WHERE email='fan2@cabitaxx.com'), @artist, (SELECT id FROM songs WHERE slug='ritmo-callejero'), 'song', 'El ritmo es viral.', 'approved', NULL),
  ((SELECT id FROM users WHERE email='manager@cabitaxx.com'), @artist, (SELECT id FROM posts WHERE slug='gira-2025-anunciada'), 'post', 'Voy al de Bogota!', 'approved', NULL),
  ((SELECT id FROM users WHERE email='admin@mastercode.co'), @artist, (SELECT id FROM posts WHERE slug='gira-2025-anunciada'), 'post', 'Te esperamos.', 'approved', (SELECT id FROM comments WHERE content='Voy al de Bogota!' AND artist_id=@artist)),
  ((SELECT id FROM users WHERE email='mod@cabitaxx.com'), @artist, (SELECT id FROM events WHERE slug='concierto-en-bogota'), 'event', 'Compre VIP.', 'approved', NULL),
  ((SELECT id FROM users WHERE email='fan3@cabitaxx.com'), @artist, (SELECT id FROM songs WHERE slug='amanecer'), 'song', 'Me hace llorar.', 'approved', NULL),
  ((SELECT id FROM users WHERE email='fan5@cabitaxx.com'), @artist, (SELECT id FROM posts WHERE slug='detras-camara-amanecer'), 'post', 'La sudadera es buenisima.', 'approved', NULL),
  ((SELECT id FROM users WHERE email='fan9@cabitaxx.com'), @artist, (SELECT id FROM videos WHERE slug='ritmo-live'), 'video', 'El live fue epico.', 'pending', NULL),
  ((SELECT id FROM users WHERE email='fan4@cabitaxx.com'), @artist, (SELECT id FROM songs WHERE slug='fuego'), 'song', 'Ponganla en la gira.', 'spam', NULL),
  ((SELECT id FROM users WHERE email='fan10@cabitaxx.com'), @artist, (SELECT id FROM events WHERE slug='lanzamiento-album'), 'event', 'Gracias por el meet.', 'approved', NULL)
ON DUPLICATE KEY UPDATE content = VALUES(content);

-- Likes demo
INSERT INTO likes (user_id, artist_id, reference_id, reference_type) VALUES
  ((SELECT id FROM users WHERE email='fan1@cabitaxx.com'), @artist, (SELECT id FROM songs WHERE slug='noches-de-bogota'), 'song'),
  ((SELECT id FROM users WHERE email='fan2@cabitaxx.com'), @artist, (SELECT id FROM songs WHERE slug='ritmo-callejero'), 'song'),
  ((SELECT id FROM users WHERE email='fan5@cabitaxx.com'), @artist, (SELECT id FROM posts WHERE slug='gira-2025-anunciada'), 'post'),
  ((SELECT id FROM users WHERE email='admin@mastercode.co'), @artist, (SELECT id FROM videos WHERE slug='nocturna-video'), 'video'),
  ((SELECT id FROM users WHERE email='mod@cabitaxx.com'), @artist, (SELECT id FROM songs WHERE slug='amanecer'), 'song'),
  ((SELECT id FROM users WHERE email='fan3@cabitaxx.com'), @artist, (SELECT id FROM albums WHERE slug='inicio'), 'album'),
  ((SELECT id FROM users WHERE email='fan9@cabitaxx.com'), @artist, (SELECT id FROM events WHERE slug='concierto-en-bogota'), 'event'),
  ((SELECT id FROM users WHERE email='fan10@cabitaxx.com'), @artist, (SELECT id FROM songs WHERE slug='fuego'), 'song'),
  ((SELECT id FROM users WHERE email='fan1@cabitaxx.com'), @artist, (SELECT id FROM posts WHERE slug='merch-coleccion'), 'post'),
  ((SELECT id FROM users WHERE email='fan4@cabitaxx.com'), @artist, (SELECT id FROM videos WHERE slug='promesa-video'), 'video')
ON DUPLICATE KEY UPDATE user_id = VALUES(user_id);

-- Follows demo
INSERT INTO follows (user_id, artist_id) VALUES
  ((SELECT id FROM users WHERE email='fan1@cabitaxx.com'), @artist),
  ((SELECT id FROM users WHERE email='fan2@cabitaxx.com'), @artist),
  ((SELECT id FROM users WHERE email='fan3@cabitaxx.com'), @artist),
  ((SELECT id FROM users WHERE email='fan5@cabitaxx.com'), @artist),
  ((SELECT id FROM users WHERE email='fan9@cabitaxx.com'), @artist),
  ((SELECT id FROM users WHERE email='fan10@cabitaxx.com'), @artist),
  ((SELECT id FROM users WHERE email='fan4@cabitaxx.com'), @artist),
  ((SELECT id FROM users WHERE email='mod@cabitaxx.com'), @artist),
  ((SELECT id FROM users WHERE email='manager@cabitaxx.com'), @artist),
  ((SELECT id FROM users WHERE email='admin@mastercode.co'), @artist)
ON DUPLICATE KEY UPDATE user_id = VALUES(user_id);

-- Orders demo para Mercado Pago
INSERT INTO orders (user_id, artist_id, status, subtotal, discount, shipping, tax, total, currency, coupon_id, notes, shipping_address)
VALUES
  ((SELECT id FROM users WHERE email='fan1@cabitaxx.com'), @artist, 'paid', 89000.00, 0.00, 0.00, 0.00, 89000.00, 'COP', NULL, 'Camiseta', '{"street":"Calle 10","city":"Bogota","zip":"110111","country":"CO"}'),
  ((SELECT id FROM users WHERE email='fan2@cabitaxx.com'), @artist, 'paid', 250000.00, 25000.00, 0.00, 0.00, 225000.00, 'COP', (SELECT id FROM coupons WHERE code='CABITAXX10'), 'Vinilo + descuento', '{"street":"Calle 20","city":"Medellin","zip":"050001","country":"CO"}'),
  ((SELECT id FROM users WHERE email='fan3@cabitaxx.com'), @artist, 'pending', 149000.00, 0.00, 15000.00, 0.00, 164000.00, 'COP', NULL, 'Hoodie', '{"street":"Calle 30","city":"Cali","zip":"760001","country":"CO"}'),
  ((SELECT id FROM users WHERE email='fan5@cabitaxx.com'), @artist, 'paid', 35000.00, 0.00, 0.00, 0.00, 35000.00, 'COP', NULL, 'Digital', '{"email":"fan5@cabitaxx.com"}'),
  ((SELECT id FROM users WHERE email='fan9@cabitaxx.com'), @artist, 'cancelled', 80000.00, 0.00, 15000.00, 0.00, 95000.00, 'COP', NULL, 'Cancelado', '{"street":"Calle 40","city":"Bogota","zip":"110111","country":"CO"}')
ON DUPLICATE KEY UPDATE total = VALUES(total);

SET @mp_o1 = (SELECT id FROM orders WHERE user_id=(SELECT id FROM users WHERE email='fan1@cabitaxx.com') AND status='paid' ORDER BY id DESC LIMIT 1);
SET @mp_o2 = (SELECT id FROM orders WHERE user_id=(SELECT id FROM users WHERE email='fan2@cabitaxx.com') AND status='paid' ORDER BY id DESC LIMIT 1);
SET @mp_o3 = (SELECT id FROM orders WHERE user_id=(SELECT id FROM users WHERE email='fan3@cabitaxx.com') AND status='pending' ORDER BY id DESC LIMIT 1);

-- Payments demo Mercado Pago
INSERT INTO payments (order_id, user_id, artist_id, provider, provider_tx_id, amount, currency, status, response_json, paid_at) VALUES
  (@mp_o1, (SELECT id FROM users WHERE email='fan1@cabitaxx.com'), @artist, 'mercadopago', 'mp_mock_001', 89000.00, 'COP', 'succeeded', '{"status":"approved","init_point":"/pagos/mercado-pago?pref_id=mock_mp_001","external_reference":"' + CAST(@mp_o1 AS CHAR) + '"}', NOW()),
  (@mp_o2, (SELECT id FROM users WHERE email='fan2@cabitaxx.com'), @artist, 'mercadopago', 'mp_mock_002', 225000.00, 'COP', 'succeeded', '{"status":"approved","init_point":"/pagos/mercado-pago?pref_id=mock_mp_002","external_reference":"' + CAST(@mp_o2 AS CHAR) + '"}', NOW()),
  (@mp_o3, (SELECT id FROM users WHERE email='fan3@cabitaxx.com'), @artist, 'mercadopago', 'mp_mock_003', 164000.00, 'COP', 'pending', '{"status":"pending","init_point":"/pagos/mercado-pago?pref_id=mock_mp_003","external_reference":"' + CAST(@mp_o3 AS CHAR) + '"}', NULL)
ON DUPLICATE KEY UPDATE status = VALUES(status);


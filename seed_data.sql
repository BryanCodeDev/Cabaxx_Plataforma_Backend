-- ============================================================
-- Cabaxx — SEED DE DATOS
-- ============================================================
-- IMPORTANTE: Ejecutar DESPUES de database.sql (esquema + seed base).
-- Solo 1 artista: Cabaxx. El resto son usuarios/fans/admins de el.
-- ============================================================

USE map_platform;

SET SQL_SAFE_UPDATES = 0;

SET @cabaxx = (SELECT id FROM artists WHERE slug = 'cabaxx');
SET @super    = (SELECT id FROM users WHERE email = 'admin@cabaxx.com');
SET @a1 = @cabaxx;

-- ------------------------------------------------------------
-- ARTISTS (6 adicionales -> 7 en total con Cabaxx)
-- ------------------------------------------------------------
INSERT INTO artists (slug, stage_name, real_name, bio, short_bio, genre, country, city, status)
VALUES ('karolsantos','Karol Santos','Karol Andrea Santos','Cantante pop urbana de Medellin.','Pop urbano colombiano.','Pop','CO','Medellin','active');
SET @a2 = LAST_INSERT_ID();
INSERT INTO artists (slug, stage_name, real_name, bio, short_bio, genre, country, city, status)
VALUES ('luismiguel','Luis Miguel Vega','Luis Miguel Vega Rojas','Tropical y vallenato moderno.','Vallenato fusion.','Tropical','CO','Barranquilla','active');
SET @a3 = LAST_INSERT_ID();
INSERT INTO artists (slug, stage_name, real_name, bio, short_bio, genre, country, city, status)
VALUES ('bandaoficial','Banda Oficial','Colectivo Banda Oficial','Agrupacion de rock en espanol.','Rock en espanol.','Rock','MX','CDMX','active');
SET @a4 = LAST_INSERT_ID();
INSERT INTO artists (slug, stage_name, real_name, bio, short_bio, genre, country, city, status)
VALUES ('djnexus','DJ Nexus','Andres Nexus','DJ de musica electronica.','Electronic / EDM.','Electronic','CO','Cali','active');
SET @a5 = LAST_INSERT_ID();
INSERT INTO artists (slug, stage_name, real_name, bio, short_bio, genre, country, city, status)
VALUES ('mariacamila','Maria Camila','Maria Camila Diaz','Pop latino juvenil.','Pop latino.','Pop','CO','Bogota','active');
SET @a6 = LAST_INSERT_ID();

-- ------------------------------------------------------------
-- USERS (10 fans/admins adicionales)
-- ------------------------------------------------------------
SET @u1 = @super;
INSERT INTO users (name, email, password_hash, avatar_url, status)
VALUES ('Fan Uno','fan1@cabaxx.com','$2b$10$XH3XRkifdZKdwGCtUZnA3OuNxn5SkFnfOT.fFpJEMmvj3tTo1S6La',NULL,'active');
SET @u2 = LAST_INSERT_ID();
INSERT INTO users (name, email, password_hash, avatar_url, status)
VALUES ('Fan Dos','fan2@cabaxx.com','$2b$10$XH3XRkifdZKdwGCtUZnA3OuNxn5SkFnfOT.fFpJEMmvj3tTo1S6La',NULL,'active');
SET @u3 = LAST_INSERT_ID();
INSERT INTO users (name, email, password_hash, avatar_url, status)
VALUES ('Fan Tres','fan3@cabaxx.com','$2b$10$XH3XRkifdZKdwGCtUZnA3OuNxn5SkFnfOT.fFpJEMmvj3tTo1S6La',NULL,'active');
SET @u4 = LAST_INSERT_ID();
INSERT INTO users (name, email, password_hash, avatar_url, status)
VALUES ('Fan Cuatro','fan4@cabaxx.com','$2b$10$XH3XRkifdZKdwGCtUZnA3OuNxn5SkFnfOT.fFpJEMmvj3tTo1S6La',NULL,'inactive');
SET @u5 = LAST_INSERT_ID();
INSERT INTO users (name, email, password_hash, avatar_url, status)
VALUES ('Fan Cinco','fan5@cabaxx.com','$2b$10$XH3XRkifdZKdwGCtUZnA3OuNxn5SkFnfOT.fFpJEMmvj3tTo1S6La',NULL,'active');
SET @u6 = LAST_INSERT_ID();
INSERT INTO users (name, email, password_hash, avatar_url, status)
VALUES ('Manager Cabaxx','manager@cabaxx.com','$2b$10$XH3XRkifdZKdwGCtUZnA3OuNxn5SkFnfOT.fFpJEMmvj3tTo1S6La',NULL,'active');
SET @u7 = LAST_INSERT_ID();
INSERT INTO users (name, email, password_hash, avatar_url, status)
VALUES ('Moderadora','mod@cabaxx.com','$2b$10$XH3XRkifdZKdwGCtUZnA3OuNxn5SkFnfOT.fFpJEMmvj3tTo1S6La',NULL,'active');
SET @u8 = LAST_INSERT_ID();
INSERT INTO users (name, email, password_hash, avatar_url, status)
VALUES ('Fan Ocho','fan8@cabaxx.com','$2b$10$XH3XRkifdZKdwGCtUZnA3OuNxn5SkFnfOT.fFpJEMmvj3tTo1S6La',NULL,'banned');
SET @u9 = LAST_INSERT_ID();
INSERT INTO users (name, email, password_hash, avatar_url, status)
VALUES ('Fan Nueve','fan9@cabaxx.com','$2b$10$XH3XRkifdZKdwGCtUZnA3OuNxn5SkFnfOT.fFpJEMmvj3tTo1S6La',NULL,'active');
SET @u10 = LAST_INSERT_ID();
INSERT INTO users (name, email, password_hash, avatar_url, status)
VALUES ('Fan Diez','fan10@cabaxx.com','$2b$10$XH3XRkifdZKdwGCtUZnA3OuNxn5SkFnfOT.fFpJEMmvj3tTo1S6La',NULL,'active');
SET @u11 = LAST_INSERT_ID();

-- ------------------------------------------------------------
-- ROLES (10 adicionales)
-- ------------------------------------------------------------
INSERT INTO roles (name, slug, description) VALUES ('Editor','editor','Edicion de contenido');
SET @r5 = LAST_INSERT_ID();
INSERT INTO roles (name, slug, description) VALUES ('Moderador','moderator','Modera comentarios');
SET @r6 = LAST_INSERT_ID();
INSERT INTO roles (name, slug, description) VALUES ('Soporte','support','Atencion al cliente');
SET @r7 = LAST_INSERT_ID();
INSERT INTO roles (name, slug, description) VALUES ('Finanzas','finance','Ve pagos y reportes');
SET @r8 = LAST_INSERT_ID();
INSERT INTO roles (name, slug, description) VALUES ('Marketing','marketing','Campanas y SEO');
SET @r9 = LAST_INSERT_ID();
INSERT INTO roles (name, slug, description) VALUES ('Content Manager','content_manager','Gestiona blog/redes');
SET @r10 = LAST_INSERT_ID();
INSERT INTO roles (name, slug, description) VALUES ('Analista','analyst','Analitica del artista');
SET @r11 = LAST_INSERT_ID();
INSERT INTO roles (name, slug, description) VALUES ('Manager','manager','Manager del artista');
SET @r12 = LAST_INSERT_ID();
INSERT INTO roles (name, slug, description) VALUES ('Colaborador','collaborator','Artista invitado');
SET @r13 = LAST_INSERT_ID();
INSERT INTO roles (name, slug, description) VALUES ('Premium','premium','Fan premium');
SET @r14 = LAST_INSERT_ID();

-- ------------------------------------------------------------
-- PERMISSIONS (10 adicionales)
-- ------------------------------------------------------------
INSERT INTO permissions (name, slug, module, description) VALUES ('Gestionar usuarios','users.manage','users','CRUD de usuarios');
SET @p13 = LAST_INSERT_ID();
INSERT INTO permissions (name, slug, module, description) VALUES ('Ver finanzas','finance.view','finance','Reportes financieros');
SET @p14 = LAST_INSERT_ID();
INSERT INTO permissions (name, slug, module, description) VALUES ('Moderar comentarios','comments.moderate','community','Aprobar/spam');
SET @p15 = LAST_INSERT_ID();
INSERT INTO permissions (name, slug, module, description) VALUES ('Gestionar cupones','coupons.manage','store','CRUD cupones');
SET @p16 = LAST_INSERT_ID();
INSERT INTO permissions (name, slug, module, description) VALUES ('Gestionar envios','shipping.manage','store','Estado de envios');
SET @p17 = LAST_INSERT_ID();
INSERT INTO permissions (name, slug, module, description) VALUES ('Gestionar tickets','tickets.manage','events','CRUD de tickets');
SET @p18 = LAST_INSERT_ID();
INSERT INTO permissions (name, slug, module, description) VALUES ('Gestionar dominios','domains.manage','saas','Dominios custom');
SET @p19 = LAST_INSERT_ID();
INSERT INTO permissions (name, slug, module, description) VALUES ('Gestionar temas','themes.manage','artist','Tema visual');
SET @p20 = LAST_INSERT_ID();
INSERT INTO permissions (name, slug, module, description) VALUES ('Exportar datos','data.export','saas','Exportar reportes');
SET @p21 = LAST_INSERT_ID();
INSERT INTO permissions (name, slug, module, description) VALUES ('Ver auditoria','audit.view','saas','Logs de auditoria');
SET @p22 = LAST_INSERT_ID();

-- ------------------------------------------------------------
-- ROLE_PERMISSIONS (10 asignaciones extra)
-- ------------------------------------------------------------
INSERT INTO role_permissions (role_id, permission_id) VALUES
  ((SELECT id FROM roles WHERE slug='artist_admin'), (SELECT id FROM permissions WHERE slug='users.manage')),
  ((SELECT id FROM roles WHERE slug='artist_admin'), (SELECT id FROM permissions WHERE slug='coupons.manage')),
  ((SELECT id FROM roles WHERE slug='artist_admin'), (SELECT id FROM permissions WHERE slug='tickets.manage')),
  ((SELECT id FROM roles WHERE slug='artist_admin'), (SELECT id FROM permissions WHERE slug='themes.manage')),
  ((SELECT id FROM roles WHERE slug='artist_admin'), (SELECT id FROM permissions WHERE slug='comments.moderate')),
  ((SELECT id FROM roles WHERE slug='artist_admin'), (SELECT id FROM permissions WHERE slug='shipping.manage')),
  ((SELECT id FROM roles WHERE slug='user'), (SELECT id FROM permissions WHERE slug='finance.view')),
  ((SELECT id FROM roles WHERE slug='user'), (SELECT id FROM permissions WHERE slug='data.export')),
  ((SELECT id FROM roles WHERE slug='superadmin'), (SELECT id FROM permissions WHERE slug='domains.manage')),
  ((SELECT id FROM roles WHERE slug='superadmin'), (SELECT id FROM permissions WHERE slug='audit.view'));

-- ------------------------------------------------------------
-- USER_ROLES (10 asignaciones multi-tenant)
-- ------------------------------------------------------------
INSERT INTO user_roles (user_id, role_id, artist_id) VALUES
  (@u6, (SELECT id FROM roles WHERE slug='artist_admin'), @a1),
  (@u7, (SELECT id FROM roles WHERE slug='moderator'), @a1),
  (@u7, (SELECT id FROM roles WHERE slug='moderator'), @a2),
  (@u2, (SELECT id FROM roles WHERE slug='user'), NULL),
  (@u3, (SELECT id FROM roles WHERE slug='user'), NULL),
  (@u4, (SELECT id FROM roles WHERE slug='premium'), @a1),
  (@u5, (SELECT id FROM roles WHERE slug='user'), @a3),
  (@u9, (SELECT id FROM roles WHERE slug='user'), @a1),
  (@u10, (SELECT id FROM roles WHERE slug='user'), @a2),
  (@u11, (SELECT id FROM roles WHERE slug='manager'), @a1);

-- ------------------------------------------------------------
-- REFRESH_TOKENS (10)
-- ------------------------------------------------------------
INSERT INTO refresh_tokens (user_id, token_hash, expires_at, revoked_at, ip_address, user_agent) VALUES
  (@u2,'rt_hash_001',DATE_ADD(NOW(),INTERVAL 30 DAY),NULL,'190.1.1.10','Mozilla/5.0 Win'),
  (@u3,'rt_hash_002',DATE_ADD(NOW(),INTERVAL 30 DAY),NULL,'190.1.1.11','Mozilla/5.0 Mac'),
  (@u5,'rt_hash_003',DATE_ADD(NOW(),INTERVAL 30 DAY),NULL,'190.1.1.12','Chrome Android'),
  (@u6,'rt_hash_004',DATE_ADD(NOW(),INTERVAL 30 DAY),NULL,'190.1.1.13','Mozilla/5.0 Win'),
  (@u7,'rt_hash_005',DATE_ADD(NOW(),INTERVAL 30 DAY),NULL,'190.1.1.14','Safari iPhone'),
  (@u9,'rt_hash_006',DATE_ADD(NOW(),INTERVAL 30 DAY),NULL,'190.1.1.15','Chrome Linux'),
  (@u10,'rt_hash_007',DATE_ADD(NOW(),INTERVAL 30 DAY),NULL,'190.1.1.16','Firefox Win'),
  (@u11,'rt_hash_008',DATE_ADD(NOW(),INTERVAL 30 DAY),NULL,'190.1.1.17','Edge Win'),
  (@u1,'rt_hash_009',DATE_ADD(NOW(),INTERVAL 30 DAY),NULL,'190.1.1.18','Postman'),
  (@u4,'rt_hash_010',DATE_ADD(NOW(),INTERVAL 1 DAY),NOW(),'190.1.1.19','Mozilla/5.0 Win');

-- ------------------------------------------------------------
-- SESSIONS (10)
-- ------------------------------------------------------------
INSERT INTO sessions (user_id, token_hash, expires_at, ip_address, device_info) VALUES
  (@u2,'se_hash_001',DATE_ADD(NOW(),INTERVAL 7 DAY),'190.1.1.10','Desktop/Windows'),
  (@u3,'se_hash_002',DATE_ADD(NOW(),INTERVAL 7 DAY),'190.1.1.11','Desktop/macOS'),
  (@u5,'se_hash_003',DATE_ADD(NOW(),INTERVAL 7 DAY),'190.1.1.12','Mobile/Android'),
  (@u6,'se_hash_004',DATE_ADD(NOW(),INTERVAL 7 DAY),'190.1.1.13','Desktop/Windows'),
  (@u7,'se_hash_005',DATE_ADD(NOW(),INTERVAL 7 DAY),'190.1.1.14','Mobile/iOS'),
  (@u9,'se_hash_006',DATE_ADD(NOW(),INTERVAL 7 DAY),'190.1.1.15','Desktop/Linux'),
  (@u10,'se_hash_007',DATE_ADD(NOW(),INTERVAL 7 DAY),'190.1.1.16','Desktop/Windows'),
  (@u11,'se_hash_008',DATE_ADD(NOW(),INTERVAL 7 DAY),'190.1.1.17','Desktop/Windows'),
  (@u1,'se_hash_009',DATE_ADD(NOW(),INTERVAL 7 DAY),'190.1.1.18','API/Postman'),
  (@u4,'se_hash_010',DATE_ADD(NOW(),INTERVAL 7 DAY),'190.1.1.19','Desktop/Windows');

-- ------------------------------------------------------------
-- PASSWORD_RESETS (10)
-- ------------------------------------------------------------
INSERT INTO password_resets (email, token_hash, expires_at, used_at) VALUES
  ('fan1@cabaxx.com','pr_hash_001',DATE_ADD(NOW(),INTERVAL 1 HOUR),NULL),
  ('fan2@cabaxx.com','pr_hash_002',DATE_ADD(NOW(),INTERVAL 1 HOUR),NOW()),
  ('fan3@cabaxx.com','pr_hash_003',DATE_ADD(NOW(),INTERVAL 1 HOUR),NULL),
  ('fan5@cabaxx.com','pr_hash_004',DATE_ADD(NOW(),INTERVAL 1 HOUR),NULL),
  ('manager@cabaxx.com','pr_hash_005',DATE_ADD(NOW(),INTERVAL 1 HOUR),NULL),
  ('mod@cabaxx.com','pr_hash_006',DATE_ADD(NOW(),INTERVAL 1 HOUR),NULL),
  ('fan8@cabaxx.com','pr_hash_007',DATE_ADD(NOW(),INTERVAL 1 HOUR),NULL),
  ('fan9@cabaxx.com','pr_hash_008',DATE_ADD(NOW(),INTERVAL 1 HOUR),NULL),
  ('fan10@cabaxx.com','pr_hash_009',DATE_ADD(NOW(),INTERVAL 1 HOUR),NULL),
  ('admin@cabaxx.com','pr_hash_010',DATE_ADD(NOW(),INTERVAL 1 HOUR),NULL);

-- ------------------------------------------------------------
-- ARTIST_SOCIAL_LINKS (10)
-- ------------------------------------------------------------
INSERT INTO artist_social_links (artist_id, platform, url, followers_count, last_synced_at) VALUES
  (@a1,'spotify','https://open.spotify.com/artist/cabaxx',125000,DATE_ADD(NOW(),INTERVAL -1 DAY)),
  (@a1,'youtube','https://youtube.com/@cabaxx',98000,DATE_ADD(NOW(),INTERVAL -1 DAY)),
  (@a1,'instagram','https://instagram.com/cabaxx',210000,DATE_ADD(NOW(),INTERVAL -2 DAY)),
  (@a2,'spotify','https://open.spotify.com/artist/karolsantos',54000,DATE_ADD(NOW(),INTERVAL -3 DAY)),
  (@a2,'instagram','https://instagram.com/karolsantos',88000,DATE_ADD(NOW(),INTERVAL -3 DAY)),
  (@a3,'youtube','https://youtube.com/@luismiguel',33000,DATE_ADD(NOW(),INTERVAL -4 DAY)),
  (@a4,'spotify','https://open.spotify.com/artist/bandaoficial',21000,DATE_ADD(NOW(),INTERVAL -5 DAY)),
  (@a5,'instagram','https://instagram.com/djnexus',77000,DATE_ADD(NOW(),INTERVAL -1 DAY)),
  (@a6,'tiktok','https://tiktok.com/@mariacamila',150000,DATE_ADD(NOW(),INTERVAL -1 DAY));

-- ------------------------------------------------------------
-- ARTIST_THEMES (1 por artista -> 10)
-- ------------------------------------------------------------
INSERT INTO artist_themes (artist_id, primary_color, secondary_color, accent_color, font_heading, font_body, dark_mode_default) VALUES
  (@a1,'#0B0B0F','#FFFFFF','#E50914','Inter','Inter',1),
  (@a2,'#1E1E2E','#F5F5F5','#FF6FB5','Poppins','Poppins',0),
  (@a3,'#0A3D2C','#FAFAFA','#F2C14E','Montserrat','Montserrat',1),
  (@a4,'#1A1A1A','#EAEAEA','#FF7A00','Oswald','Roboto',1),
  (@a5,'#2B2D42','#FFFFFF','#8D99AE','Lora','Lora',0),
  (@a6,'#06070A','#00FFC6','#00FFC6','Rajdhani','Rajdhani',1);

-- ------------------------------------------------------------
-- ARTIST_SEO (1 por artista -> 10)
-- ------------------------------------------------------------
INSERT INTO artist_seo (artist_id, meta_title, meta_description, keywords, og_image_url, schema_json, robots) VALUES
  (@a1,'Cabaxx | Musica Urbana','Official site of Cabaxx.','cabaxx, musica urbana, latin','https://cdn.cabaxx.app/cabaxx/og.png','{"@type":"MusicGroup"}','index,follow'),
  (@a2,'Karol Santos | Pop','Sitio oficial Karol Santos.','karol santos, pop','https://cdn.cabaxx.app/karol/og.png','{"@type":"MusicGroup"}','index,follow'),
  (@a3,'Luis Miguel Vega','Vallenato fusion.','vallenato, tropical','https://cdn.cabaxx.app/lmv/og.png','{"@type":"MusicGroup"}','index,follow'),
  (@a4,'Banda Oficial','Rock en espanol.','rock, banda','https://cdn.cabaxx.app/banda/og.png','{"@type":"MusicGroup"}','noindex,follow'),
  (@a5,'DJ Nexus','Electronic EDM.','edm, dj','https://cdn.cabaxx.app/nexus/og.png','{"@type":"MusicGroup"}','index,follow'),
  (@a6,'Maria Camila','Pop latino.','pop latino','https://cdn.cabaxx.app/mc/og.png','{"@type":"MusicGroup"}','index,follow');

-- ------------------------------------------------------------
-- ARTIST_SETTINGS (10)
-- ------------------------------------------------------------
INSERT INTO artist_settings (artist_id, `key`, value, type) VALUES
  (@a1,'language','es','string'),
  (@a1,'currency_default','COP','string'),
  (@a1,'store_enabled','1','boolean'),
  (@a1,'events_enabled','1','boolean'),
  (@a1,'newsletter_from','hola@cabaxx.com','string'),
  (@a1,'social_auto_post','0','boolean'),
  (@a1,'max_free_tickets','2','number'),
  (@a1,'maintenance_mode','0','boolean'),
  (@a1,'contact_email','contacto@cabaxx.com','string'),
  (@a1,'theme_preset','neon','string');

-- ------------------------------------------------------------
-- ARTIST_DOMAINS (10)
-- ------------------------------------------------------------
INSERT INTO artist_domains (artist_id, domain, ssl_status, is_primary) VALUES
  (@a1,'cabaxx.com','active',1),
  (@a1,'www.cabaxx.com','active',0),
  (@a2,'karolsantos.com','active',1),
  (@a3,'luismiguelvega.mx','pending',1),
  (@a4,'bandaoficial.mx','active',1),
  (@a5,'djnexus.live','active',1);

-- ------------------------------------------------------------
-- SONGS (10)
-- ------------------------------------------------------------
INSERT INTO songs (artist_id, title, slug, duration_seconds, lyrics, description, cover_url, audio_url, release_date, status, plays_count, likes_count, is_explicit) VALUES
  (@a1,'Nocturna','nocturna',192,NULL,'Single principal 2025.','https://cdn.cabaxx.app/cabaxx/nocturna.jpg','https://cdn.cabaxx.app/cabaxx/nocturna.mp3','2025-01-15','published',128000,8400,0),
  (@a1,'Fuego en la Ciudad','fuego-en-la-ciudad',205,NULL,'Tema urbano.','https://cdn.cabaxx.app/cabaxx/fuego.jpg','https://cdn.cabaxx.app/cabaxx/fuego.mp3','2025-02-20','published',96000,6100,0),
  (@a1,'Mar de Estrellas','mar-de-estrellas',221,NULL,'Balada.','https://cdn.cabaxx.app/cabaxx/mar.jpg','https://cdn.cabaxx.app/cabaxx/mar.mp3','2025-03-10','published',73000,5200,0),
  (@a1,'Ritmo Cabi','ritmo-cabi',188,NULL,'Reggaeton.','https://cdn.cabaxx.app/cabaxx/ritmo.jpg','https://cdn.cabaxx.app/cabaxx/ritmo.mp3','2025-04-05','published',152000,9900,0),
  (@a1,'Lejos de Ti','lejos-de-ti',234,NULL,'Despecho.','https://cdn.cabaxx.app/cabaxx/lejos.jpg','https://cdn.cabaxx.app/cabaxx/lejos.mp3','2025-05-12','published',64000,4300,0),
  (@a1,'Electrica','electrica',199,NULL,'EDM latino.','https://cdn.cabaxx.app/cabaxx/electrica.jpg','https://cdn.cabaxx.app/cabaxx/electrica.mp3','2025-06-01','published',88000,5600,0),
  (@a1,'Calle y Sol','calle-y-sol',210,NULL,'Tropical.','https://cdn.cabaxx.app/cabaxx/calle.jpg','https://cdn.cabaxx.app/cabaxx/calle.mp3','2025-06-18','published',47000,3100,0),
  (@a1,'Promesa','promesa',203,NULL,' feat. invitado.','https://cdn.cabaxx.app/cabaxx/promesa.jpg','https://cdn.cabaxx.app/cabaxx/promesa.mp3','2025-07-02','published',102000,7200,0),
  (@a1,'Vuelo Libre','vuelo-libre',217,NULL,'Pop.','https://cdn.cabaxx.app/cabaxx/vuelo.jpg','https://cdn.cabaxx.app/cabaxx/vuelo.mp3','2025-07-20','published',59000,3800,0),
  (@a1,'Ultima Cita','ultima-cita',228,NULL,'Cierre de temporada.','https://cdn.cabaxx.app/cabaxx/ultima.jpg','https://cdn.cabaxx.app/cabaxx/ultima.mp3','2025-08-01','draft',0,0,0);

-- ------------------------------------------------------------
-- ALBUMS (10)
-- ------------------------------------------------------------
INSERT INTO albums (artist_id, title, slug, description, cover_url, release_date, type, status) VALUES
  (@a1,'Nocturno','nocturno','Album debut.','https://cdn.cabaxx.app/cabaxx/al-nocturno.jpg','2025-01-30','album','published'),
  (@a1,'Ciudad de Fuego','ciudad-de-fuego','EP urbano.','https://cdn.cabaxx.app/cabaxx/al-fuego.jpg','2025-02-28','ep','published'),
  (@a1,'Mareas','mareas','Baladas.','https://cdn.cabaxx.app/cabaxx/al-mareas.jpg','2025-03-20','album','published'),
  (@a1,'Cabi Mix','cabi-mix','Set de reggaeton.','https://cdn.cabaxx.app/cabaxx/al-mix.jpg','2025-04-10','album','published'),
  (@a1,'Acustico','acustico','Versiones acusticas.','https://cdn.cabaxx.app/cabaxx/al-acustico.jpg','2025-05-25','album','published'),
  (@a1,'Voltio','voltio','EDM.','https://cdn.cabaxx.app/cabaxx/al-voltio.jpg','2025-06-05','ep','published'),
  (@a1,'Caribe','caribe','Tropical.','https://cdn.cabaxx.app/cabaxx/al-caribe.jpg','2025-06-22','album','published'),
  (@a1,'Duetos','duetos','Colaboraciones.','https://cdn.cabaxx.app/cabaxx/al-duetos.jpg','2025-07-05','album','published'),
  (@a1,'Horizonte','horizonte','Pop.','https://cdn.cabaxx.app/cabaxx/al-horizonte.jpg','2025-07-22','album','published'),
  (@a1,'Recopilatorio 2025','recopilatorio-2025','Best of.','https://cdn.cabaxx.app/cabaxx/al-reco.jpg','2025-08-05','album','draft');

-- ------------------------------------------------------------
-- ALBUM_SONGS (10) -> referencia por slug
-- ------------------------------------------------------------
INSERT INTO album_songs (album_id, song_id, track_number, disc_number) VALUES
  ((SELECT id FROM albums WHERE slug='nocturno'),(SELECT id FROM songs WHERE slug='nocturna'),1,1),
  ((SELECT id FROM albums WHERE slug='ciudad-de-fuego'),(SELECT id FROM songs WHERE slug='fuego-en-la-ciudad'),1,1),
  ((SELECT id FROM albums WHERE slug='mareas'),(SELECT id FROM songs WHERE slug='mar-de-estrellas'),1,1),
  ((SELECT id FROM albums WHERE slug='cabi-mix'),(SELECT id FROM songs WHERE slug='ritmo-cabi'),1,1),
  ((SELECT id FROM albums WHERE slug='acustico'),(SELECT id FROM songs WHERE slug='lejos-de-ti'),1,1),
  ((SELECT id FROM albums WHERE slug='voltio'),(SELECT id FROM songs WHERE slug='electrica'),1,1),
  ((SELECT id FROM albums WHERE slug='caribe'),(SELECT id FROM songs WHERE slug='calle-y-sol'),1,1),
  ((SELECT id FROM albums WHERE slug='duetos'),(SELECT id FROM songs WHERE slug='promesa'),1,1),
  ((SELECT id FROM albums WHERE slug='horizonte'),(SELECT id FROM songs WHERE slug='vuelo-libre'),1,1),
  ((SELECT id FROM albums WHERE slug='recopilatorio-2025'),(SELECT id FROM songs WHERE slug='ultima-cita'),1,1);

-- ------------------------------------------------------------
-- SONG_STREAMING_LINKS (10)
-- ------------------------------------------------------------
INSERT INTO song_streaming_links (song_id, platform, url) VALUES
  ((SELECT id FROM songs WHERE slug='nocturna'),'spotify','https://open.spotify.com/track/nocturna'),
  ((SELECT id FROM songs WHERE slug='nocturna'),'youtube','https://youtube.com/watch?v=nocturna'),
  ((SELECT id FROM songs WHERE slug='fuego-en-la-ciudad'),'spotify','https://open.spotify.com/track/fuego'),
  ((SELECT id FROM songs WHERE slug='ritmo-cabi'),'apple','https://music.apple.com/track/ritmo-cabi'),
  ((SELECT id FROM songs WHERE slug='ritmo-cabi'),'deezer','https://deezer.com/track/ritmo-cabi'),
  ((SELECT id FROM songs WHERE slug='mar-de-estrellas'),'spotify','https://open.spotify.com/track/mar'),
  ((SELECT id FROM songs WHERE slug='electrica'),'youtube','https://youtube.com/watch?v=electrica'),
  ((SELECT id FROM songs WHERE slug='promesa'),'spotify','https://open.spotify.com/track/promesa'),
  ((SELECT id FROM songs WHERE slug='vuelo-libre'),'apple','https://music.apple.com/track/vuelo'),
  ((SELECT id FROM songs WHERE slug='calle-y-sol'),'spotify','https://open.spotify.com/track/calle');

-- ------------------------------------------------------------
-- SONG_TAGS (10)
-- ------------------------------------------------------------
INSERT INTO song_tags (song_id, tag) VALUES
  ((SELECT id FROM songs WHERE slug='nocturna'),'urbano'),
  ((SELECT id FROM songs WHERE slug='fuego-en-la-ciudad'),'reggaeton'),
  ((SELECT id FROM songs WHERE slug='mar-de-estrellas'),'balada'),
  ((SELECT id FROM songs WHERE slug='ritmo-cabi'),'perreo'),
  ((SELECT id FROM songs WHERE slug='lejos-de-ti'),'despecho'),
  ((SELECT id FROM songs WHERE slug='electrica'),'edm'),
  ((SELECT id FROM songs WHERE slug='calle-y-sol'),'tropical'),
  ((SELECT id FROM songs WHERE slug='promesa'),'feat'),
  ((SELECT id FROM songs WHERE slug='vuelo-libre'),'pop'),
  ((SELECT id FROM songs WHERE slug='ultima-cita'),'2025');

-- ------------------------------------------------------------
-- VIDEOS (10)
-- ------------------------------------------------------------
INSERT INTO videos (artist_id, title, slug, description, thumbnail_url, video_url, youtube_id, duration_seconds, views_count, status, published_at) VALUES
  (@a1,'Nocturna (Official Video)','nocturna-video','Video oficial.','https://cdn.cabaxx.app/cabaxx/v-nocturna.jpg','https://cdn.cabaxx.app/cabaxx/v-nocturna.mp4','yt_nocturna',193,540000,'published',NOW()),
  (@a1,'Fuego en la Ciudad (Lyric)','fuego-lyric','Lyric video.','https://cdn.cabaxx.app/cabaxx/v-fuego.jpg','https://cdn.cabaxx.app/cabaxx/v-fuego.mp4','yt_fuego',206,210000,'published',NOW()),
  (@a1,'Behind the Scenes','bts-2025','Detras de camaras.','https://cdn.cabaxx.app/cabaxx/v-bts.jpg','https://cdn.cabaxx.app/cabaxx/v-bts.mp4','yt_bts',312,88000,'published',NOW()),
  (@a1,'Ritmo Cabi (Live)','ritmo-live','Presentacion en vivo.','https://cdn.cabaxx.app/cabaxx/v-live.jpg','https://cdn.cabaxx.app/cabaxx/v-live.mp4','yt_live',195,330000,'published',NOW()),
  (@a1,'Acustico Sesion','acustico-sesion','Sesion acustica.','https://cdn.cabaxx.app/cabaxx/v-acu.jpg','https://cdn.cabaxx.app/cabaxx/v-acu.mp4','yt_acu',240,67000,'published',NOW()),
  (@a1,'Entrevista EXA','entrevista-exa','Entrevista.','https://cdn.cabaxx.app/cabaxx/v-ent.jpg','https://cdn.cabaxx.app/cabaxx/v-ent.mp4','yt_ent',521,41000,'published',NOW()),
  (@a1,'Electrica (Visualizer)','electrica-visual','Visualizer.','https://cdn.cabaxx.app/cabaxx/v-elec.jpg','https://cdn.cabaxx.app/cabaxx/v-elec.mp4','yt_elec',200,95000,'published',NOW()),
  (@a1,'Calle y Sol (Dance)','calle-dance','Coreografia.','https://cdn.cabaxx.app/cabaxx/v-calle.jpg','https://cdn.cabaxx.app/cabaxx/v-calle.mp4','yt_calle',212,78000,'published',NOW()),
  (@a1,'Promesa ft. Invitado','promesa-video','Colaboracion.','https://cdn.cabaxx.app/cabaxx/v-prom.jpg','https://cdn.cabaxx.app/cabaxx/v-prom.mp4','yt_prom',205,150000,'published',NOW()),
  (@a1,'Ultima Cita (Teaser)','ultima-teaser','Adelanto.','https://cdn.cabaxx.app/cabaxx/v-ult.jpg','https://cdn.cabaxx.app/cabaxx/v-ult.mp4','yt_ult',60,12000,'draft',NULL);

-- ------------------------------------------------------------
-- GALLERY_ITEMS (10)
-- ------------------------------------------------------------
INSERT INTO gallery_items (artist_id, title, description, file_url, file_type, category, sort_order, status) VALUES
  (@a1,'Portada Nocturno','Foto de portada.','https://cdn.cabaxx.app/cabaxx/g1.jpg','image','cover',1,'active'),
  (@a1,'Concierto Bogota','En vivo.','https://cdn.cabaxx.app/cabaxx/g2.jpg','image','tour',2,'active'),
  (@a1,'Estudio','Grabando.','https://cdn.cabaxx.app/cabaxx/g3.jpg','image','studio',3,'active'),
  (@a1,'Fan Meet','Con fans.','https://cdn.cabaxx.app/cabaxx/g4.jpg','image','fans',4,'active'),
  (@a1,'Backstage','Backstage.','https://cdn.cabaxx.app/cabaxx/g5.jpg','image','tour',5,'active'),
  (@a1,'Video Saludo','Saludo a fans.','https://cdn.cabaxx.app/cabaxx/g6.mp4','video','fans',6,'active'),
  (@a1,'Portada Fuego','Foto promo.','https://cdn.cabaxx.app/cabaxx/g7.jpg','image','cover',7,'active'),
  (@a1,'Premios','En premios.','https://cdn.cabaxx.app/cabaxx/g8.jpg','image','press',8,'active'),
  (@a1,'Ensayo','Ensayo general.','https://cdn.cabaxx.app/cabaxx/g9.jpg','image','studio',9,'inactive'),
  (@a1,'Calle y Sol','Gira.','https://cdn.cabaxx.app/cabaxx/g10.jpg','image','tour',10,'active');

-- ------------------------------------------------------------
-- EVENTS (10)
-- ------------------------------------------------------------
INSERT INTO events (artist_id, title, slug, description, venue_name, venue_address, city, country, lat, lng, start_datetime, end_datetime, timezone, banner_url, status, is_free, capacity) VALUES
  (@a1,'Concierto Bogota','concierto-bogota','Gran show.','Movistar Arena','Cra 30 #30-50','Bogota','CO',4.658, -74.093,'2025-09-15 20:00:00','2025-09-15 23:00:00','America/Bogota','https://cdn.cabaxx.app/cabaxx/e-bog.jpg','published',0,12000),
  (@a1,'Festival Medellin','festival-medellin','Festival.','Estadio Atanasio','Cra 74 #48010','Medellin','CO',6.255,-75.590,'2025-10-02 19:00:00','2025-10-02 23:00:00','America/Bogota','https://cdn.cabaxx.app/cabaxx/e-med.jpg','published',0,25000),
  (@a1,'Show Cali','show-cali','Show.','Centro de Eventos','Cl 5 #33-88','Cali','CO',3.451,-76.532,'2025-10-20 20:00:00','2025-10-20 23:00:00','America/Bogota','https://cdn.cabaxx.app/cabaxx/e-cal.jpg','published',0,8000),
  (@a1,'Acustico Barranquilla','acustico-barranquilla','Show intimo.','Teatro Amira','Calle 72','Barranquilla','CO',10.963,-74.796,'2025-11-05 20:00:00','2025-11-05 22:30:00','America/Bogota','https://cdn.cabaxx.app/cabaxx/e-bar.jpg','published',0,1500),
  (@a1,'Meet & Greet','meet-greet','Encuentro.','Hotel Tryp','Cra 15 #124','Bogota','CO',4.690,-74.056,'2025-09-14 17:00:00','2025-09-14 19:00:00','America/Bogota','https://cdn.cabaxx.app/cabaxx/e-mng.jpg','published',1,100),
  (@a1,'Streaming Live','streaming-live','Show online.','Online','Virtual','Bogota','CO',4.658,-74.093,'2025-12-01 20:00:00','2025-12-01 22:00:00','America/Bogota','https://cdn.cabaxx.app/cabaxx/e-str.jpg','published',1,0),
  (@a1,'Concierto Mexico','concierto-mexico','Gira internacional.','Auditorio Nacional','Reforma 50','CDMX','MX',19.426,-99.185,'2026-01-18 21:00:00','2026-01-18 23:30:00','America/Mexico_City','https://cdn.cabaxx.app/cabaxx/e-mex.jpg','draft',0,10000),
  (@a1,'Show Lima','show-lima','Gira Peru.','Jockey Club','Av. El Polo','Lima','PE',-12.092,-76.971,'2026-02-10 20:00:00','2026-02-10 23:00:00','America/Lima','https://cdn.cabaxx.app/cabaxx/e-lim.jpg','draft',0,9000),
  (@a1,'Festival Zaragoza','festival-zaragoza','Espana.','Auditorio Zaragoza','Pza. Europa','Zaragoza','ES',41.648,-0.889,'2026-03-05 21:00:00','2026-03-05 23:30:00','Europe/Madrid','https://cdn.cabaxx.app/cabaxx/e-zgz.jpg','draft',0,7000),
  (@a1,'Ultima Cita Tour','ultima-cita-tour','Cierre de gira.','Movistar Arena','Cra 30','Bogota','CO',4.658,-74.093,'2026-04-12 20:00:00','2026-04-12 23:00:00','America/Bogota','https://cdn.cabaxx.app/cabaxx/e-fin.jpg','draft',0,12000);

-- ------------------------------------------------------------
-- TICKETS (10) -> referencia evento por slug (nombres unicos)
-- ------------------------------------------------------------
INSERT INTO tickets (event_id, artist_id, name, description, price, currency, quantity_total, quantity_sold, sale_start_at, sale_end_at, status) VALUES
  ((SELECT id FROM events WHERE slug='concierto-bogota'),@a1,'General Bogota','Zona general.','120000.00','COP',8000,6200,'2025-07-01 10:00:00','2025-09-10 23:59:00','active'),
  ((SELECT id FROM events WHERE slug='concierto-bogota'),@a1,'VIP Bogota','Acceso VIP.','350000.00','COP',2000,1900,'2025-07-01 10:00:00','2025-09-10 23:59:00','sold_out'),
  ((SELECT id FROM events WHERE slug='festival-medellin'),@a1,'General Medellin','Zona general.','150000.00','COP',18000,9000,'2025-07-10 10:00:00','2025-09-28 23:59:00','active'),
  ((SELECT id FROM events WHERE slug='festival-medellin'),@a1,'Palco Medellin','Palco.','600000.00','COP',200,120,'2025-07-10 10:00:00','2025-09-28 23:59:00','active'),
  ((SELECT id FROM events WHERE slug='show-cali'),@a1,'General Cali','Zona general.','100000.00','COP',6000,3000,'2025-08-01 10:00:00','2025-10-15 23:59:00','active'),
  ((SELECT id FROM events WHERE slug='acustico-barranquilla'),@a1,'General Barranquilla','Intimo.','180000.00','COP',1200,800,'2025-08-15 10:00:00','2025-10-30 23:59:00','active'),
  ((SELECT id FROM events WHERE slug='meet-greet'),@a1,'Meet Greet Bogota','Encuentro.','0.00','COP',100,90,'2025-07-20 10:00:00','2025-09-10 23:59:00','active'),
  ((SELECT id FROM events WHERE slug='streaming-live'),@a1,'Pase Streaming','Online.','25000.00','COP',0,5000,'2025-08-01 10:00:00','2025-11-30 23:59:00','active'),
  ((SELECT id FROM events WHERE slug='concierto-mexico'),@a1,'General Mexico','Zona general.','1500.00','MXN',8000,0,'2025-09-01 10:00:00','2026-01-10 23:59:00','inactive'),
  ((SELECT id FROM events WHERE slug='ultima-cita-tour'),@a1,'General Final','Cierre.','130000.00','COP',9000,0,'2025-10-01 10:00:00','2026-04-05 23:59:00','inactive');

-- ------------------------------------------------------------
-- TICKET_PURCHASES (10) -> referencia ticket por nombre unico
-- ------------------------------------------------------------
INSERT INTO ticket_purchases (user_id, ticket_id, quantity, total_price, status, qr_code, used_at) VALUES
  (@u2,(SELECT id FROM tickets WHERE name='General Bogota'),2,240000.00,'paid','QR-AA001',NOW()),
  (@u3,(SELECT id FROM tickets WHERE name='VIP Bogota'),1,350000.00,'paid','QR-AA002',NOW()),
  (@u5,(SELECT id FROM tickets WHERE name='General Medellin'),4,600000.00,'paid','QR-AA003',NULL),
  (@u6,(SELECT id FROM tickets WHERE name='Palco Medellin'),1,600000.00,'paid','QR-AA004',NULL),
  (@u7,(SELECT id FROM tickets WHERE name='General Cali'),2,200000.00,'pending','QR-AA005',NULL),
  (@u9,(SELECT id FROM tickets WHERE name='General Barranquilla'),1,180000.00,'paid','QR-AA006',NULL),
  (@u10,(SELECT id FROM tickets WHERE name='Meet Greet Bogota'),1,0.00,'paid','QR-AA007',NOW()),
  (@u11,(SELECT id FROM tickets WHERE name='Pase Streaming'),3,75000.00,'paid','QR-AA008',NULL),
  (@u2,(SELECT id FROM tickets WHERE name='General Medellin'),2,300000.00,'cancelled','QR-AA009',NULL),
  (@u4,(SELECT id FROM tickets WHERE name='General Bogota'),1,120000.00,'paid','QR-AA010',NOW());

-- ------------------------------------------------------------
-- PRODUCT_CATEGORIES (10)
-- ------------------------------------------------------------
INSERT INTO product_categories (artist_id, name, slug, description, image_url, parent_id, sort_order) VALUES
  (@a1,'Ropa','ropa','Merch de ropa.',NULL,NULL,1),
  (@a1,'Accesorios','accesorios','Accesorios.',NULL,NULL,4),
  (@a1,'Vinilos','vinilos','Vinilos.',NULL,NULL,6),
  (@a1,'Digital','digital','Productos digitales.',NULL,NULL,7),
  (@a1,'Posters','posters','Posters.',NULL,NULL,8);

SET @cat_ropa = (SELECT id FROM product_categories WHERE artist_id = @a1 AND slug = 'ropa');
SET @cat_accesorios = (SELECT id FROM product_categories WHERE artist_id = @a1 AND slug = 'accesorios');

INSERT INTO product_categories (artist_id, name, slug, description, image_url, parent_id, sort_order) VALUES
  (@a1,'Camisetas','camisetas','Camisetas oficiales.',NULL,@cat_ropa,2),
  (@a1,'Sudaderas','sudaderas','Sudaderas.',NULL,@cat_ropa,3),
  (@a1,'Gorras','gorras','Gorras.',NULL,@cat_accesorios,5),
  (@a1,'Llaveros','llaveros','Llaveros.',NULL,@cat_accesorios,9),
  (@a1,'Pack Fans','pack-fans','Packs exclusivos.',NULL,NULL,10);

-- ------------------------------------------------------------
-- PRODUCTS (10)
-- ------------------------------------------------------------
INSERT INTO products (artist_id, category_id, name, slug, description, price, compare_at_price, currency, sku, stock_quantity, type, cover_url, status, weight_grams) VALUES
  (@a1,(SELECT id FROM product_categories WHERE slug='camisetas'),'Camiseta Nocturna','camiseta-nocturna','Talla unisex.','75000.00','90000.00','COP','CAM-NOC-001',300,'physical','https://cdn.cabaxx.app/cabaxx/p1.jpg','active',200),
  (@a1,(SELECT id FROM product_categories WHERE slug='sudaderas'),'Sudadera Cabi','sudadera-cabi','Sudadera bordada.','150000.00',NULL,'COP','SUD-CAB-002',150,'physical','https://cdn.cabaxx.app/cabaxx/p2.jpg','active',500),
  (@a1,(SELECT id FROM product_categories WHERE slug='gorras'),'Gorra Logo','gorra-logo','Gorra snapback.','60000.00','70000.00','COP','GOR-LOG-003',200,'physical','https://cdn.cabaxx.app/cabaxx/p3.jpg','active',150),
  (@a1,(SELECT id FROM product_categories WHERE slug='vinilos'),'Vinilo Nocturno','vinilo-nocturno','Edicion limitada.','130000.00',NULL,'COP','VIN-NOC-004',80,'physical','https://cdn.cabaxx.app/cabaxx/p4.jpg','active',350),
  (@a1,(SELECT id FROM product_categories WHERE slug='digital'),'Album Digital','album-digital','Descarga MP3.','35000.00',NULL,'COP','DIG-ALB-005',9999,'digital','https://cdn.cabaxx.app/cabaxx/p5.jpg','active',0),
  (@a1,(SELECT id FROM product_categories WHERE slug='posters'),'Poster Gira','poster-gira','Poster A2.','40000.00',NULL,'COP','POS-GIR-006',120,'physical','https://cdn.cabaxx.app/cabaxx/p6.jpg','active',100),
  (@a1,(SELECT id FROM product_categories WHERE slug='llaveros'),'Llavero Logo','llavero-logo','Llavero metalico.','20000.00','25000.00','COP','LLA-LOG-007',500,'physical','https://cdn.cabaxx.app/cabaxx/p7.jpg','active',50),
  (@a1,(SELECT id FROM product_categories WHERE slug='pack-fans'),'Pack Meet & Greet','pack-meet','Incluye meet.','450000.00',NULL,'COP','PKM-MTG-008',30,'ticket','https://cdn.cabaxx.app/cabaxx/p8.jpg','active',0),
  (@a1,(SELECT id FROM product_categories WHERE slug='camisetas'),'Camiseta Fuego','camiseta-fuego','Edicion tour.','80000.00',NULL,'COP','CAM-FUE-009',220,'physical','https://cdn.cabaxx.app/cabaxx/p9.jpg','active',200),
  (@a1,(SELECT id FROM product_categories WHERE slug='digital'),'Ringtone Pack','ringtone-pack','Tonos.','15000.00',NULL,'COP','DIG-RNG-010',9999,'digital','https://cdn.cabaxx.app/cabaxx/p10.jpg','draft',0);

-- ------------------------------------------------------------
-- PRODUCT_IMAGES (10)
-- ------------------------------------------------------------
INSERT INTO product_images (product_id, url, alt_text, sort_order) VALUES
  ((SELECT id FROM products WHERE slug='camiseta-nocturna'),'https://cdn.cabaxx.app/cabaxx/p1a.jpg','Frente',1),
  ((SELECT id FROM products WHERE slug='camiseta-nocturna'),'https://cdn.cabaxx.app/cabaxx/p1b.jpg','Espalda',2),
  ((SELECT id FROM products WHERE slug='sudadera-cabi'),'https://cdn.cabaxx.app/cabaxx/p2a.jpg','Frente',1),
  ((SELECT id FROM products WHERE slug='gorra-logo'),'https://cdn.cabaxx.app/cabaxx/p3a.jpg','Lateral',1),
  ((SELECT id FROM products WHERE slug='vinilo-nocturno'),'https://cdn.cabaxx.app/cabaxx/p4a.jpg','Portada',1),
  ((SELECT id FROM products WHERE slug='album-digital'),'https://cdn.cabaxx.app/cabaxx/p5a.jpg','Caratula',1),
  ((SELECT id FROM products WHERE slug='poster-gira'),'https://cdn.cabaxx.app/cabaxx/p6a.jpg','Poster',1),
  ((SELECT id FROM products WHERE slug='pack-meet'),'https://cdn.cabaxx.app/cabaxx/p8a.jpg','Pack',1),
  ((SELECT id FROM products WHERE slug='camiseta-fuego'),'https://cdn.cabaxx.app/cabaxx/p9a.jpg','Frente',1),
  ((SELECT id FROM products WHERE slug='ringtone-pack'),'https://cdn.cabaxx.app/cabaxx/p10a.jpg','Icono',1);

-- ------------------------------------------------------------
-- PRODUCT_VARIANTS (10)
-- ------------------------------------------------------------
INSERT INTO product_variants (product_id, name, options_json, price, sku, stock_quantity) VALUES
  ((SELECT id FROM products WHERE slug='camiseta-nocturna'),'Talla S','{"size":"S","color":"Negro"}','75000.00','CAM-NOC-001-S',80),
  ((SELECT id FROM products WHERE slug='camiseta-nocturna'),'Talla M','{"size":"M","color":"Negro"}','75000.00','CAM-NOC-001-M',90),
  ((SELECT id FROM products WHERE slug='camiseta-nocturna'),'Talla L','{"size":"L","color":"Negro"}','75000.00','CAM-NOC-001-L',70),
  ((SELECT id FROM products WHERE slug='sudadera-cabi'),'Talla M','{"size":"M","color":"Gris"}','150000.00','SUD-CAB-002-M',50),
  ((SELECT id FROM products WHERE slug='sudadera-cabi'),'Talla L','{"size":"L","color":"Gris"}','150000.00','SUD-CAB-002-L',50),
  ((SELECT id FROM products WHERE slug='gorra-logo'),'Unica','{"size":"Unica","color":"Negro"}','60000.00','GOR-LOG-003-U',200),
  ((SELECT id FROM products WHERE slug='vinilo-nocturno'),'Edicion 1','{"version":"Limitada"}','130000.00','VIN-NOC-004-L',80),
  ((SELECT id FROM products WHERE slug='camiseta-fuego'),'Talla M','{"size":"M","color":"Rojo"}','80000.00','CAM-FUE-009-M',110),
  ((SELECT id FROM products WHERE slug='camiseta-fuego'),'Talla L','{"size":"L","color":"Rojo"}','80000.00','CAM-FUE-009-L',110),
  ((SELECT id FROM products WHERE slug='pack-meet'),'Pack VIP','{"tier":"VIP"}','450000.00','PKM-MTG-008-V',30);

-- ------------------------------------------------------------
-- COUPONS (10)
-- ------------------------------------------------------------
INSERT INTO coupons (artist_id, code, type, value, min_purchase, max_uses, uses_count, expires_at, status) VALUES
  (@a1,'BIENVENIDO10','percent',10.00,0.00,1000,320,DATE_ADD(NOW(),INTERVAL 60 DAY),'active'),
  (@a1,'CABI20','percent',20.00,80000.00,500,150,DATE_ADD(NOW(),INTERVAL 30 DAY),'active'),
  (@a1,'ENVIOFREE','fixed',15000.00,100000.00,200,40,DATE_ADD(NOW(),INTERVAL 45 DAY),'active'),
  (@a1,'FAN15','percent',15.00,50000.00,300,88,DATE_ADD(NOW(),INTERVAL 15 DAY),'active'),
  (@a1,'NOCTURNO5','fixed',5000.00,0.00,999,500,DATE_ADD(NOW(),INTERVAL 90 DAY),'active'),
  (@a1,'VERANO25','percent',25.00,120000.00,100,12,DATE_ADD(NOW(),INTERVAL 20 DAY),'active'),
  (@a1,'PACKVIP','fixed',50000.00,400000.00,50,3,DATE_ADD(NOW(),INTERVAL 10 DAY),'active'),
  (@a1,'BLACKFRIDAY','percent',30.00,0.00,2000,0,DATE_ADD(NOW(),INTERVAL 5 DAY),'active'),
  (@a1,'SUPERFAN','percent',12.00,30000.00,800,210,DATE_ADD(NOW(),INTERVAL 120 DAY),'inactive'),
  (@a1,'EXPIRADO','percent',50.00,0.00,100,100,DATE_ADD(NOW(),INTERVAL -10 DAY),'expired');

-- ------------------------------------------------------------
-- ORDERS (10) -> capturamos @o1..@o10
-- ------------------------------------------------------------
INSERT INTO orders (user_id, artist_id, status, subtotal, discount, shipping, tax, total, currency, coupon_id, notes)
VALUES (@u2,@a1,'paid',150000.00,15000.00,15000.00,0.00,150000.00,'COP',(SELECT id FROM coupons WHERE code='BIENVENIDO10'),'Entrega 2-3 dias');
SET @o1 = LAST_INSERT_ID();
INSERT INTO orders (user_id, artist_id, status, subtotal, discount, shipping, tax, total, currency, coupon_id, notes)
VALUES (@u3,@a1,'paid',300000.00,60000.00,0.00,0.00,240000.00,'COP',(SELECT id FROM coupons WHERE code='CABI20'),'Cliente VIP');
SET @o2 = LAST_INSERT_ID();
INSERT INTO orders (user_id, artist_id, status, subtotal, discount, shipping, tax, total, currency, coupon_id, notes)
VALUES (@u5,@a1,'processing',130000.00,0.00,15000.00,0.00,145000.00,'COP',NULL,'Empacando');
SET @o3 = LAST_INSERT_ID();
INSERT INTO orders (user_id, artist_id, status, subtotal, discount, shipping, tax, total, currency, coupon_id, notes)
VALUES (@u6,@a1,'shipped',75000.00,11250.00,15000.00,0.00,78750.00,'COP',(SELECT id FROM coupons WHERE code='FAN15'),'En camino');
SET @o4 = LAST_INSERT_ID();
INSERT INTO orders (user_id, artist_id, status, subtotal, discount, shipping, tax, total, currency, coupon_id, notes)
VALUES (@u7,@a1,'delivered',450000.00,0.00,0.00,0.00,450000.00,'COP',NULL,'Pack meet');
SET @o5 = LAST_INSERT_ID();
INSERT INTO orders (user_id, artist_id, status, subtotal, discount, shipping, tax, total, currency, coupon_id, notes)
VALUES (@u9,@a1,'paid',60000.00,9000.00,0.00,0.00,51000.00,'COP',(SELECT id FROM coupons WHERE code='BIENVENIDO10'),'Gorra');
SET @o6 = LAST_INSERT_ID();
INSERT INTO orders (user_id, artist_id, status, subtotal, discount, shipping, tax, total, currency, coupon_id, notes)
VALUES (@u10,@a1,'pending',35000.00,0.00,0.00,0.00,35000.00,'COP',NULL,'Digital');
SET @o7 = LAST_INSERT_ID();
INSERT INTO orders (user_id, artist_id, status, subtotal, discount, shipping, tax, total, currency, coupon_id, notes)
VALUES (@u11,@a1,'cancelled',150000.00,0.00,15000.00,0.00,165000.00,'COP',NULL,'Cancelado por cliente');
SET @o8 = LAST_INSERT_ID();
INSERT INTO orders (user_id, artist_id, status, subtotal, discount, shipping, tax, total, currency, coupon_id, notes)
VALUES (@u2,@a1,'paid',200000.00,40000.00,0.00,0.00,160000.00,'COP',(SELECT id FROM coupons WHERE code='CABI20'),'Dos camisetas');
SET @o9 = LAST_INSERT_ID();
INSERT INTO orders (user_id, artist_id, status, subtotal, discount, shipping, tax, total, currency, coupon_id, notes)
VALUES (@u4,@a1,'refunded',80000.00,0.00,15000.00,0.00,95000.00,'COP',NULL,'Reembolso solicitado');
SET @o10 = LAST_INSERT_ID();

-- ------------------------------------------------------------
-- ORDER_ITEMS (10) -> referencia @o y producto/variante por sku
-- ------------------------------------------------------------
INSERT INTO order_items (order_id, product_id, variant_id, quantity, unit_price, total_price, snapshot_json) VALUES
  (@o1,(SELECT id FROM products WHERE slug='camiseta-nocturna'),(SELECT id FROM product_variants WHERE sku='CAM-NOC-001-M'),2,75000.00,150000.00,'{"name":"Camiseta Nocturna"}'),
  (@o2,(SELECT id FROM products WHERE slug='sudadera-cabi'),(SELECT id FROM product_variants WHERE sku='SUD-CAB-002-M'),2,150000.00,300000.00,'{"name":"Sudadera Cabi"}'),
  (@o3,(SELECT id FROM products WHERE slug='vinilo-nocturno'),(SELECT id FROM product_variants WHERE sku='VIN-NOC-004-L'),1,130000.00,130000.00,'{"name":"Vinilo Nocturno"}'),
  (@o4,(SELECT id FROM products WHERE slug='gorra-logo'),(SELECT id FROM product_variants WHERE sku='GOR-LOG-003-U'),1,75000.00,75000.00,'{"name":"Gorra Logo"}'),
  (@o5,(SELECT id FROM products WHERE slug='pack-meet'),(SELECT id FROM product_variants WHERE sku='PKM-MTG-008-V'),1,450000.00,450000.00,'{"name":"Pack Meet & Greet"}'),
  (@o6,(SELECT id FROM products WHERE slug='gorra-logo'),(SELECT id FROM product_variants WHERE sku='GOR-LOG-003-U'),1,60000.00,60000.00,'{"name":"Gorra Logo"}'),
  (@o7,(SELECT id FROM products WHERE slug='album-digital'),NULL,1,35000.00,35000.00,'{"name":"Album Digital"}'),
  (@o8,(SELECT id FROM products WHERE slug='camiseta-fuego'),(SELECT id FROM product_variants WHERE sku='CAM-FUE-009-M'),1,80000.00,80000.00,'{"name":"Camiseta Fuego"}'),
  (@o9,(SELECT id FROM products WHERE slug='camiseta-nocturna'),(SELECT id FROM product_variants WHERE sku='CAM-NOC-001-L'),1,75000.00,75000.00,'{"name":"Camiseta Nocturna"}'),
  (@o10,(SELECT id FROM products WHERE slug='camiseta-fuego'),(SELECT id FROM product_variants WHERE sku='CAM-FUE-009-L'),1,80000.00,80000.00,'{"name":"Camiseta Fuego"}');

-- ------------------------------------------------------------
-- ORDER_SHIPPING (10)
-- ------------------------------------------------------------
INSERT INTO order_shipping (order_id, carrier, tracking_number, status, shipped_at, delivered_at, address_json) VALUES
  (@o1,'Servientrega','TRK-1001','delivered','2025-07-05 10:00:00','2025-07-07 14:00:00','{"city":"Bogota","zip":"110111"}'),
  (@o2,'Coordinadora','TRK-1002','delivered','2025-07-06 10:00:00','2025-07-08 14:00:00','{"city":"Medellin","zip":"050001"}'),
  (@o3,'Servientrega','TRK-1003','in_transit','2025-07-10 10:00:00',NULL,'{"city":"Cali","zip":"760001"}'),
  (@o4,'Coordinadora','TRK-1004','delivered','2025-07-08 10:00:00','2025-07-09 14:00:00','{"city":"Bogota","zip":"110111"}'),
  (@o5,'DHL','TRK-1005','delivered','2025-07-07 10:00:00','2025-07-08 14:00:00','{"city":"Bogota","zip":"110111"}'),
  (@o6,'Servientrega','TRK-1006','delivered','2025-07-09 10:00:00','2025-07-11 14:00:00','{"city":"Bogota","zip":"110111"}'),
  (@o7,NULL,NULL,'pending',NULL,NULL,'{"email":"fan9@a1.com"}'),
  (@o8,'Servientrega','TRK-1008','pending',NULL,NULL,'{"city":"Bogota","zip":"110111"}'),
  (@o9,'Coordinadora','TRK-1009','delivered','2025-07-12 10:00:00','2025-07-14 14:00:00','{"city":"Bogota","zip":"110111"}'),
  (@o10,'Servientrega','TRK-1010','returned','2025-07-11 10:00:00','2025-07-15 14:00:00','{"city":"Bogota","zip":"110111"}');

-- ------------------------------------------------------------
-- PAYMENTS (10)
-- ------------------------------------------------------------
INSERT INTO payments (order_id, user_id, artist_id, provider, provider_tx_id, amount, currency, status, response_json, paid_at) VALUES
  (@o1,@u2,@a1,'stripe','pi_1A001',150000.00,'COP','succeeded','{"status":"ok"}',NOW()),
  (@o2,@u3,@a1,'stripe','pi_1A002',240000.00,'COP','succeeded','{"status":"ok"}',NOW()),
  (@o3,@u5,@a1,'paypal','pp_1A003',145000.00,'COP','pending','{"status":"pending"}',NULL),
  (@o4,@u6,@a1,'stripe','pi_1A004',78750.00,'COP','succeeded','{"status":"ok"}',NOW()),
  (@o5,@u7,@a1,'wompi','wo_1A005',450000.00,'COP','succeeded','{"status":"ok"}',NOW()),
  (@o6,@u9,@a1,'stripe','pi_1A006',51000.00,'COP','succeeded','{"status":"ok"}',NOW()),
  (@o7,@u10,@a1,'stripe','pi_1A007',35000.00,'COP','succeeded','{"status":"ok"}',NOW()),
  (@o8,@u11,@a1,'stripe','pi_1A008',165000.00,'COP','refunded','{"status":"refunded"}',NOW()),
  (@o9,@u2,@a1,'stripe','pi_1A009',160000.00,'COP','succeeded','{"status":"ok"}',NOW()),
  (@o10,@u4,@a1,'paypal','pp_1A010',95000.00,'COP','refunded','{"status":"refunded"}',NOW());

-- ------------------------------------------------------------
-- POSTS (10)
-- ------------------------------------------------------------
INSERT INTO posts (artist_id, user_id, type, title, slug, content, excerpt, cover_url, status, published_at, views_count) VALUES
  (@a1,@u6,'news','Nuevo album Nocturno','nuevo-album-nocturno','Ya disponible nuestro album debut.','Album debut disponible.','https://cdn.cabaxx.app/cabaxx/post1.jpg','published',NOW(),12000),
  (@a1,@u6,'blog','Detras de Fuego en la Ciudad','detras-fuego','Como creamos el tema.','Proceso creativo.','https://cdn.cabaxx.app/cabaxx/post2.jpg','published',NOW(),8400),
  (@a1,@u6,'update','Gira 2025 confirmada','gira-2025','Fechas de la gira.','Fechas gira.','https://cdn.cabaxx.app/cabaxx/post3.jpg','published',NOW(),21000),
  (@a1,@u6,'news','Colaboracion con invitado','colaboracion-invitado','Nuevo dueto.','Nuevo dueto.','https://cdn.cabaxx.app/cabaxx/post4.jpg','published',NOW(),15600),
  (@a1,@u6,'blog','Mi estudio en Bogota','mi-estudio','Tour por el estudio.','Sobre el estudio.','https://cdn.cabaxx.app/cabaxx/post5.jpg','published',NOW(),6200),
  (@a1,@u6,'update','Merch nueva coleccion','merch-coleccion','Ropa oficial.','Nueva ropa.','https://cdn.cabaxx.app/cabaxx/post6.jpg','published',NOW(),9800),
  (@a1,@u6,'news','Premios nominacion','premios-nominacion','Nominados.','Nominados.','https://cdn.cabaxx.app/cabaxx/post7.jpg','published',NOW(),7300),
  (@a1,@u6,'blog','Acustico sesion','acustico-sesion-post','Sesion especial.','Sesion acustica.','https://cdn.cabaxx.app/cabaxx/post8.jpg','published',NOW(),5100),
  (@a1,@u6,'update','Streaming live','streaming-live-post','Show online.','Show online.','https://cdn.cabaxx.app/cabaxx/post9.jpg','published',NOW(),6400),
  (@a1,@u6,'news','Ultima Cita','ultima-cita-post','Cierre de temporada.','Cierre.','https://cdn.cabaxx.app/cabaxx/post10.jpg','draft',NULL,0);

-- ------------------------------------------------------------
-- POST_TAGS (10)
-- ------------------------------------------------------------
INSERT INTO post_tags (post_id, tag) VALUES
  ((SELECT id FROM posts WHERE slug='nuevo-album-nocturno'),'album'),
  ((SELECT id FROM posts WHERE slug='detras-fuego'),'creativo'),
  ((SELECT id FROM posts WHERE slug='gira-2025'),'tour'),
  ((SELECT id FROM posts WHERE slug='colaboracion-invitado'),'feat'),
  ((SELECT id FROM posts WHERE slug='mi-estudio'),'estudio'),
  ((SELECT id FROM posts WHERE slug='merch-coleccion'),'merch'),
  ((SELECT id FROM posts WHERE slug='premios-nominacion'),'premios'),
  ((SELECT id FROM posts WHERE slug='acustico-sesion-post'),'acustico'),
  ((SELECT id FROM posts WHERE slug='streaming-live-post'),'live'),
  ((SELECT id FROM posts WHERE slug='ultima-cita-post'),'2025');

-- ------------------------------------------------------------
-- COMMENTS (10) -> referencia cancion/post/evento por slug
-- ------------------------------------------------------------
INSERT INTO comments (user_id, artist_id, reference_id, reference_type, content, status, parent_id) VALUES
  (@u2,@a1,(SELECT id FROM songs WHERE slug='nocturna'),'song','Tema increible!','approved',NULL),
  (@u3,@a1,(SELECT id FROM songs WHERE slug='ritmo-cabi'),'song','El ritmo es viral.','approved',NULL),
  (@u5,@a1,(SELECT id FROM posts WHERE slug='gira-2025'),'post','Voy al de Bogota!','approved',NULL);

SET @comment_parent = (SELECT id FROM comments WHERE content = 'Voy al de Bogota!' AND artist_id = @a1);

INSERT INTO comments (user_id, artist_id, reference_id, reference_type, content, status, parent_id) VALUES
  (@u6,@a1,(SELECT id FROM posts WHERE slug='gira-2025'),'post','Te esperamos.','approved',@comment_parent),
  (@u7,@a1,(SELECT id FROM events WHERE slug='concierto-bogota'),'event','Compre VIP.','approved',NULL),
  (@u9,@a1,(SELECT id FROM songs WHERE slug='mar-de-estrellas'),'song','Me hace llorar.','approved',NULL),
  (@u10,@a1,(SELECT id FROM posts WHERE slug='merch-coleccion'),'post','La sudadera es buenisima.','approved',NULL),
  (@u11,@a1,(SELECT id FROM videos WHERE slug='ritmo-live'),'video','El live fue epico.','pending',NULL),
  (@u4,@a1,(SELECT id FROM songs WHERE slug='electrica'),'song','Ponganla en la gira.','spam',NULL),
  (@u2,@a1,(SELECT id FROM events WHERE slug='meet-greet'),'event','Gracias por el meet.','approved',NULL);

-- ------------------------------------------------------------
-- LIKES (10)
-- ------------------------------------------------------------
INSERT INTO likes (user_id, artist_id, reference_id, reference_type) VALUES
  (@u2,@a1,(SELECT id FROM songs WHERE slug='nocturna'),'song'),
  (@u3,@a1,(SELECT id FROM songs WHERE slug='ritmo-cabi'),'song'),
  (@u5,@a1,(SELECT id FROM posts WHERE slug='gira-2025'),'post'),
  (@u6,@a1,(SELECT id FROM videos WHERE slug='nocturna-video'),'video'),
  (@u7,@a1,(SELECT id FROM songs WHERE slug='mar-de-estrellas'),'song'),
  (@u9,@a1,(SELECT id FROM albums WHERE slug='nocturno'),'album'),
  (@u10,@a1,(SELECT id FROM events WHERE slug='concierto-bogota'),'event'),
  (@u11,@a1,(SELECT id FROM songs WHERE slug='electrica'),'song'),
  (@u2,@a1,(SELECT id FROM posts WHERE slug='merch-coleccion'),'post'),
  (@u4,@a1,(SELECT id FROM videos WHERE slug='promesa-video'),'video');

-- ------------------------------------------------------------
-- FOLLOWS (10)
-- ------------------------------------------------------------
INSERT INTO follows (user_id, artist_id) VALUES
  (@u2,@a1),
  (@u3,@a1),
  (@u4,@a1),
  (@u5,@a1),
  (@u7,@a1),
  (@u9,@a1),
  (@u10,@a1),
  (@u11,@a1),
  (@u2,@a2),
  (@u3,@a3);

-- ------------------------------------------------------------
-- NEWSLETTER_SUBSCRIBERS (10)
-- ------------------------------------------------------------
INSERT INTO newsletter_subscribers (artist_id, email, name, status, subscribed_at, unsubscribed_at, source) VALUES
  (@a1,'sub1@cabaxx.com','Suscriptor Uno','subscribed',DATE_ADD(NOW(),INTERVAL -40 DAY),NULL,'website'),
  (@a1,'sub2@cabaxx.com','Suscriptor Dos','subscribed',DATE_ADD(NOW(),INTERVAL -35 DAY),NULL,'checkout'),
  (@a1,'sub3@cabaxx.com','Suscriptor Tres','subscribed',DATE_ADD(NOW(),INTERVAL -30 DAY),NULL,'instagram'),
  (@a1,'sub4@cabaxx.com','Suscriptor Cuatro','unsubscribed',DATE_ADD(NOW(),INTERVAL -28 DAY),NOW(),'website'),
  (@a1,'sub5@cabaxx.com','Suscriptor Cinco','subscribed',DATE_ADD(NOW(),INTERVAL -20 DAY),NULL,'youtube'),
  (@a1,'sub6@cabaxx.com','Suscriptor Seis','bounced',DATE_ADD(NOW(),INTERVAL -18 DAY),NULL,'website'),
  (@a1,'sub7@cabaxx.com','Suscriptor Siete','subscribed',DATE_ADD(NOW(),INTERVAL -15 DAY),NULL,'event'),
  (@a1,'sub8@cabaxx.com','Suscriptor Ocho','subscribed',DATE_ADD(NOW(),INTERVAL -10 DAY),NULL,'website'),
  (@a1,'sub9@cabaxx.com','Suscriptor Nueve','subscribed',DATE_ADD(NOW(),INTERVAL -5 DAY),NULL,'tiktok'),
  (@a1,'sub10@cabaxx.com','Suscriptor Diez','subscribed',DATE_ADD(NOW(),INTERVAL -2 DAY),NULL,'website');

-- ------------------------------------------------------------
-- NEWSLETTER_CAMPAIGNS (10)
-- ------------------------------------------------------------
INSERT INTO newsletter_campaigns (artist_id, subject, content_html, sent_at, total_sent, total_opened, total_clicked) VALUES
  (@a1,'Lanzamiento Nocturno','<h1>Nocturno ya aqui</h1>',DATE_ADD(NOW(),INTERVAL -39 DAY),5000,2200,310),
  (@a1,'Gira 2025','<h1>Fechas gira</h1>',DATE_ADD(NOW(),INTERVAL -29 DAY),5200,2400,520),
  (@a1,'Nueva Merch','<h1>Ropa oficial</h1>',DATE_ADD(NOW(),INTERVAL -20 DAY),4800,1900,410),
  (@a1,'Fuego en la Ciudad','<h1>Escucha Fuego</h1>',DATE_ADD(NOW(),INTERVAL -15 DAY),4900,2100,380),
  (@a1,'Colaboracion','<h1>Nuevo dueto</h1>',DATE_ADD(NOW(),INTERVAL -10 DAY),5000,2300,460),
  (@a1,'Black Friday','<h1>30% descuento</h1>',DATE_ADD(NOW(),INTERVAL -5 DAY),5300,2600,640),
  (@a1,'Show Cali','<h1>Boletas Cali</h1>',DATE_ADD(NOW(),INTERVAL -3 DAY),4700,1800,300),
  (@a1,'Acustico Sesion','<h1>Sesion acustica</h1>',DATE_ADD(NOW(),INTERVAL -2 DAY),4600,1700,280),
  (@a1,'Streaming Live','<h1>Show online</h1>',DATE_ADD(NOW(),INTERVAL -1 DAY),4500,1600,250),
  (@a1,'Ultima Cita','<h1>Cierre temporada</h1>',NULL,0,0,0);

-- ------------------------------------------------------------
-- NOTIFICATIONS (10)
-- ------------------------------------------------------------
INSERT INTO notifications (user_id, artist_id, type, title, body, data_json, read_at, sent_at) VALUES
  (@u2,@a1,'order','Pedido enviado','Tu pedido salio.','{"order_id":1}','2025-07-07 14:00:00',NOW()),
  (@u3,@a1,'order','Pedido entregado','Recibiste tu pedido.','{"order_id":2}',NULL,NOW()),
  (@u5,@a1,'event','Recordatorio concierto','Falta 1 mes.','{"event_id":1}',NULL,NOW()),
  (@u6,@a1,'role','Eres admin','Tienes acceso.','{"role":"artist_admin"}',NOW(),NOW()),
  (@u7,@a1,'comment','Comentario aprobado','Tu comentario fue aprobado.','{"comment_id":1}',NULL,NOW()),
  (@u9,@a1,'order','Pedido en camino','En transito.','{"order_id":6}',NULL,NOW()),
  (@u10,@a1,'newsletter','Nueva campana','Revisa nuestro newsletter.','{}',NULL,NOW()),
  (@u11,@a1,'order','Reembolso','Reembolso procesado.','{"order_id":8}',NOW(),NOW()),
  (@u2,@a1,'event','Meet & Greet','Confirmado.','{"event_id":5}',NULL,NOW()),
  (@u4,@a1,'system','Bienvenido','Gracias por suscribirte.','{}',NULL,NOW());

-- ------------------------------------------------------------
-- AUDIT_LOGS (10)
-- ------------------------------------------------------------
INSERT INTO audit_logs (user_id, artist_id, action, entity_type, entity_id, old_values_json, new_values_json, ip_address, user_agent) VALUES
  (@u6,@a1,'create','song',(SELECT id FROM songs WHERE slug='nocturna'),NULL,'{"status":"published"}','190.1.1.13','Mozilla/5.0 Win'),
  (@u6,@a1,'update','song',(SELECT id FROM songs WHERE slug='fuego-en-la-ciudad'),'{"plays":0}','{"plays":96000}',NULL,NULL),
  (@u6,@a1,'create','album',(SELECT id FROM albums WHERE slug='nocturno'),NULL,'{"status":"published"}',NULL,NULL),
  (@u6,@a1,'create','event',(SELECT id FROM events WHERE slug='concierto-bogota'),NULL,'{"status":"published"}',NULL,NULL),
  (@u7,@a1,'approve','comment',(SELECT id FROM comments WHERE content='Tema increible!'),'{"status":"pending"}','{"status":"approved"}',NULL,NULL),
  (@u6,@a1,'create','product',(SELECT id FROM products WHERE slug='camiseta-nocturna'),NULL,'{"status":"active"}',NULL,NULL),
  (@u6,@a1,'update','coupon',(SELECT id FROM coupons WHERE code='BIENVENIDO10'),'{"uses":0}','{"uses":320}',NULL,NULL),
  (@u1,NULL,'login','user',@u6,NULL,'{"ip":"190.1.1.13"}','190.1.1.18','Postman'),
  (@u6,@a1,'delete','post',(SELECT id FROM posts WHERE slug='ultima-cita-post'),'{"status":"draft"}',NULL,NULL,NULL),
  (@u7,@a1,'moderate','comment',(SELECT id FROM comments WHERE content='Ponganla en la gira.'),'{"status":"pending"}','{"status":"spam"}',NULL,NULL);

-- ------------------------------------------------------------
-- ERROR_LOGS (10)
-- ------------------------------------------------------------
INSERT INTO error_logs (level, message, stack_trace, context_json, resolved_at) VALUES
  ('error','Payment gateway timeout',NULL,'{"provider":"stripe"}',NOW()),
  ('warning','Slow query detected',NULL,'{"table":"song_plays"}',NULL),
  ('critical','DB connection lost',NULL,'{"host":"db1"}',NOW()),
  ('info','Cache warmed',NULL,'{"keys":120}',NULL),
  ('error','Email send failed',NULL,'{"to":"sub4@a1.com"}',NULL),
  ('warning','Rate limit near',NULL,'{"ip":"190.1.1.19"}',NULL),
  ('debug','Cron job started',NULL,'{"job":"analytics"}',NULL),
  ('error','Upload to Cloudinary failed',NULL,'{"file":"cover.jpg"}',NOW()),
  ('critical','Disk usage 92%',NULL,'{"mount":"/data"}',NULL),
  ('info','Deploy finished',NULL,'{"env":"prod"}',NULL);

-- ------------------------------------------------------------
-- PAGE_VIEWS (10)
-- ------------------------------------------------------------
INSERT INTO page_views (artist_id, user_id, session_id, page_url, referrer, device_type, country) VALUES
  (@a1,@u2,'sess_aaa1','/cabaxx','google.com','desktop','CO'),
  (@a1,@u3,'sess_aaa2','/cabaxx/songs/nocturna','instagram.com','mobile','CO'),
  (@a1,NULL,'sess_aaa3','/cabaxx/events','facebook.com','desktop','MX'),
  (@a1,@u5,'sess_aaa4','/cabaxx/store','youtube.com','mobile','CO'),
  (@a1,NULL,'sess_aaa5','/cabaxx','direct','tablet','US'),
  (@a1,@u7,'sess_aaa6','/cabaxx/blog/gira-2025','newsletter','desktop','CO'),
  (@a1,@u9,'sess_aaa7','/cabaxx/songs/ritmo-cabi','tiktok.com','mobile','PE'),
  (@a1,NULL,'sess_aaa8','/cabaxx','google.com','desktop','ES'),
  (@a1,@u10,'sess_aaa9','/cabaxx/store/camiseta-nocturna','instagram.com','mobile','CO'),
  (@a1,@u11,'sess_aaa10','/cabaxx/videos','youtube.com','desktop','CL');

-- ------------------------------------------------------------
-- EVENTS_TRACKING (10)
-- ------------------------------------------------------------
INSERT INTO events_tracking (artist_id, user_id, event_name, properties_json) VALUES
  (@a1,@u2,'song_play','{"song":"nocturna"}'),
  (@a1,@u3,'add_to_cart','{"product":"camiseta-nocturna"}'),
  (@a1,@u5,'view_event','{"event":"concierto-bogota"}'),
  (@a1,@u6,'share','{"network":"whatsapp"}'),
  (@a1,@u7,'comment','{"post":"gira-2025"}'),
  (@a1,@u9,'like','{"song":"ritmo-cabi"}'),
  (@a1,@u10,'follow','{"artist":"cabaxx"}'),
  (@a1,NULL,'page_scroll','{"depth":80}'),
  (@a1,@u11,'checkout','{"order":1}'),
  (@a1,@u4,'search','{"q":"fuego"}');

-- ------------------------------------------------------------
-- SONG_PLAYS (10) -> referencia cancion por slug
-- ------------------------------------------------------------
INSERT INTO song_plays (song_id, artist_id, user_id, source, duration_played_seconds, completed) VALUES
  ((SELECT id FROM songs WHERE slug='nocturna'),@a1,@u2,'web',192,1),
  ((SELECT id FROM songs WHERE slug='ritmo-cabi'),@a1,@u3,'app',188,1),
  ((SELECT id FROM songs WHERE slug='mar-de-estrellas'),@a1,@u5,'web',221,1),
  ((SELECT id FROM songs WHERE slug='fuego-en-la-ciudad'),@a1,@u6,'web',205,1),
  ((SELECT id FROM songs WHERE slug='electrica'),@a1,@u7,'app',199,0),
  ((SELECT id FROM songs WHERE slug='calle-y-sol'),@a1,@u9,'web',210,1),
  ((SELECT id FROM songs WHERE slug='promesa'),@a1,@u10,'app',203,1),
  ((SELECT id FROM songs WHERE slug='vuelo-libre'),@a1,@u11,'web',217,1),
  ((SELECT id FROM songs WHERE slug='lejos-de-ti'),@a1,NULL,'web',234,0),
  ((SELECT id FROM songs WHERE slug='nocturna'),@a1,@u4,'app',192,1);

-- ============================================================
-- FIN SEED DE DATOS
-- Total: 10 filas por tabla (45 tablas aprox). Artista principal
-- Cabaxx + 6 artistas demo (multi-tenant).
-- ============================================================

-- Corrige el hilo de comentarios (parent_id no se resuelve dentro del mismo INSERT)
UPDATE comments c
  JOIN comments p ON p.content = 'Voy al de Bogota!'
SET c.parent_id = p.id
WHERE c.content = 'Te esperamos.';

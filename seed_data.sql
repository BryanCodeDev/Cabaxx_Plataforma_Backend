-- ============================================================
-- MAP — SEED DE DATOS
-- ============================================================
-- IMPORTANTE: Ejecutar DESPUES de database.sql (esquema + seed base).
-- Solo 1 artista: Cabitaxx. El resto son usuarios/fans/admins de el.
-- ============================================================

USE map_platform;

SET SQL_SAFE_UPDATES = 0;

SET @cabitaxx = (SELECT id FROM artists WHERE slug = 'cabitaxx');
SET @super    = (SELECT id FROM users WHERE email = 'admin@mastercode.co');

-- ------------------------------------------------------------
-- ARTISTS (9 adicionales -> 10 en total con Cabitaxx)
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
VALUES ('valentina','Valentina Rios','Valentina Rios Pelaez','Singer-songwriter acustica.','Indie acustico.','Indie','AR','Buenos Aires','pending');
SET @a5 = LAST_INSERT_ID();
INSERT INTO artists (slug, stage_name, real_name, bio, short_bio, genre, country, city, status)
VALUES ('djnexus','DJ Nexus','Andres Nexus','DJ de musica electronica.','Electronic / EDM.','Electronic','CO','Cali','active');
SET @a6 = LAST_INSERT_ID();
INSERT INTO artists (slug, stage_name, real_name, bio, short_bio, genre, country, city, status)
VALUES ('loshermanos','Los Hermanos Gomez','Hermanos Gomez','Dueto de musica ranchera.','Ranchera tradicional.','Ranchera','MX','Guadalajara','pending');
SET @a7 = LAST_INSERT_ID();
INSERT INTO artists (slug, stage_name, real_name, bio, short_bio, genre, country, city, status)
VALUES ('mariacamila','Maria Camila','Maria Camila Diaz','Pop latino juvenil.','Pop latino.','Pop','CO','Bogota','active');
SET @a8 = LAST_INSERT_ID();
INSERT INTO artists (slug, stage_name, real_name, bio, short_bio, genre, country, city, status)
VALUES ('ritmolatino','Ritmo Latino','Proyecto Ritmo Latino','Salsa y timba.','Salsa / Timba.','Salsa','CU','La Habana','suspended');
SET @a9 = LAST_INSERT_ID();
INSERT INTO artists (slug, stage_name, real_name, bio, short_bio, genre, country, city, status)
VALUES ('estebanrock','Esteban Rock','Esteban Rock Lopez','Rock alternativo.','Rock alternativo.','Rock','CL','Santiago','pending');
SET @a10 = LAST_INSERT_ID();

-- ------------------------------------------------------------
-- USERS (10 fans/admins adicionales)
-- ------------------------------------------------------------
SET @u1 = @super;
INSERT INTO users (name, email, password_hash, avatar_url, status)
VALUES ('Fan Uno','fan1@cabitaxx.com','$2b$10$REPLACE_WITH_BCRYPT_HASH',NULL,'active');
SET @u2 = LAST_INSERT_ID();
INSERT INTO users (name, email, password_hash, avatar_url, status)
VALUES ('Fan Dos','fan2@cabitaxx.com','$2b$10$REPLACE_WITH_BCRYPT_HASH',NULL,'active');
SET @u3 = LAST_INSERT_ID();
INSERT INTO users (name, email, password_hash, avatar_url, status)
VALUES ('Fan Tres','fan3@cabitaxx.com','$2b$10$REPLACE_WITH_BCRYPT_HASH',NULL,'active');
SET @u4 = LAST_INSERT_ID();
INSERT INTO users (name, email, password_hash, avatar_url, status)
VALUES ('Fan Cuatro','fan4@cabitaxx.com','$2b$10$REPLACE_WITH_BCRYPT_HASH',NULL,'inactive');
SET @u5 = LAST_INSERT_ID();
INSERT INTO users (name, email, password_hash, avatar_url, status)
VALUES ('Fan Cinco','fan5@cabitaxx.com','$2b$10$REPLACE_WITH_BCRYPT_HASH',NULL,'active');
SET @u6 = LAST_INSERT_ID();
INSERT INTO users (name, email, password_hash, avatar_url, status)
VALUES ('Manager Cabitaxx','manager@cabitaxx.com','$2b$10$REPLACE_WITH_BCRYPT_HASH',NULL,'active');
SET @u7 = LAST_INSERT_ID();
INSERT INTO users (name, email, password_hash, avatar_url, status)
VALUES ('Moderadora','mod@cabitaxx.com','$2b$10$REPLACE_WITH_BCRYPT_HASH',NULL,'active');
SET @u8 = LAST_INSERT_ID();
INSERT INTO users (name, email, password_hash, avatar_url, status)
VALUES ('Fan Ocho','fan8@cabitaxx.com','$2b$10$REPLACE_WITH_BCRYPT_HASH',NULL,'banned');
SET @u9 = LAST_INSERT_ID();
INSERT INTO users (name, email, password_hash, avatar_url, status)
VALUES ('Fan Nueve','fan9@cabitaxx.com','$2b$10$REPLACE_WITH_BCRYPT_HASH',NULL,'active');
SET @u10 = LAST_INSERT_ID();
INSERT INTO users (name, email, password_hash, avatar_url, status)
VALUES ('Fan Diez','fan10@cabitaxx.com','$2b$10$REPLACE_WITH_BCRYPT_HASH',NULL,'active');
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
  (@u6, (SELECT id FROM roles WHERE slug='artist_admin'), @cabitaxx),
  (@u7, (SELECT id FROM roles WHERE slug='moderator'), @cabitaxx),
  (@u7, (SELECT id FROM roles WHERE slug='moderator'), @a2),
  (@u2, (SELECT id FROM roles WHERE slug='user'), NULL),
  (@u3, (SELECT id FROM roles WHERE slug='user'), NULL),
  (@u4, (SELECT id FROM roles WHERE slug='premium'), @cabitaxx),
  (@u5, (SELECT id FROM roles WHERE slug='user'), @a3),
  (@u9, (SELECT id FROM roles WHERE slug='user'), @cabitaxx),
  (@u10, (SELECT id FROM roles WHERE slug='user'), @a2),
  (@u11, (SELECT id FROM roles WHERE slug='manager'), @cabitaxx);

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
  ('fan1@cabitaxx.com','pr_hash_001',DATE_ADD(NOW(),INTERVAL 1 HOUR),NULL),
  ('fan2@cabitaxx.com','pr_hash_002',DATE_ADD(NOW(),INTERVAL 1 HOUR),NOW()),
  ('fan3@cabitaxx.com','pr_hash_003',DATE_ADD(NOW(),INTERVAL 1 HOUR),NULL),
  ('fan5@cabitaxx.com','pr_hash_004',DATE_ADD(NOW(),INTERVAL 1 HOUR),NULL),
  ('manager@cabitaxx.com','pr_hash_005',DATE_ADD(NOW(),INTERVAL 1 HOUR),NULL),
  ('mod@cabitaxx.com','pr_hash_006',DATE_ADD(NOW(),INTERVAL 1 HOUR),NULL),
  ('fan8@cabitaxx.com','pr_hash_007',DATE_ADD(NOW(),INTERVAL 1 HOUR),NULL),
  ('fan9@cabitaxx.com','pr_hash_008',DATE_ADD(NOW(),INTERVAL 1 HOUR),NULL),
  ('fan10@cabitaxx.com','pr_hash_009',DATE_ADD(NOW(),INTERVAL 1 HOUR),NULL),
  ('admin@mastercode.co','pr_hash_010',DATE_ADD(NOW(),INTERVAL 1 HOUR),NULL);

-- ------------------------------------------------------------
-- ARTIST_SOCIAL_LINKS (10)
-- ------------------------------------------------------------
INSERT INTO artist_social_links (artist_id, platform, url, followers_count, last_synced_at) VALUES
  (@cabitaxx,'spotify','https://open.spotify.com/artist/cabitaxx',125000,DATE_ADD(NOW(),INTERVAL -1 DAY)),
  (@cabitaxx,'youtube','https://youtube.com/@cabitaxx',98000,DATE_ADD(NOW(),INTERVAL -1 DAY)),
  (@cabitaxx,'instagram','https://instagram.com/cabitaxx',210000,DATE_ADD(NOW(),INTERVAL -2 DAY)),
  (@a2,'spotify','https://open.spotify.com/artist/karolsantos',54000,DATE_ADD(NOW(),INTERVAL -3 DAY)),
  (@a2,'instagram','https://instagram.com/karolsantos',88000,DATE_ADD(NOW(),INTERVAL -3 DAY)),
  (@a3,'youtube','https://youtube.com/@luismiguel',33000,DATE_ADD(NOW(),INTERVAL -4 DAY)),
  (@a4,'spotify','https://open.spotify.com/artist/bandaoficial',21000,DATE_ADD(NOW(),INTERVAL -5 DAY)),
  (@a6,'instagram','https://instagram.com/djnexus',77000,DATE_ADD(NOW(),INTERVAL -1 DAY)),
  (@a8,'tiktok','https://tiktok.com/@mariacamila',150000,DATE_ADD(NOW(),INTERVAL -1 DAY)),
  (@a10,'youtube','https://youtube.com/@estebanrock',12000,DATE_ADD(NOW(),INTERVAL -6 DAY));

-- ------------------------------------------------------------
-- ARTIST_THEMES (1 por artista -> 10)
-- ------------------------------------------------------------
INSERT INTO artist_themes (artist_id, primary_color, secondary_color, accent_color, font_heading, font_body, dark_mode_default) VALUES
  (@cabitaxx,'#0B0B0F','#FFFFFF','#E50914','Inter','Inter',1),
  (@a2,'#1E1E2E','#F5F5F5','#FF6FB5','Poppins','Poppins',0),
  (@a3,'#0A3D2C','#FAFAFA','#F2C14E','Montserrat','Montserrat',1),
  (@a4,'#1A1A1A','#EAEAEA','#FF7A00','Oswald','Roboto',1),
  (@a5,'#2B2D42','#FFFFFF','#8D99AE','Lora','Lora',0),
  (@a6,'#06070A','#00FFC6','#00FFC6','Rajdhani','Rajdhani',1),
  (@a7,'#3B1C1C','#FFF7E6','#C9A227','Playfair Display','Source Sans',0),
  (@a8,'#FF4D6D','#FFFFFF','#FFD166','Quicksand','Quicksand',0),
  (@a9,'#102A43','#F0F4F8','#EF476F','Rubik','Rubik',1),
  (@a10,'#22223B','#F2E9E4','#9A8C98','Bebas Neue','Open Sans',1);

-- ------------------------------------------------------------
-- ARTIST_SEO (1 por artista -> 10)
-- ------------------------------------------------------------
INSERT INTO artist_seo (artist_id, meta_title, meta_description, keywords, og_image_url, schema_json, robots) VALUES
  (@cabitaxx,'Cabitaxx | Musica Urbana','Official site of Cabitaxx.','cabitaxx, musica urbana, latin','https://cdn.map.app/cabitaxx/og.png','{"@type":"MusicGroup"}','index,follow'),
  (@a2,'Karol Santos | Pop','Sitio oficial Karol Santos.','karol santos, pop','https://cdn.map.app/karol/og.png','{"@type":"MusicGroup"}','index,follow'),
  (@a3,'Luis Miguel Vega','Vallenato fusion.','vallenato, tropical','https://cdn.map.app/lmv/og.png','{"@type":"MusicGroup"}','index,follow'),
  (@a4,'Banda Oficial','Rock en espanol.','rock, banda','https://cdn.map.app/banda/og.png','{"@type":"MusicGroup"}','noindex,follow'),
  (@a5,'Valentina Rios','Indie acustico.','indie, acustico','https://cdn.map.app/val/og.png','{"@type":"MusicGroup"}','index,follow'),
  (@a6,'DJ Nexus','Electronic EDM.','edm, dj','https://cdn.map.app/nexus/og.png','{"@type":"MusicGroup"}','index,follow'),
  (@a7,'Los Hermanos Gomez','Ranchera.','ranchera','https://cdn.map.app/hnos/og.png','{"@type":"MusicGroup"}','index,follow'),
  (@a8,'Maria Camila','Pop latino.','pop latino','https://cdn.map.app/mc/og.png','{"@type":"MusicGroup"}','index,follow'),
  (@a9,'Ritmo Latino','Salsa y timba.','salsa','https://cdn.map.app/ritmo/og.png','{"@type":"MusicGroup"}','noindex,nofollow'),
  (@a10,'Esteban Rock','Rock alternativo.','rock alternativo','https://cdn.map.app/est/og.png','{"@type":"MusicGroup"}','index,follow');

-- ------------------------------------------------------------
-- ARTIST_SETTINGS (10)
-- ------------------------------------------------------------
INSERT INTO artist_settings (artist_id, `key`, value, type) VALUES
  (@cabitaxx,'language','es','string'),
  (@cabitaxx,'currency_default','COP','string'),
  (@cabitaxx,'store_enabled','1','boolean'),
  (@cabitaxx,'events_enabled','1','boolean'),
  (@cabitaxx,'newsletter_from','hola@cabitaxx.com','string'),
  (@cabitaxx,'social_auto_post','0','boolean'),
  (@cabitaxx,'max_free_tickets','2','number'),
  (@cabitaxx,'maintenance_mode','0','boolean'),
  (@cabitaxx,'contact_email','contacto@cabitaxx.com','string'),
  (@cabitaxx,'theme_preset','neon','string');

-- ------------------------------------------------------------
-- ARTIST_DOMAINS (10)
-- ------------------------------------------------------------
INSERT INTO artist_domains (artist_id, domain, ssl_status, is_primary) VALUES
  (@cabitaxx,'cabitaxx.com','active',1),
  (@cabitaxx,'www.cabitaxx.com','active',0),
  (@a2,'karolsantos.com','active',1),
  (@a3,'luismiguelvega.mx','pending',1),
  (@a4,'bandaoficial.mx','active',1),
  (@a5,'valentinarios.com','none',1),
  (@a6,'djnexus.live','active',1),
  (@a7,'loshermanosgomez.com','pending',1),
  (@a8,'mariacamila.com','active',1),
  (@a10,'estebanrock.cl','none',1);

-- ------------------------------------------------------------
-- SONGS (10)
-- ------------------------------------------------------------
INSERT INTO songs (artist_id, title, slug, duration_seconds, lyrics, description, cover_url, audio_url, release_date, status, plays_count, likes_count, is_explicit) VALUES
  (@cabitaxx,'Nocturna','nocturna',192,NULL,'Single principal 2025.','https://cdn.map.app/cabitaxx/nocturna.jpg','https://cdn.map.app/cabitaxx/nocturna.mp3','2025-01-15','published',128000,8400,0),
  (@cabitaxx,'Fuego en la Ciudad','fuego-en-la-ciudad',205,NULL,'Tema urbano.','https://cdn.map.app/cabitaxx/fuego.jpg','https://cdn.map.app/cabitaxx/fuego.mp3','2025-02-20','published',96000,6100,0),
  (@cabitaxx,'Mar de Estrellas','mar-de-estrellas',221,NULL,'Balada.','https://cdn.map.app/cabitaxx/mar.jpg','https://cdn.map.app/cabitaxx/mar.mp3','2025-03-10','published',73000,5200,0),
  (@cabitaxx,'Ritmo Cabi','ritmo-cabi',188,NULL,'Reggaeton.','https://cdn.map.app/cabitaxx/ritmo.jpg','https://cdn.map.app/cabitaxx/ritmo.mp3','2025-04-05','published',152000,9900,0),
  (@cabitaxx,'Lejos de Ti','lejos-de-ti',234,NULL,'Despecho.','https://cdn.map.app/cabitaxx/lejos.jpg','https://cdn.map.app/cabitaxx/lejos.mp3','2025-05-12','published',64000,4300,0),
  (@cabitaxx,'Electrica','electrica',199,NULL,'EDM latino.','https://cdn.map.app/cabitaxx/electrica.jpg','https://cdn.map.app/cabitaxx/electrica.mp3','2025-06-01','published',88000,5600,0),
  (@cabitaxx,'Calle y Sol','calle-y-sol',210,NULL,'Tropical.','https://cdn.map.app/cabitaxx/calle.jpg','https://cdn.map.app/cabitaxx/calle.mp3','2025-06-18','published',47000,3100,0),
  (@cabitaxx,'Promesa','promesa',203,NULL,' feat. invitado.','https://cdn.map.app/cabitaxx/promesa.jpg','https://cdn.map.app/cabitaxx/promesa.mp3','2025-07-02','published',102000,7200,0),
  (@cabitaxx,'Vuelo Libre','vuelo-libre',217,NULL,'Pop.','https://cdn.map.app/cabitaxx/vuelo.jpg','https://cdn.map.app/cabitaxx/vuelo.mp3','2025-07-20','published',59000,3800,0),
  (@cabitaxx,'Ultima Cita','ultima-cita',228,NULL,'Cierre de temporada.','https://cdn.map.app/cabitaxx/ultima.jpg','https://cdn.map.app/cabitaxx/ultima.mp3','2025-08-01','draft',0,0,0);

-- ------------------------------------------------------------
-- ALBUMS (10)
-- ------------------------------------------------------------
INSERT INTO albums (artist_id, title, slug, description, cover_url, release_date, type, status) VALUES
  (@cabitaxx,'Nocturno','nocturno','Album debut.','https://cdn.map.app/cabitaxx/al-nocturno.jpg','2025-01-30','album','published'),
  (@cabitaxx,'Ciudad de Fuego','ciudad-de-fuego','EP urbano.','https://cdn.map.app/cabitaxx/al-fuego.jpg','2025-02-28','ep','published'),
  (@cabitaxx,'Mareas','mareas','Baladas.','https://cdn.map.app/cabitaxx/al-mareas.jpg','2025-03-20','album','published'),
  (@cabitaxx,'Cabi Mix','cabi-mix','Set de reggaeton.','https://cdn.map.app/cabitaxx/al-mix.jpg','2025-04-10','album','published'),
  (@cabitaxx,'Acustico','acustico','Versiones acusticas.','https://cdn.map.app/cabitaxx/al-acustico.jpg','2025-05-25','album','published'),
  (@cabitaxx,'Voltio','voltio','EDM.','https://cdn.map.app/cabitaxx/al-voltio.jpg','2025-06-05','ep','published'),
  (@cabitaxx,'Caribe','caribe','Tropical.','https://cdn.map.app/cabitaxx/al-caribe.jpg','2025-06-22','album','published'),
  (@cabitaxx,'Duetos','duetos','Colaboraciones.','https://cdn.map.app/cabitaxx/al-duetos.jpg','2025-07-05','album','published'),
  (@cabitaxx,'Horizonte','horizonte','Pop.','https://cdn.map.app/cabitaxx/al-horizonte.jpg','2025-07-22','album','published'),
  (@cabitaxx,'Recopilatorio 2025','recopilatorio-2025','Best of.','https://cdn.map.app/cabitaxx/al-reco.jpg','2025-08-05','album','draft');

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
  (@cabitaxx,'Nocturna (Official Video)','nocturna-video','Video oficial.','https://cdn.map.app/cabitaxx/v-nocturna.jpg','https://cdn.map.app/cabitaxx/v-nocturna.mp4','yt_nocturna',193,540000,'published',NOW()),
  (@cabitaxx,'Fuego en la Ciudad (Lyric)','fuego-lyric','Lyric video.','https://cdn.map.app/cabitaxx/v-fuego.jpg','https://cdn.map.app/cabitaxx/v-fuego.mp4','yt_fuego',206,210000,'published',NOW()),
  (@cabitaxx,'Behind the Scenes','bts-2025','Detras de camaras.','https://cdn.map.app/cabitaxx/v-bts.jpg','https://cdn.map.app/cabitaxx/v-bts.mp4','yt_bts',312,88000,'published',NOW()),
  (@cabitaxx,'Ritmo Cabi (Live)','ritmo-live','Presentacion en vivo.','https://cdn.map.app/cabitaxx/v-live.jpg','https://cdn.map.app/cabitaxx/v-live.mp4','yt_live',195,330000,'published',NOW()),
  (@cabitaxx,'Acustico Sesion','acustico-sesion','Sesion acustica.','https://cdn.map.app/cabitaxx/v-acu.jpg','https://cdn.map.app/cabitaxx/v-acu.mp4','yt_acu',240,67000,'published',NOW()),
  (@cabitaxx,'Entrevista EXA','entrevista-exa','Entrevista.','https://cdn.map.app/cabitaxx/v-ent.jpg','https://cdn.map.app/cabitaxx/v-ent.mp4','yt_ent',521,41000,'published',NOW()),
  (@cabitaxx,'Electrica (Visualizer)','electrica-visual','Visualizer.','https://cdn.map.app/cabitaxx/v-elec.jpg','https://cdn.map.app/cabitaxx/v-elec.mp4','yt_elec',200,95000,'published',NOW()),
  (@cabitaxx,'Calle y Sol (Dance)','calle-dance','Coreografia.','https://cdn.map.app/cabitaxx/v-calle.jpg','https://cdn.map.app/cabitaxx/v-calle.mp4','yt_calle',212,78000,'published',NOW()),
  (@cabitaxx,'Promesa ft. Invitado','promesa-video','Colaboracion.','https://cdn.map.app/cabitaxx/v-prom.jpg','https://cdn.map.app/cabitaxx/v-prom.mp4','yt_prom',205,150000,'published',NOW()),
  (@cabitaxx,'Ultima Cita (Teaser)','ultima-teaser','Adelanto.','https://cdn.map.app/cabitaxx/v-ult.jpg','https://cdn.map.app/cabitaxx/v-ult.mp4','yt_ult',60,12000,'draft',NULL);

-- ------------------------------------------------------------
-- GALLERY_ITEMS (10)
-- ------------------------------------------------------------
INSERT INTO gallery_items (artist_id, title, description, file_url, file_type, category, sort_order, status) VALUES
  (@cabitaxx,'Portada Nocturno','Foto de portada.','https://cdn.map.app/cabitaxx/g1.jpg','image','cover',1,'active'),
  (@cabitaxx,'Concierto Bogota','En vivo.','https://cdn.map.app/cabitaxx/g2.jpg','image','tour',2,'active'),
  (@cabitaxx,'Estudio','Grabando.','https://cdn.map.app/cabitaxx/g3.jpg','image','studio',3,'active'),
  (@cabitaxx,'Fan Meet','Con fans.','https://cdn.map.app/cabitaxx/g4.jpg','image','fans',4,'active'),
  (@cabitaxx,'Backstage','Backstage.','https://cdn.map.app/cabitaxx/g5.jpg','image','tour',5,'active'),
  (@cabitaxx,'Video Saludo','Saludo a fans.','https://cdn.map.app/cabitaxx/g6.mp4','video','fans',6,'active'),
  (@cabitaxx,'Portada Fuego','Foto promo.','https://cdn.map.app/cabitaxx/g7.jpg','image','cover',7,'active'),
  (@cabitaxx,'Premios','En premios.','https://cdn.map.app/cabitaxx/g8.jpg','image','press',8,'active'),
  (@cabitaxx,'Ensayo','Ensayo general.','https://cdn.map.app/cabitaxx/g9.jpg','image','studio',9,'inactive'),
  (@cabitaxx,'Calle y Sol','Gira.','https://cdn.map.app/cabitaxx/g10.jpg','image','tour',10,'active');

-- ------------------------------------------------------------
-- EVENTS (10)
-- ------------------------------------------------------------
INSERT INTO events (artist_id, title, slug, description, venue_name, venue_address, city, country, lat, lng, start_datetime, end_datetime, timezone, banner_url, status, is_free, capacity) VALUES
  (@cabitaxx,'Concierto Bogota','concierto-bogota','Gran show.','Movistar Arena','Cra 30 #30-50','Bogota','CO',4.658, -74.093,'2025-09-15 20:00:00','2025-09-15 23:00:00','America/Bogota','https://cdn.map.app/cabitaxx/e-bog.jpg','published',0,12000),
  (@cabitaxx,'Festival Medellin','festival-medellin','Festival.','Estadio Atanasio','Cra 74 #48010','Medellin','CO',6.255,-75.590,'2025-10-02 19:00:00','2025-10-02 23:00:00','America/Bogota','https://cdn.map.app/cabitaxx/e-med.jpg','published',0,25000),
  (@cabitaxx,'Show Cali','show-cali','Show.','Centro de Eventos','Cl 5 #33-88','Cali','CO',3.451,-76.532,'2025-10-20 20:00:00','2025-10-20 23:00:00','America/Bogota','https://cdn.map.app/cabitaxx/e-cal.jpg','published',0,8000),
  (@cabitaxx,'Acustico Barranquilla','acustico-barranquilla','Show intimo.','Teatro Amira','Calle 72','Barranquilla','CO',10.963,-74.796,'2025-11-05 20:00:00','2025-11-05 22:30:00','America/Bogota','https://cdn.map.app/cabitaxx/e-bar.jpg','published',0,1500),
  (@cabitaxx,'Meet & Greet','meet-greet','Encuentro.','Hotel Tryp','Cra 15 #124','Bogota','CO',4.690,-74.056,'2025-09-14 17:00:00','2025-09-14 19:00:00','America/Bogota','https://cdn.map.app/cabitaxx/e-mng.jpg','published',1,100),
  (@cabitaxx,'Streaming Live','streaming-live','Show online.','Online','Virtual','Bogota','CO',4.658,-74.093,'2025-12-01 20:00:00','2025-12-01 22:00:00','America/Bogota','https://cdn.map.app/cabitaxx/e-str.jpg','published',1,0),
  (@cabitaxx,'Concierto Mexico','concierto-mexico','Gira internacional.','Auditorio Nacional','Reforma 50','CDMX','MX',19.426,-99.185,'2026-01-18 21:00:00','2026-01-18 23:30:00','America/Mexico_City','https://cdn.map.app/cabitaxx/e-mex.jpg','draft',0,10000),
  (@cabitaxx,'Show Lima','show-lima','Gira Peru.','Jockey Club','Av. El Polo','Lima','PE',-12.092,-76.971,'2026-02-10 20:00:00','2026-02-10 23:00:00','America/Lima','https://cdn.map.app/cabitaxx/e-lim.jpg','draft',0,9000),
  (@cabitaxx,'Festival Zaragoza','festival-zaragoza','Espana.','Auditorio Zaragoza','Pza. Europa','Zaragoza','ES',41.648,-0.889,'2026-03-05 21:00:00','2026-03-05 23:30:00','Europe/Madrid','https://cdn.map.app/cabitaxx/e-zgz.jpg','draft',0,7000),
  (@cabitaxx,'Ultima Cita Tour','ultima-cita-tour','Cierre de gira.','Movistar Arena','Cra 30','Bogota','CO',4.658,-74.093,'2026-04-12 20:00:00','2026-04-12 23:00:00','America/Bogota','https://cdn.map.app/cabitaxx/e-fin.jpg','draft',0,12000);

-- ------------------------------------------------------------
-- TICKETS (10) -> referencia evento por slug (nombres unicos)
-- ------------------------------------------------------------
INSERT INTO tickets (event_id, artist_id, name, description, price, currency, quantity_total, quantity_sold, sale_start_at, sale_end_at, status) VALUES
  ((SELECT id FROM events WHERE slug='concierto-bogota'),@cabitaxx,'General Bogota','Zona general.','120000.00','COP',8000,6200,'2025-07-01 10:00:00','2025-09-10 23:59:00','active'),
  ((SELECT id FROM events WHERE slug='concierto-bogota'),@cabitaxx,'VIP Bogota','Acceso VIP.','350000.00','COP',2000,1900,'2025-07-01 10:00:00','2025-09-10 23:59:00','sold_out'),
  ((SELECT id FROM events WHERE slug='festival-medellin'),@cabitaxx,'General Medellin','Zona general.','150000.00','COP',18000,9000,'2025-07-10 10:00:00','2025-09-28 23:59:00','active'),
  ((SELECT id FROM events WHERE slug='festival-medellin'),@cabitaxx,'Palco Medellin','Palco.','600000.00','COP',200,120,'2025-07-10 10:00:00','2025-09-28 23:59:00','active'),
  ((SELECT id FROM events WHERE slug='show-cali'),@cabitaxx,'General Cali','Zona general.','100000.00','COP',6000,3000,'2025-08-01 10:00:00','2025-10-15 23:59:00','active'),
  ((SELECT id FROM events WHERE slug='acustico-barranquilla'),@cabitaxx,'General Barranquilla','Intimo.','180000.00','COP',1200,800,'2025-08-15 10:00:00','2025-10-30 23:59:00','active'),
  ((SELECT id FROM events WHERE slug='meet-greet'),@cabitaxx,'Meet Greet Bogota','Encuentro.','0.00','COP',100,90,'2025-07-20 10:00:00','2025-09-10 23:59:00','active'),
  ((SELECT id FROM events WHERE slug='streaming-live'),@cabitaxx,'Pase Streaming','Online.','25000.00','COP',0,5000,'2025-08-01 10:00:00','2025-11-30 23:59:00','active'),
  ((SELECT id FROM events WHERE slug='concierto-mexico'),@cabitaxx,'General Mexico','Zona general.','1500.00','MXN',8000,0,'2025-09-01 10:00:00','2026-01-10 23:59:00','inactive'),
  ((SELECT id FROM events WHERE slug='ultima-cita-tour'),@cabitaxx,'General Final','Cierre.','130000.00','COP',9000,0,'2025-10-01 10:00:00','2026-04-05 23:59:00','inactive');

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
  (@cabitaxx,'Ropa','ropa','Merch de ropa.',NULL,NULL,1),
  (@cabitaxx,'Accesorios','accesorios','Accesorios.',NULL,NULL,4),
  (@cabitaxx,'Vinilos','vinilos','Vinilos.',NULL,NULL,6),
  (@cabitaxx,'Digital','digital','Productos digitales.',NULL,NULL,7),
  (@cabitaxx,'Posters','posters','Posters.',NULL,NULL,8);

SET @cat_ropa = (SELECT id FROM product_categories WHERE artist_id = @cabitaxx AND slug = 'ropa');
SET @cat_accesorios = (SELECT id FROM product_categories WHERE artist_id = @cabitaxx AND slug = 'accesorios');

INSERT INTO product_categories (artist_id, name, slug, description, image_url, parent_id, sort_order) VALUES
  (@cabitaxx,'Camisetas','camisetas','Camisetas oficiales.',NULL,@cat_ropa,2),
  (@cabitaxx,'Sudaderas','sudaderas','Sudaderas.',NULL,@cat_ropa,3),
  (@cabitaxx,'Gorras','gorras','Gorras.',NULL,@cat_accesorios,5),
  (@cabitaxx,'Llaveros','llaveros','Llaveros.',NULL,@cat_accesorios,9),
  (@cabitaxx,'Pack Fans','pack-fans','Packs exclusivos.',NULL,NULL,10);

-- ------------------------------------------------------------
-- PRODUCTS (10)
-- ------------------------------------------------------------
INSERT INTO products (artist_id, category_id, name, slug, description, price, compare_at_price, currency, sku, stock_quantity, type, cover_url, status, weight_grams) VALUES
  (@cabitaxx,(SELECT id FROM product_categories WHERE slug='camisetas'),'Camiseta Nocturna','camiseta-nocturna','Talla unisex.','75000.00','90000.00','COP','CAM-NOC-001',300,'physical','https://cdn.map.app/cabitaxx/p1.jpg','active',200),
  (@cabitaxx,(SELECT id FROM product_categories WHERE slug='sudaderas'),'Sudadera Cabi','sudadera-cabi','Sudadera bordada.','150000.00',NULL,'COP','SUD-CAB-002',150,'physical','https://cdn.map.app/cabitaxx/p2.jpg','active',500),
  (@cabitaxx,(SELECT id FROM product_categories WHERE slug='gorras'),'Gorra Logo','gorra-logo','Gorra snapback.','60000.00','70000.00','COP','GOR-LOG-003',200,'physical','https://cdn.map.app/cabitaxx/p3.jpg','active',150),
  (@cabitaxx,(SELECT id FROM product_categories WHERE slug='vinilos'),'Vinilo Nocturno','vinilo-nocturno','Edicion limitada.','130000.00',NULL,'COP','VIN-NOC-004',80,'physical','https://cdn.map.app/cabitaxx/p4.jpg','active',350),
  (@cabitaxx,(SELECT id FROM product_categories WHERE slug='digital'),'Album Digital','album-digital','Descarga MP3.','35000.00',NULL,'COP','DIG-ALB-005',9999,'digital','https://cdn.map.app/cabitaxx/p5.jpg','active',0),
  (@cabitaxx,(SELECT id FROM product_categories WHERE slug='posters'),'Poster Gira','poster-gira','Poster A2.','40000.00',NULL,'COP','POS-GIR-006',120,'physical','https://cdn.map.app/cabitaxx/p6.jpg','active',100),
  (@cabitaxx,(SELECT id FROM product_categories WHERE slug='llaveros'),'Llavero Logo','llavero-logo','Llavero metalico.','20000.00','25000.00','COP','LLA-LOG-007',500,'physical','https://cdn.map.app/cabitaxx/p7.jpg','active',50),
  (@cabitaxx,(SELECT id FROM product_categories WHERE slug='pack-fans'),'Pack Meet & Greet','pack-meet','Incluye meet.','450000.00',NULL,'COP','PKM-MTG-008',30,'ticket','https://cdn.map.app/cabitaxx/p8.jpg','active',0),
  (@cabitaxx,(SELECT id FROM product_categories WHERE slug='camisetas'),'Camiseta Fuego','camiseta-fuego','Edicion tour.','80000.00',NULL,'COP','CAM-FUE-009',220,'physical','https://cdn.map.app/cabitaxx/p9.jpg','active',200),
  (@cabitaxx,(SELECT id FROM product_categories WHERE slug='digital'),'Ringtone Pack','ringtone-pack','Tonos.','15000.00',NULL,'COP','DIG-RNG-010',9999,'digital','https://cdn.map.app/cabitaxx/p10.jpg','draft',0);

-- ------------------------------------------------------------
-- PRODUCT_IMAGES (10)
-- ------------------------------------------------------------
INSERT INTO product_images (product_id, url, alt_text, sort_order) VALUES
  ((SELECT id FROM products WHERE slug='camiseta-nocturna'),'https://cdn.map.app/cabitaxx/p1a.jpg','Frente',1),
  ((SELECT id FROM products WHERE slug='camiseta-nocturna'),'https://cdn.map.app/cabitaxx/p1b.jpg','Espalda',2),
  ((SELECT id FROM products WHERE slug='sudadera-cabi'),'https://cdn.map.app/cabitaxx/p2a.jpg','Frente',1),
  ((SELECT id FROM products WHERE slug='gorra-logo'),'https://cdn.map.app/cabitaxx/p3a.jpg','Lateral',1),
  ((SELECT id FROM products WHERE slug='vinilo-nocturno'),'https://cdn.map.app/cabitaxx/p4a.jpg','Portada',1),
  ((SELECT id FROM products WHERE slug='album-digital'),'https://cdn.map.app/cabitaxx/p5a.jpg','Caratula',1),
  ((SELECT id FROM products WHERE slug='poster-gira'),'https://cdn.map.app/cabitaxx/p6a.jpg','Poster',1),
  ((SELECT id FROM products WHERE slug='pack-meet'),'https://cdn.map.app/cabitaxx/p8a.jpg','Pack',1),
  ((SELECT id FROM products WHERE slug='camiseta-fuego'),'https://cdn.map.app/cabitaxx/p9a.jpg','Frente',1),
  ((SELECT id FROM products WHERE slug='ringtone-pack'),'https://cdn.map.app/cabitaxx/p10a.jpg','Icono',1);

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
  (@cabitaxx,'BIENVENIDO10','percent',10.00,0.00,1000,320,DATE_ADD(NOW(),INTERVAL 60 DAY),'active'),
  (@cabitaxx,'CABI20','percent',20.00,80000.00,500,150,DATE_ADD(NOW(),INTERVAL 30 DAY),'active'),
  (@cabitaxx,'ENVIOFREE','fixed',15000.00,100000.00,200,40,DATE_ADD(NOW(),INTERVAL 45 DAY),'active'),
  (@cabitaxx,'FAN15','percent',15.00,50000.00,300,88,DATE_ADD(NOW(),INTERVAL 15 DAY),'active'),
  (@cabitaxx,'NOCTURNO5','fixed',5000.00,0.00,999,500,DATE_ADD(NOW(),INTERVAL 90 DAY),'active'),
  (@cabitaxx,'VERANO25','percent',25.00,120000.00,100,12,DATE_ADD(NOW(),INTERVAL 20 DAY),'active'),
  (@cabitaxx,'PACKVIP','fixed',50000.00,400000.00,50,3,DATE_ADD(NOW(),INTERVAL 10 DAY),'active'),
  (@cabitaxx,'BLACKFRIDAY','percent',30.00,0.00,2000,0,DATE_ADD(NOW(),INTERVAL 5 DAY),'active'),
  (@cabitaxx,'SUPERFAN','percent',12.00,30000.00,800,210,DATE_ADD(NOW(),INTERVAL 120 DAY),'inactive'),
  (@cabitaxx,'EXPIRADO','percent',50.00,0.00,100,100,DATE_ADD(NOW(),INTERVAL -10 DAY),'expired');

-- ------------------------------------------------------------
-- ORDERS (10) -> capturamos @o1..@o10
-- ------------------------------------------------------------
INSERT INTO orders (user_id, artist_id, status, subtotal, discount, shipping, tax, total, currency, coupon_id, notes)
VALUES (@u2,@cabitaxx,'paid',150000.00,15000.00,15000.00,0.00,150000.00,'COP',(SELECT id FROM coupons WHERE code='BIENVENIDO10'),'Entrega 2-3 dias');
SET @o1 = LAST_INSERT_ID();
INSERT INTO orders (user_id, artist_id, status, subtotal, discount, shipping, tax, total, currency, coupon_id, notes)
VALUES (@u3,@cabitaxx,'paid',300000.00,60000.00,0.00,0.00,240000.00,'COP',(SELECT id FROM coupons WHERE code='CABI20'),'Cliente VIP');
SET @o2 = LAST_INSERT_ID();
INSERT INTO orders (user_id, artist_id, status, subtotal, discount, shipping, tax, total, currency, coupon_id, notes)
VALUES (@u5,@cabitaxx,'processing',130000.00,0.00,15000.00,0.00,145000.00,'COP',NULL,'Empacando');
SET @o3 = LAST_INSERT_ID();
INSERT INTO orders (user_id, artist_id, status, subtotal, discount, shipping, tax, total, currency, coupon_id, notes)
VALUES (@u6,@cabitaxx,'shipped',75000.00,11250.00,15000.00,0.00,78750.00,'COP',(SELECT id FROM coupons WHERE code='FAN15'),'En camino');
SET @o4 = LAST_INSERT_ID();
INSERT INTO orders (user_id, artist_id, status, subtotal, discount, shipping, tax, total, currency, coupon_id, notes)
VALUES (@u7,@cabitaxx,'delivered',450000.00,0.00,0.00,0.00,450000.00,'COP',NULL,'Pack meet');
SET @o5 = LAST_INSERT_ID();
INSERT INTO orders (user_id, artist_id, status, subtotal, discount, shipping, tax, total, currency, coupon_id, notes)
VALUES (@u9,@cabitaxx,'paid',60000.00,9000.00,0.00,0.00,51000.00,'COP',(SELECT id FROM coupons WHERE code='BIENVENIDO10'),'Gorra');
SET @o6 = LAST_INSERT_ID();
INSERT INTO orders (user_id, artist_id, status, subtotal, discount, shipping, tax, total, currency, coupon_id, notes)
VALUES (@u10,@cabitaxx,'pending',35000.00,0.00,0.00,0.00,35000.00,'COP',NULL,'Digital');
SET @o7 = LAST_INSERT_ID();
INSERT INTO orders (user_id, artist_id, status, subtotal, discount, shipping, tax, total, currency, coupon_id, notes)
VALUES (@u11,@cabitaxx,'cancelled',150000.00,0.00,15000.00,0.00,165000.00,'COP',NULL,'Cancelado por cliente');
SET @o8 = LAST_INSERT_ID();
INSERT INTO orders (user_id, artist_id, status, subtotal, discount, shipping, tax, total, currency, coupon_id, notes)
VALUES (@u2,@cabitaxx,'paid',200000.00,40000.00,0.00,0.00,160000.00,'COP',(SELECT id FROM coupons WHERE code='CABI20'),'Dos camisetas');
SET @o9 = LAST_INSERT_ID();
INSERT INTO orders (user_id, artist_id, status, subtotal, discount, shipping, tax, total, currency, coupon_id, notes)
VALUES (@u4,@cabitaxx,'refunded',80000.00,0.00,15000.00,0.00,95000.00,'COP',NULL,'Reembolso solicitado');
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
  (@o7,NULL,NULL,'pending',NULL,NULL,'{"email":"fan9@cabitaxx.com"}'),
  (@o8,'Servientrega','TRK-1008','pending',NULL,NULL,'{"city":"Bogota","zip":"110111"}'),
  (@o9,'Coordinadora','TRK-1009','delivered','2025-07-12 10:00:00','2025-07-14 14:00:00','{"city":"Bogota","zip":"110111"}'),
  (@o10,'Servientrega','TRK-1010','returned','2025-07-11 10:00:00','2025-07-15 14:00:00','{"city":"Bogota","zip":"110111"}');

-- ------------------------------------------------------------
-- PAYMENTS (10)
-- ------------------------------------------------------------
INSERT INTO payments (order_id, user_id, artist_id, provider, provider_tx_id, amount, currency, status, response_json, paid_at) VALUES
  (@o1,@u2,@cabitaxx,'stripe','pi_1A001',150000.00,'COP','succeeded','{"status":"ok"}',NOW()),
  (@o2,@u3,@cabitaxx,'stripe','pi_1A002',240000.00,'COP','succeeded','{"status":"ok"}',NOW()),
  (@o3,@u5,@cabitaxx,'paypal','pp_1A003',145000.00,'COP','pending','{"status":"pending"}',NULL),
  (@o4,@u6,@cabitaxx,'stripe','pi_1A004',78750.00,'COP','succeeded','{"status":"ok"}',NOW()),
  (@o5,@u7,@cabitaxx,'wompi','wo_1A005',450000.00,'COP','succeeded','{"status":"ok"}',NOW()),
  (@o6,@u9,@cabitaxx,'stripe','pi_1A006',51000.00,'COP','succeeded','{"status":"ok"}',NOW()),
  (@o7,@u10,@cabitaxx,'stripe','pi_1A007',35000.00,'COP','succeeded','{"status":"ok"}',NOW()),
  (@o8,@u11,@cabitaxx,'stripe','pi_1A008',165000.00,'COP','refunded','{"status":"refunded"}',NOW()),
  (@o9,@u2,@cabitaxx,'stripe','pi_1A009',160000.00,'COP','succeeded','{"status":"ok"}',NOW()),
  (@o10,@u4,@cabitaxx,'paypal','pp_1A010',95000.00,'COP','refunded','{"status":"refunded"}',NOW());

-- ------------------------------------------------------------
-- POSTS (10)
-- ------------------------------------------------------------
INSERT INTO posts (artist_id, user_id, type, title, slug, content, excerpt, cover_url, status, published_at, views_count) VALUES
  (@cabitaxx,@u6,'news','Nuevo album Nocturno','nuevo-album-nocturno','Ya disponible nuestro album debut.','Album debut disponible.','https://cdn.map.app/cabitaxx/post1.jpg','published',NOW(),12000),
  (@cabitaxx,@u6,'blog','Detras de Fuego en la Ciudad','detras-fuego','Como creamos el tema.','Proceso creativo.','https://cdn.map.app/cabitaxx/post2.jpg','published',NOW(),8400),
  (@cabitaxx,@u6,'update','Gira 2025 confirmada','gira-2025','Fechas de la gira.','Fechas gira.','https://cdn.map.app/cabitaxx/post3.jpg','published',NOW(),21000),
  (@cabitaxx,@u6,'news','Colaboracion con invitado','colaboracion-invitado','Nuevo dueto.','Nuevo dueto.','https://cdn.map.app/cabitaxx/post4.jpg','published',NOW(),15600),
  (@cabitaxx,@u6,'blog','Mi estudio en Bogota','mi-estudio','Tour por el estudio.','Sobre el estudio.','https://cdn.map.app/cabitaxx/post5.jpg','published',NOW(),6200),
  (@cabitaxx,@u6,'update','Merch nueva coleccion','merch-coleccion','Ropa oficial.','Nueva ropa.','https://cdn.map.app/cabitaxx/post6.jpg','published',NOW(),9800),
  (@cabitaxx,@u6,'news','Premios nominacion','premios-nominacion','Nominados.','Nominados.','https://cdn.map.app/cabitaxx/post7.jpg','published',NOW(),7300),
  (@cabitaxx,@u6,'blog','Acustico sesion','acustico-sesion-post','Sesion especial.','Sesion acustica.','https://cdn.map.app/cabitaxx/post8.jpg','published',NOW(),5100),
  (@cabitaxx,@u6,'update','Streaming live','streaming-live-post','Show online.','Show online.','https://cdn.map.app/cabitaxx/post9.jpg','published',NOW(),6400),
  (@cabitaxx,@u6,'news','Ultima Cita','ultima-cita-post','Cierre de temporada.','Cierre.','https://cdn.map.app/cabitaxx/post10.jpg','draft',NULL,0);

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
  (@u2,@cabitaxx,(SELECT id FROM songs WHERE slug='nocturna'),'song','Tema increible!','approved',NULL),
  (@u3,@cabitaxx,(SELECT id FROM songs WHERE slug='ritmo-cabi'),'song','El ritmo es viral.','approved',NULL),
  (@u5,@cabitaxx,(SELECT id FROM posts WHERE slug='gira-2025'),'post','Voy al de Bogota!','approved',NULL);

SET @comment_parent = (SELECT id FROM comments WHERE content = 'Voy al de Bogota!' AND artist_id = @cabitaxx);

INSERT INTO comments (user_id, artist_id, reference_id, reference_type, content, status, parent_id) VALUES
  (@u6,@cabitaxx,(SELECT id FROM posts WHERE slug='gira-2025'),'post','Te esperamos.','approved',@comment_parent),
  (@u7,@cabitaxx,(SELECT id FROM events WHERE slug='concierto-bogota'),'event','Compre VIP.','approved',NULL),
  (@u9,@cabitaxx,(SELECT id FROM songs WHERE slug='mar-de-estrellas'),'song','Me hace llorar.','approved',NULL),
  (@u10,@cabitaxx,(SELECT id FROM posts WHERE slug='merch-coleccion'),'post','La sudadera es buenisima.','approved',NULL),
  (@u11,@cabitaxx,(SELECT id FROM videos WHERE slug='ritmo-live'),'video','El live fue epico.','pending',NULL),
  (@u4,@cabitaxx,(SELECT id FROM songs WHERE slug='electrica'),'song','Ponganla en la gira.','spam',NULL),
  (@u2,@cabitaxx,(SELECT id FROM events WHERE slug='meet-greet'),'event','Gracias por el meet.','approved',NULL);

-- ------------------------------------------------------------
-- LIKES (10)
-- ------------------------------------------------------------
INSERT INTO likes (user_id, artist_id, reference_id, reference_type) VALUES
  (@u2,@cabitaxx,(SELECT id FROM songs WHERE slug='nocturna'),'song'),
  (@u3,@cabitaxx,(SELECT id FROM songs WHERE slug='ritmo-cabi'),'song'),
  (@u5,@cabitaxx,(SELECT id FROM posts WHERE slug='gira-2025'),'post'),
  (@u6,@cabitaxx,(SELECT id FROM videos WHERE slug='nocturna-video'),'video'),
  (@u7,@cabitaxx,(SELECT id FROM songs WHERE slug='mar-de-estrellas'),'song'),
  (@u9,@cabitaxx,(SELECT id FROM albums WHERE slug='nocturno'),'album'),
  (@u10,@cabitaxx,(SELECT id FROM events WHERE slug='concierto-bogota'),'event'),
  (@u11,@cabitaxx,(SELECT id FROM songs WHERE slug='electrica'),'song'),
  (@u2,@cabitaxx,(SELECT id FROM posts WHERE slug='merch-coleccion'),'post'),
  (@u4,@cabitaxx,(SELECT id FROM videos WHERE slug='promesa-video'),'video');

-- ------------------------------------------------------------
-- FOLLOWS (10)
-- ------------------------------------------------------------
INSERT INTO follows (user_id, artist_id) VALUES
  (@u2,@cabitaxx),
  (@u3,@cabitaxx),
  (@u4,@cabitaxx),
  (@u5,@cabitaxx),
  (@u7,@cabitaxx),
  (@u9,@cabitaxx),
  (@u10,@cabitaxx),
  (@u11,@cabitaxx),
  (@u2,@a2),
  (@u3,@a3);

-- ------------------------------------------------------------
-- NEWSLETTER_SUBSCRIBERS (10)
-- ------------------------------------------------------------
INSERT INTO newsletter_subscribers (artist_id, email, name, status, subscribed_at, unsubscribed_at, source) VALUES
  (@cabitaxx,'sub1@cabitaxx.com','Suscriptor Uno','subscribed',DATE_ADD(NOW(),INTERVAL -40 DAY),NULL,'website'),
  (@cabitaxx,'sub2@cabitaxx.com','Suscriptor Dos','subscribed',DATE_ADD(NOW(),INTERVAL -35 DAY),NULL,'checkout'),
  (@cabitaxx,'sub3@cabitaxx.com','Suscriptor Tres','subscribed',DATE_ADD(NOW(),INTERVAL -30 DAY),NULL,'instagram'),
  (@cabitaxx,'sub4@cabitaxx.com','Suscriptor Cuatro','unsubscribed',DATE_ADD(NOW(),INTERVAL -28 DAY),NOW(),'website'),
  (@cabitaxx,'sub5@cabitaxx.com','Suscriptor Cinco','subscribed',DATE_ADD(NOW(),INTERVAL -20 DAY),NULL,'youtube'),
  (@cabitaxx,'sub6@cabitaxx.com','Suscriptor Seis','bounced',DATE_ADD(NOW(),INTERVAL -18 DAY),NULL,'website'),
  (@cabitaxx,'sub7@cabitaxx.com','Suscriptor Siete','subscribed',DATE_ADD(NOW(),INTERVAL -15 DAY),NULL,'event'),
  (@cabitaxx,'sub8@cabitaxx.com','Suscriptor Ocho','subscribed',DATE_ADD(NOW(),INTERVAL -10 DAY),NULL,'website'),
  (@cabitaxx,'sub9@cabitaxx.com','Suscriptor Nueve','subscribed',DATE_ADD(NOW(),INTERVAL -5 DAY),NULL,'tiktok'),
  (@cabitaxx,'sub10@cabitaxx.com','Suscriptor Diez','subscribed',DATE_ADD(NOW(),INTERVAL -2 DAY),NULL,'website');

-- ------------------------------------------------------------
-- NEWSLETTER_CAMPAIGNS (10)
-- ------------------------------------------------------------
INSERT INTO newsletter_campaigns (artist_id, subject, content_html, sent_at, total_sent, total_opened, total_clicked) VALUES
  (@cabitaxx,'Lanzamiento Nocturno','<h1>Nocturno ya aqui</h1>',DATE_ADD(NOW(),INTERVAL -39 DAY),5000,2200,310),
  (@cabitaxx,'Gira 2025','<h1>Fechas gira</h1>',DATE_ADD(NOW(),INTERVAL -29 DAY),5200,2400,520),
  (@cabitaxx,'Nueva Merch','<h1>Ropa oficial</h1>',DATE_ADD(NOW(),INTERVAL -20 DAY),4800,1900,410),
  (@cabitaxx,'Fuego en la Ciudad','<h1>Escucha Fuego</h1>',DATE_ADD(NOW(),INTERVAL -15 DAY),4900,2100,380),
  (@cabitaxx,'Colaboracion','<h1>Nuevo dueto</h1>',DATE_ADD(NOW(),INTERVAL -10 DAY),5000,2300,460),
  (@cabitaxx,'Black Friday','<h1>30% descuento</h1>',DATE_ADD(NOW(),INTERVAL -5 DAY),5300,2600,640),
  (@cabitaxx,'Show Cali','<h1>Boletas Cali</h1>',DATE_ADD(NOW(),INTERVAL -3 DAY),4700,1800,300),
  (@cabitaxx,'Acustico Sesion','<h1>Sesion acustica</h1>',DATE_ADD(NOW(),INTERVAL -2 DAY),4600,1700,280),
  (@cabitaxx,'Streaming Live','<h1>Show online</h1>',DATE_ADD(NOW(),INTERVAL -1 DAY),4500,1600,250),
  (@cabitaxx,'Ultima Cita','<h1>Cierre temporada</h1>',NULL,0,0,0);

-- ------------------------------------------------------------
-- NOTIFICATIONS (10)
-- ------------------------------------------------------------
INSERT INTO notifications (user_id, artist_id, type, title, body, data_json, read_at, sent_at) VALUES
  (@u2,@cabitaxx,'order','Pedido enviado','Tu pedido salio.','{"order_id":1}','2025-07-07 14:00:00',NOW()),
  (@u3,@cabitaxx,'order','Pedido entregado','Recibiste tu pedido.','{"order_id":2}',NULL,NOW()),
  (@u5,@cabitaxx,'event','Recordatorio concierto','Falta 1 mes.','{"event_id":1}',NULL,NOW()),
  (@u6,@cabitaxx,'role','Eres admin','Tienes acceso.','{"role":"artist_admin"}',NOW(),NOW()),
  (@u7,@cabitaxx,'comment','Comentario aprobado','Tu comentario fue aprobado.','{"comment_id":1}',NULL,NOW()),
  (@u9,@cabitaxx,'order','Pedido en camino','En transito.','{"order_id":6}',NULL,NOW()),
  (@u10,@cabitaxx,'newsletter','Nueva campana','Revisa nuestro newsletter.','{}',NULL,NOW()),
  (@u11,@cabitaxx,'order','Reembolso','Reembolso procesado.','{"order_id":8}',NOW(),NOW()),
  (@u2,@cabitaxx,'event','Meet & Greet','Confirmado.','{"event_id":5}',NULL,NOW()),
  (@u4,@cabitaxx,'system','Bienvenido','Gracias por suscribirte.','{}',NULL,NOW());

-- ------------------------------------------------------------
-- AUDIT_LOGS (10)
-- ------------------------------------------------------------
INSERT INTO audit_logs (user_id, artist_id, action, entity_type, entity_id, old_values_json, new_values_json, ip_address, user_agent) VALUES
  (@u6,@cabitaxx,'create','song',(SELECT id FROM songs WHERE slug='nocturna'),NULL,'{"status":"published"}','190.1.1.13','Mozilla/5.0 Win'),
  (@u6,@cabitaxx,'update','song',(SELECT id FROM songs WHERE slug='fuego-en-la-ciudad'),'{"plays":0}','{"plays":96000}',NULL,NULL),
  (@u6,@cabitaxx,'create','album',(SELECT id FROM albums WHERE slug='nocturno'),NULL,'{"status":"published"}',NULL,NULL),
  (@u6,@cabitaxx,'create','event',(SELECT id FROM events WHERE slug='concierto-bogota'),NULL,'{"status":"published"}',NULL,NULL),
  (@u7,@cabitaxx,'approve','comment',(SELECT id FROM comments WHERE content='Tema increible!'),'{"status":"pending"}','{"status":"approved"}',NULL,NULL),
  (@u6,@cabitaxx,'create','product',(SELECT id FROM products WHERE slug='camiseta-nocturna'),NULL,'{"status":"active"}',NULL,NULL),
  (@u6,@cabitaxx,'update','coupon',(SELECT id FROM coupons WHERE code='BIENVENIDO10'),'{"uses":0}','{"uses":320}',NULL,NULL),
  (@u1,NULL,'login','user',@u6,NULL,'{"ip":"190.1.1.13"}','190.1.1.18','Postman'),
  (@u6,@cabitaxx,'delete','post',(SELECT id FROM posts WHERE slug='ultima-cita-post'),'{"status":"draft"}',NULL,NULL,NULL),
  (@u7,@cabitaxx,'moderate','comment',(SELECT id FROM comments WHERE content='Ponganla en la gira.'),'{"status":"pending"}','{"status":"spam"}',NULL,NULL);

-- ------------------------------------------------------------
-- ERROR_LOGS (10)
-- ------------------------------------------------------------
INSERT INTO error_logs (level, message, stack_trace, context_json, resolved_at) VALUES
  ('error','Payment gateway timeout',NULL,'{"provider":"stripe"}',NOW()),
  ('warning','Slow query detected',NULL,'{"table":"song_plays"}',NULL),
  ('critical','DB connection lost',NULL,'{"host":"db1"}',NOW()),
  ('info','Cache warmed',NULL,'{"keys":120}',NULL),
  ('error','Email send failed',NULL,'{"to":"sub4@cabitaxx.com"}',NULL),
  ('warning','Rate limit near',NULL,'{"ip":"190.1.1.19"}',NULL),
  ('debug','Cron job started',NULL,'{"job":"analytics"}',NULL),
  ('error','Upload to Cloudinary failed',NULL,'{"file":"cover.jpg"}',NOW()),
  ('critical','Disk usage 92%',NULL,'{"mount":"/data"}',NULL),
  ('info','Deploy finished',NULL,'{"env":"prod"}',NULL);

-- ------------------------------------------------------------
-- PAGE_VIEWS (10)
-- ------------------------------------------------------------
INSERT INTO page_views (artist_id, user_id, session_id, page_url, referrer, device_type, country) VALUES
  (@cabitaxx,@u2,'sess_aaa1','/cabitaxx','google.com','desktop','CO'),
  (@cabitaxx,@u3,'sess_aaa2','/cabitaxx/songs/nocturna','instagram.com','mobile','CO'),
  (@cabitaxx,NULL,'sess_aaa3','/cabitaxx/events','facebook.com','desktop','MX'),
  (@cabitaxx,@u5,'sess_aaa4','/cabitaxx/store','youtube.com','mobile','CO'),
  (@cabitaxx,NULL,'sess_aaa5','/cabitaxx','direct','tablet','US'),
  (@cabitaxx,@u7,'sess_aaa6','/cabitaxx/blog/gira-2025','newsletter','desktop','CO'),
  (@cabitaxx,@u9,'sess_aaa7','/cabitaxx/songs/ritmo-cabi','tiktok.com','mobile','PE'),
  (@cabitaxx,NULL,'sess_aaa8','/cabitaxx','google.com','desktop','ES'),
  (@cabitaxx,@u10,'sess_aaa9','/cabitaxx/store/camiseta-nocturna','instagram.com','mobile','CO'),
  (@cabitaxx,@u11,'sess_aaa10','/cabitaxx/videos','youtube.com','desktop','CL');

-- ------------------------------------------------------------
-- EVENTS_TRACKING (10)
-- ------------------------------------------------------------
INSERT INTO events_tracking (artist_id, user_id, event_name, properties_json) VALUES
  (@cabitaxx,@u2,'song_play','{"song":"nocturna"}'),
  (@cabitaxx,@u3,'add_to_cart','{"product":"camiseta-nocturna"}'),
  (@cabitaxx,@u5,'view_event','{"event":"concierto-bogota"}'),
  (@cabitaxx,@u6,'share','{"network":"whatsapp"}'),
  (@cabitaxx,@u7,'comment','{"post":"gira-2025"}'),
  (@cabitaxx,@u9,'like','{"song":"ritmo-cabi"}'),
  (@cabitaxx,@u10,'follow','{"artist":"cabitaxx"}'),
  (@cabitaxx,NULL,'page_scroll','{"depth":80}'),
  (@cabitaxx,@u11,'checkout','{"order":1}'),
  (@cabitaxx,@u4,'search','{"q":"fuego"}');

-- ------------------------------------------------------------
-- SONG_PLAYS (10) -> referencia cancion por slug
-- ------------------------------------------------------------
INSERT INTO song_plays (song_id, artist_id, user_id, source, duration_played_seconds, completed) VALUES
  ((SELECT id FROM songs WHERE slug='nocturna'),@cabitaxx,@u2,'web',192,1),
  ((SELECT id FROM songs WHERE slug='ritmo-cabi'),@cabitaxx,@u3,'app',188,1),
  ((SELECT id FROM songs WHERE slug='mar-de-estrellas'),@cabitaxx,@u5,'web',221,1),
  ((SELECT id FROM songs WHERE slug='fuego-en-la-ciudad'),@cabitaxx,@u6,'web',205,1),
  ((SELECT id FROM songs WHERE slug='electrica'),@cabitaxx,@u7,'app',199,0),
  ((SELECT id FROM songs WHERE slug='calle-y-sol'),@cabitaxx,@u9,'web',210,1),
  ((SELECT id FROM songs WHERE slug='promesa'),@cabitaxx,@u10,'app',203,1),
  ((SELECT id FROM songs WHERE slug='vuelo-libre'),@cabitaxx,@u11,'web',217,1),
  ((SELECT id FROM songs WHERE slug='lejos-de-ti'),@cabitaxx,NULL,'web',234,0),
  ((SELECT id FROM songs WHERE slug='nocturna'),@cabitaxx,@u4,'app',192,1);

-- ============================================================
-- FIN SEED DE DATOS
-- Total: 10 filas por tabla (45 tablas aprox). Artista principal
-- Cabitaxx + 9 artistas demo (multi-tenant).
-- ============================================================

-- Corrige el hilo de comentarios (parent_id no se resuelve dentro del mismo INSERT)
UPDATE comments c
  JOIN comments p ON p.content = 'Voy al de Bogota!'
SET c.parent_id = p.id
WHERE c.content = 'Te esperamos.';

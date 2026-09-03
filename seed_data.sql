-- ============================================================
-- SEED DATA — Cabaxx
-- Datos iniciales necesarios para arrancar la plataforma
-- ============================================================

-- ------------------------------------------------------------
-- ROLES DEL SISTEMA
-- ------------------------------------------------------------
INSERT INTO roles (id, name, slug, description) VALUES
  (1, 'Superadministrador', 'superadmin', 'Acceso total al sistema'),
  (2, 'Administrador del artista', 'artist_admin', 'Administra al artista Cabaxx'),
  (3, 'Usuario', 'user', 'Fan registrado en la plataforma'),
  (4, 'Invitado', 'guest', 'Visitante sin cuenta')
ON DUPLICATE KEY UPDATE name=VALUES(name), description=VALUES(description);

-- ------------------------------------------------------------
-- PERMISOS BASE
-- ------------------------------------------------------------
INSERT INTO permissions (id, name, slug, module, description) VALUES
  (1,  'Ver panel',                  'view_dashboard',        'dashboard',     'Acceso al panel de control'),
  (2,  'Gestionar canciones',        'manage_songs',          'songs',         'CRUD de canciones'),
  (3,  'Gestionar álbumes',          'manage_albums',         'albums',        'CRUD de álbumes'),
  (4,  'Gestionar eventos',          'manage_events',         'events',        'CRUD de eventos y boletería'),
  (5,  'Gestionar tienda',           'manage_store',          'store',         'CRUD de productos, categorías y cupones'),
  (6,  'Gestionar pedidos',          'manage_orders',         'orders',        'Gestión de pedidos y pagos'),
  (7,  'Gestionar videos',           'manage_videos',         'videos',        'CRUD de videos'),
  (8,  'Gestionar galería',          'manage_gallery',        'gallery',       'CRUD de galería'),
  (9,  'Gestionar publicaciones',    'manage_posts',          'posts',         'CRUD de posts y noticias'),
  (10, 'Gestionar newsletter',       'manage_newsletter',     'newsletter',    'Suscriptores y campañas'),
  (11, 'Ver analíticas',             'view_analytics',        'analytics',     'Métricas y analíticas'),
  (12, 'Gestionar usuarios',         'manage_users',          'users',         'Gestión de usuarios y roles'),
  (13, 'Configurar plataforma',      'manage_settings',       'settings',      'Configuración del artista y del sistema'),
  (14, 'Comentar',                   'comment',               'community',     'Comentar en la comunidad'),
  (15, 'Reaccionar',                 'react',                 'community',     'Likes y follows'),
  (16, 'Comprar',                    'purchase',              'orders',        'Realizar pedidos y comprar boletas')
ON DUPLICATE KEY UPDATE name=VALUES(name), module=VALUES(module), description=VALUES(description);

-- ------------------------------------------------------------
-- PERMISOS POR ROL
-- ------------------------------------------------------------
-- superadmin: todos
INSERT IGNORE INTO role_permissions (role_id, permission_id)
  SELECT 1, id FROM permissions;

-- artist_admin: todo el contenido del artista
INSERT IGNORE INTO role_permissions (role_id, permission_id)
  SELECT 2, id FROM permissions WHERE slug IN (
    'view_dashboard','manage_songs','manage_albums','manage_events','manage_store',
    'manage_orders','manage_videos','manage_gallery','manage_posts','manage_newsletter',
    'view_analytics','manage_settings'
  );

-- user: comentar, reaccionar, comprar
INSERT IGNORE INTO role_permissions (role_id, permission_id)
  SELECT 3, id FROM permissions WHERE slug IN ('comment','react','purchase');

-- guest: ninguno (sólo lectura en rutas públicas)

-- ------------------------------------------------------------
-- ARTISTA PRINCIPAL
-- ------------------------------------------------------------
INSERT INTO artists (id, slug, stage_name, real_name, short_bio, bio, country, city, status)
VALUES (
  1,
  'cabaxx',
  'Cabaxx',
  'Carlos Andrés Bermúdez',
  'Artista urbano bogotano. Beats crudos, letras con barrio y una voz hecha en Bogotá D.C., Colombia.',
  'Cabaxx es un artista, productor y compositor bogotano que mezcla hip-hop, reggaetón y ritmos latinos. Su música refleja la vida en el sur de Bogotá, con letras crudas, honestas y un sonido callejero. Fundador de la plataforma Cabaxx para conectar directamente con sus fans.',
  'CO',
  'Bogotá D.C.',
  'active'
)
ON DUPLICATE KEY UPDATE stage_name=VALUES(stage_name), bio=VALUES(bio), status='active';

-- ------------------------------------------------------------
-- ENLACE ADMIN -> ARTISTA
-- (El admin@cabaxx.com insertado por database.sql se vincula aquí)
-- ------------------------------------------------------------
INSERT IGNORE INTO user_roles (user_id, role_id, artist_id)
SELECT u.id, 2, 1 FROM users u WHERE u.email = 'admin@cabaxx.com';

-- ------------------------------------------------------------
-- CONFIGURACIÓN POR DEFECTO DEL ARTISTA
-- ------------------------------------------------------------
INSERT INTO artist_settings (artist_id, currency, timezone, locale, allow_tips, allow_preorders)
VALUES (1, 'COP', 'America/Bogota', 'es_CO', 1, 1)
ON DUPLICATE KEY UPDATE currency='COP', timezone='America/Bogota', locale='es_CO';

INSERT INTO artist_themes (artist_id, primary_color, accent_color, bg_color, text_color, font_heading, font_body)
VALUES (1, '#0F0F0F', '#E11D48', '#0A0A0A', '#F5F5F5', 'Inter', 'Inter')
ON DUPLICATE KEY UPDATE accent_color=VALUES(accent_color);

INSERT INTO artist_seo (artist_id, site_title, meta_description, og_image_url, twitter_handle, default_locale)
VALUES (
  1,
  'Cabaxx — Plataforma oficial',
  'Plataforma oficial de Cabaxx, artista urbano bogotano. Música, eventos, tienda y comunidad en un solo lugar, hecho en Bogotá D.C., Colombia.',
  '',
  '@cabaxx',
  'es_CO'
)
ON DUPLICATE KEY UPDATE site_title=VALUES(site_title), default_locale='es_CO';

-- ------------------------------------------------------------
-- CATEGORÍAS DE PRODUCTO INICIALES
-- ------------------------------------------------------------
INSERT INTO product_categories (id, artist_id, name, slug, description, sort_order) VALUES
  (1, 1, 'Camisetas',  'camisetas',  'Camisetas y hoodies oficiales',  1),
  (2, 1, 'Accesorios', 'accesorios', 'Cadenas, gorras y más',          2),
  (3, 1, 'Vinilos',    'vinilos',    'Ediciones físicas en vinilo',    3),
  (4, 1, 'CD / Cassette', 'cd-cassette', 'Ediciones físicas en CD y cassette', 4)
ON DUPLICATE KEY UPDATE name=VALUES(name), sort_order=VALUES(sort_order);

-- ------------------------------------------------------------
-- CUPÓN DE BIENVENIDA
-- ------------------------------------------------------------
INSERT INTO coupons (artist_id, code, description, discount_type, discount_value, max_uses, status, starts_at, expires_at)
VALUES (1, 'BOGOTABIENVENIDA10', '10% de descuento en tu primera compra', 'percent', 10, NULL, 'active', NOW(), DATE_ADD(NOW(), INTERVAL 1 YEAR))
ON DUPLICATE KEY UPDATE status='active', discount_value=VALUES(discount_value);

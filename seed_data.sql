-- ============================================================
-- SEED DATA — Cabaxx
-- Datos iniciales necesarios para arrancar la plataforma.
-- Idempotente: usa ON DUPLICATE KEY UPDATE / INSERT IGNORE.
-- ============================================================
--
-- CONTRASEÑA DE PRUEBA (todos los usuarios): Cabaxx2026@
-- Hash bcrypt (cost 10) generado para esa contraseña.
-- Si la cambias, regenera el hash con:
--   node -e "console.log(require('bcrypt').hashSync('NuevaClave', 10))"
-- ============================================================

-- ------------------------------------------------------------
-- ROLES DEL SISTEMA
-- (id fijos: 1=superadmin, 2=artist_admin, 3=user, 4=guest)
-- ------------------------------------------------------------
INSERT INTO roles (id, name, slug, description) VALUES
  (1, 'Superadministrador',     'superadmin',   'Acceso total al sistema'),
  (2, 'Administrador del artista', 'artist_admin', 'Administra al artista Cabaxx'),
  (3, 'Usuario',                'user',         'Fan registrado en la plataforma'),
  (4, 'Invitado',               'guest',        'Visitante sin cuenta')
ON DUPLICATE KEY UPDATE name=VALUES(name), description=VALUES(description);

-- ------------------------------------------------------------
-- PERMISOS BASE
-- (id fijos para que role_permissions referencie de forma estable)
-- ------------------------------------------------------------
INSERT INTO permissions (id, name, slug, module, description) VALUES
  (1,  'Ver panel',                'view_dashboard',  'dashboard',  'Acceso al panel de control'),
  (2,  'Gestionar canciones',      'manage_songs',    'songs',      'CRUD de canciones'),
  (3,  'Gestionar álbumes',        'manage_albums',   'albums',     'CRUD de álbumes'),
  (4,  'Gestionar eventos',        'manage_events',   'events',     'CRUD de eventos y boletería'),
  (5,  'Gestionar tienda',         'manage_store',    'store',      'CRUD de productos, categorías y cupones'),
  (6,  'Gestionar pedidos',        'manage_orders',   'orders',     'Gestión de pedidos y pagos'),
  (7,  'Gestionar videos',         'manage_videos',   'videos',     'CRUD de videos'),
  (8,  'Gestionar galería',        'manage_gallery',  'gallery',    'CRUD de galería'),
  (9,  'Gestionar publicaciones',  'manage_posts',    'posts',      'CRUD de posts y noticias'),
  (10, 'Gestionar newsletter',     'manage_newsletter','newsletter','Suscriptores y campañas'),
  (11, 'Ver analíticas',           'view_analytics',  'analytics',  'Métricas y analíticas'),
  (12, 'Gestionar usuarios',       'manage_users',    'users',      'Gestión de usuarios y roles'),
  (13, 'Configurar plataforma',    'manage_settings', 'settings',   'Configuración del artista y del sistema'),
  (14, 'Comentar',                 'comment',         'community',  'Comentar en la comunidad'),
  (15, 'Reaccionar',               'react',           'community',  'Likes y follows'),
  (16, 'Comprar',                  'purchase',        'orders',     'Realizar pedidos y comprar boletas')
ON DUPLICATE KEY UPDATE name=VALUES(name), module=VALUES(module), description=VALUES(description);

-- ------------------------------------------------------------
-- PERMISOS POR ROL
-- ------------------------------------------------------------
-- superadmin: todos
INSERT IGNORE INTO role_permissions (role_id, permission_id) SELECT 1, id FROM permissions;

-- artist_admin: gestión completa del artista (sin manage_users)
INSERT IGNORE INTO role_permissions (role_id, permission_id)
  SELECT 2, id FROM permissions
  WHERE slug IN (
    'view_dashboard','manage_songs','manage_albums','manage_events','manage_store',
    'manage_orders','manage_videos','manage_gallery','manage_posts','manage_newsletter',
    'view_analytics','manage_settings'
  );

-- user: comentar, reaccionar, comprar
INSERT IGNORE INTO role_permissions (role_id, permission_id)
  SELECT 3, id FROM permissions WHERE slug IN ('comment','react','purchase');

-- guest: ninguno (sólo lectura en rutas públicas)

-- ------------------------------------------------------------
-- ARTISTA PRINCIPAL — Cabaxx
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
-- USUARIOS DE PRUEBA
-- 1 usuario por cada rol. Todos con la contraseña "Cabaxx2026@"
-- (hash bcrypt pre-generado con cost 10).
-- ------------------------------------------------------------
-- superadmin
INSERT INTO users (name, email, password_hash, status) VALUES
  ('Super Cabaxx',     'super@cabaxx.com',     '$2b$10$/9S4TqpXe1E9A3EmerdKTuJ1szei63mL8Azp5Vu4THkVZyr48NNS6', 'active')
ON DUPLICATE KEY UPDATE password_hash=VALUES(password_hash), status='active', name=VALUES(name);

-- artist_admin (administrador del artista Cabaxx)
-- Si database.sql ya creó admin@cabaxx.com con un hash placeholder,
-- ON DUPLICATE KEY UPDATE lo reemplaza por el hash real.
INSERT INTO users (name, email, password_hash, status) VALUES
  ('Cabaxx Admin',     'admin@cabaxx.com',     '$2b$10$/9S4TqpXe1E9A3EmerdKTuJ1szei63mL8Azp5Vu4THkVZyr48NNS6', 'active')
ON DUPLICATE KEY UPDATE password_hash=VALUES(password_hash), status='active', name=VALUES(name);

-- user (fan)
INSERT INTO users (name, email, password_hash, status) VALUES
  ('Fan Cabaxx',       'fan@cabaxx.com',       '$2b$10$/9S4TqpXe1E9A3EmerdKTuJ1szei63mL8Azp5Vu4THkVZyr48NNS6', 'active')
ON DUPLICATE KEY UPDATE password_hash=VALUES(password_hash), status='active', name=VALUES(name);

-- guest
INSERT INTO users (name, email, password_hash, status) VALUES
  ('Invitado Cabaxx',  'invitado@cabaxx.com',  '$2b$10$/9S4TqpXe1E9A3EmerdKTuJ1szei63mL8Azp5Vu4THkVZyr48NNS6', 'active')
ON DUPLICATE KEY UPDATE password_hash=VALUES(password_hash), status='active', name=VALUES(name);

-- ------------------------------------------------------------
-- ASIGNACIÓN DE ROLES
-- ------------------------------------------------------------
-- superadmin (alcance global)
INSERT IGNORE INTO user_roles (user_id, role_id, artist_id)
SELECT id, 1, NULL FROM users WHERE email = 'super@cabaxx.com';

-- admin del artista
INSERT IGNORE INTO user_roles (user_id, role_id, artist_id)
SELECT id, 2, 1 FROM users WHERE email = 'admin@cabaxx.com';

-- fan asociado al artista
INSERT IGNORE INTO user_roles (user_id, role_id, artist_id)
SELECT id, 3, 1 FROM users WHERE email = 'fan@cabaxx.com';

-- guest (sin alcance)
INSERT IGNORE INTO user_roles (user_id, role_id, artist_id)
SELECT id, 4, NULL FROM users WHERE email = 'invitado@cabaxx.com';

-- ------------------------------------------------------------
-- TEMA VISUAL DEL ARTISTA
-- (Tabla: artist_themes; 1 fila por artista, UNIQUE(artist_id))
-- ------------------------------------------------------------
INSERT INTO artist_themes (
  artist_id, primary_color, secondary_color, accent_color, font_heading, font_body, dark_mode_default
) VALUES (
  1, '#0F0F0F', '#F5F5F5', '#E11D48', 'Inter', 'Inter', 1
)
ON DUPLICATE KEY UPDATE accent_color=VALUES(accent_color), dark_mode_default=VALUES(dark_mode_default);

-- ------------------------------------------------------------
-- SEO DEL ARTISTA
-- (Tabla: artist_seo; 1 fila por artista, UNIQUE(artist_id))
-- ------------------------------------------------------------
INSERT INTO artist_seo (
  artist_id, meta_title, meta_description, og_image_url, robots
) VALUES (
  1,
  'Cabaxx — Plataforma oficial',
  'Plataforma oficial de Cabaxx, artista urbano bogotano. Música, eventos, tienda y comunidad en un solo lugar, hecho en Bogotá D.C., Colombia.',
  '',
  'index,follow'
)
ON DUPLICATE KEY UPDATE
  meta_title=VALUES(meta_title),
  meta_description=VALUES(meta_description),
  robots=VALUES(robots);

-- ------------------------------------------------------------
-- CONFIGURACIÓN CLAVE-VALOR DEL ARTISTA
-- (Tabla: artist_settings — UNIQUE(artist_id, `key`))
-- ------------------------------------------------------------
INSERT INTO artist_settings (artist_id, `key`, value, type) VALUES
  (1, 'currency',       'COP',              'string'),
  (1, 'timezone',       'America/Bogota',   'string'),
  (1, 'locale',         'es_CO',            'string'),
  (1, 'allow_tips',     'true',             'boolean'),
  (1, 'allow_preorders','true',             'boolean'),
  (1, 'plan',           'enterprise',       'string')
ON DUPLICATE KEY UPDATE value=VALUES(value), type=VALUES(type);

-- ------------------------------------------------------------
-- CATEGORÍAS DE PRODUCTO INICIALES
-- (Tabla: product_categories — UNIQUE(artist_id, slug))
-- ------------------------------------------------------------
INSERT INTO product_categories (id, artist_id, name, slug, description, sort_order) VALUES
  (1, 1, 'Camisetas',     'camisetas',     'Camisetas y hoodies oficiales',      1),
  (2, 1, 'Accesorios',    'accesorios',    'Cadenas, gorras y más',              2),
  (3, 1, 'Vinilos',       'vinilos',       'Ediciones físicas en vinilo',        3),
  (4, 1, 'CD / Cassette', 'cd-cassette',   'Ediciones físicas en CD y cassette', 4)
ON DUPLICATE KEY UPDATE name=VALUES(name), sort_order=VALUES(sort_order);

-- ------------------------------------------------------------
-- CUPÓN DE BIENVENIDA
-- (Tabla: coupons — UNIQUE(artist_id, code); columnas: type, value, max_uses, expires_at, status)
-- ------------------------------------------------------------
INSERT INTO coupons (artist_id, code, type, value, min_purchase, max_uses, status, expires_at)
VALUES (1, 'BOGOTABIENVENIDA10', 'percent', 10.00, 0.00, NULL, 'active', DATE_ADD(NOW(), INTERVAL 1 YEAR))
ON DUPLICATE KEY UPDATE status='active', value=VALUES(value), expires_at=VALUES(expires_at);

-- ------------------------------------------------------------
-- NOTA SOBRE LA GALERÍA
-- La tabla gallery_items queda vacía intencionalmente.
-- El frontend (src/pages/public/GalleryPage.jsx) detecta rows: []
-- y muestra un fallback con los assets bundleados en el build
-- (src/assets/gallery/* y src/assets/videos/*), evitando URLs
-- stale con hashes de Vite que cambian en cada build.
-- Para cargar contenido real, usa el panel admin:
--   /admin/galeria → subir imágenes / videos (quedan en Cloudinary).
-- ------------------------------------------------------------

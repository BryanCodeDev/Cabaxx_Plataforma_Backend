CREATE DATABASE IF NOT EXISTS map_platform CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE map_platform;

-- ============================================================
-- GRUPO 1 — SISTEMA Y AUTENTICACIÓN
-- ============================================================

CREATE TABLE users (
  id                BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  name             VARCHAR(150) NOT NULL,
  email            VARCHAR(191) NOT NULL,
  password_hash    VARCHAR(255) NOT NULL,
  avatar_url       VARCHAR(512) DEFAULT NULL,
  status           ENUM('active','inactive','banned') NOT NULL DEFAULT 'active',
  created_at       TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at       TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uk_users_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Usuarios del sistema (fans, admins, superadmin)';

CREATE TABLE roles (
  id          SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  name        VARCHAR(100) NOT NULL,
  slug        VARCHAR(100) NOT NULL,
  description VARCHAR(255) DEFAULT NULL,
  created_at  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uk_roles_slug (slug)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Roles del sistema (superadmin, artist_admin, user, guest)';

CREATE TABLE permissions (
  id          SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  name        VARCHAR(100) NOT NULL,
  slug        VARCHAR(120) NOT NULL,
  module      VARCHAR(80) NOT NULL,
  description VARCHAR(255) DEFAULT NULL,
  created_at  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uk_permissions_slug (slug),
  KEY idx_permissions_module (module)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Permisos granulares por módulo';

CREATE TABLE role_permissions (
  role_id       SMALLINT UNSIGNED NOT NULL,
  permission_id SMALLINT UNSIGNED NOT NULL,
  created_at    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (role_id, permission_id),
  KEY idx_rp_permission (permission_id),
  CONSTRAINT fk_rp_role FOREIGN KEY (role_id) REFERENCES roles (id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_rp_permission FOREIGN KEY (permission_id) REFERENCES permissions (id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Relación N:N roles-permisos';

CREATE TABLE refresh_tokens (
  id          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id     BIGINT UNSIGNED NOT NULL,
  token_hash  VARCHAR(255) NOT NULL,
  expires_at  TIMESTAMP NOT NULL,
  revoked_at  TIMESTAMP NULL DEFAULT NULL,
  ip_address  VARCHAR(45) DEFAULT NULL,
  user_agent  VARCHAR(512) DEFAULT NULL,
  created_at  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uk_refresh_token_hash (token_hash),
  KEY idx_refresh_user (user_id),
  KEY idx_refresh_expires (expires_at),
  CONSTRAINT fk_refresh_user FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Refresh tokens rotatorios para JWT';

CREATE TABLE sessions (
  id          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id     BIGINT UNSIGNED NOT NULL,
  token_hash  VARCHAR(255) NOT NULL,
  expires_at  TIMESTAMP NOT NULL,
  ip_address  VARCHAR(45) DEFAULT NULL,
  device_info VARCHAR(255) DEFAULT NULL,
  created_at  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_sessions_user (user_id),
  KEY idx_sessions_expires (expires_at),
  CONSTRAINT fk_session_user FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Sesiones activas del usuario';

CREATE TABLE password_resets (
  id          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  email       VARCHAR(191) NOT NULL,
  token_hash  VARCHAR(255) NOT NULL,
  expires_at  TIMESTAMP NOT NULL,
  used_at     TIMESTAMP NULL DEFAULT NULL,
  created_at  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_pr_email (email),
  KEY idx_pr_token (token_hash)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Tokens de reseteo de contraseña';

-- Índices adicionales Grupo 1
CREATE INDEX idx_users_status ON users (status);
CREATE INDEX idx_users_created ON users (created_at);

-- ============================================================
-- GRUPO 2 — ARTISTAS (núcleo del multi-tenant)
-- ============================================================

CREATE TABLE artists (
  id           BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  slug         VARCHAR(160) NOT NULL,
  stage_name   VARCHAR(150) NOT NULL,
  real_name    VARCHAR(150) DEFAULT NULL,
  bio          TEXT DEFAULT NULL,
  short_bio    VARCHAR(280) DEFAULT NULL,
  avatar_url   VARCHAR(512) DEFAULT NULL,
  banner_url   VARCHAR(512) DEFAULT NULL,
  genre        VARCHAR(80) DEFAULT NULL,
  country      CHAR(2) DEFAULT NULL COMMENT 'ISO 3166-1 alpha-2',
  city         VARCHAR(100) DEFAULT NULL,
  status       ENUM('active','pending','suspended') NOT NULL DEFAULT 'pending',
  created_at   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted_at   TIMESTAMP NULL DEFAULT NULL COMMENT 'Soft delete',
  PRIMARY KEY (id),
  UNIQUE KEY uk_artists_slug (slug)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Artistas inquilinos (tenant root)';

CREATE TABLE user_roles (
  id        BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id   BIGINT UNSIGNED NOT NULL,
  role_id   SMALLINT UNSIGNED NOT NULL,
  artist_id BIGINT UNSIGNED DEFAULT NULL COMMENT 'NULL = alcance global (superadmin)',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uk_ur_user_role_artist (user_id, role_id, artist_id),
  KEY idx_ur_role (role_id),
  KEY idx_ur_artist (artist_id),
  CONSTRAINT fk_ur_user FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_ur_role FOREIGN KEY (role_id) REFERENCES roles (id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_ur_artist FOREIGN KEY (artist_id) REFERENCES artists (id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Un usuario puede ser admin de varios artistas (multi-tenant)';

CREATE TABLE artist_social_links (
  id             BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  artist_id      BIGINT UNSIGNED NOT NULL,
  platform       VARCHAR(40) NOT NULL COMMENT 'spotify, youtube, instagram, etc.',
  url            VARCHAR(512) NOT NULL,
  followers_count INT UNSIGNED DEFAULT 0,
  last_synced_at TIMESTAMP NULL DEFAULT NULL,
  created_at     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_asl_artist (artist_id),
  KEY idx_asl_platform (artist_id, platform),
  CONSTRAINT fk_asl_artist FOREIGN KEY (artist_id) REFERENCES artists (id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Enlaces sociales por artista';

CREATE TABLE artist_themes (
  id               BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  artist_id        BIGINT UNSIGNED NOT NULL,
  primary_color    VARCHAR(7) DEFAULT '#111111',
  secondary_color  VARCHAR(7) DEFAULT '#ffffff',
  accent_color     VARCHAR(7) DEFAULT '#ff0000',
  font_heading     VARCHAR(60) DEFAULT 'Inter',
  font_body        VARCHAR(60) DEFAULT 'Inter',
  dark_mode_default TINYINT(1) NOT NULL DEFAULT 0,
  created_at       TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at       TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uk_theme_artist (artist_id),
  CONSTRAINT fk_theme_artist FOREIGN KEY (artist_id) REFERENCES artists (id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Tema visual por tenant';

CREATE TABLE artist_seo (
  id             BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  artist_id      BIGINT UNSIGNED NOT NULL,
  meta_title     VARCHAR(160) DEFAULT NULL,
  meta_description VARCHAR(300) DEFAULT NULL,
  keywords       VARCHAR(255) DEFAULT NULL,
  og_image_url   VARCHAR(512) DEFAULT NULL,
  schema_json    JSON DEFAULT NULL,
  robots         VARCHAR(60) DEFAULT 'index,follow',
  created_at     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uk_seo_artist (artist_id),
  CONSTRAINT fk_seo_artist FOREIGN KEY (artist_id) REFERENCES artists (id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Metadatos SEO por artista';

CREATE TABLE artist_settings (
  id         BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  artist_id  BIGINT UNSIGNED NOT NULL,
  `key`      VARCHAR(100) NOT NULL,
  value      TEXT DEFAULT NULL,
  type       ENUM('string','number','boolean','json') NOT NULL DEFAULT 'string',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uk_settings_artist_key (artist_id, `key`),
  KEY idx_settings_artist (artist_id),
  CONSTRAINT fk_settings_artist FOREIGN KEY (artist_id) REFERENCES artists (id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Configuraciones clave-valor por tenant';

CREATE TABLE artist_domains (
  id           BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  artist_id    BIGINT UNSIGNED NOT NULL,
  domain       VARCHAR(255) NOT NULL,
  ssl_status   ENUM('none','pending','active') NOT NULL DEFAULT 'none',
  is_primary   TINYINT(1) NOT NULL DEFAULT 0,
  created_at   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uk_domain (domain),
  KEY idx_domains_artist (artist_id),
  KEY idx_domains_primary (artist_id, is_primary),
  CONSTRAINT fk_domains_artist FOREIGN KEY (artist_id) REFERENCES artists (id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Dominios personalizados por tenant';

-- ============================================================
-- GRUPO 3 — MÚSICA
-- ============================================================

CREATE TABLE songs (
  id              BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  artist_id       BIGINT UNSIGNED NOT NULL,
  title           VARCHAR(200) NOT NULL,
  slug            VARCHAR(220) NOT NULL,
  duration_seconds INT UNSIGNED DEFAULT NULL,
  lyrics          LONGTEXT DEFAULT NULL,
  description     TEXT DEFAULT NULL,
  cover_url       VARCHAR(512) DEFAULT NULL,
  audio_url       VARCHAR(512) DEFAULT NULL,
  release_date    DATE DEFAULT NULL,
  status          ENUM('draft','published','archived') NOT NULL DEFAULT 'draft',
  plays_count     INT UNSIGNED NOT NULL DEFAULT 0,
  likes_count     INT UNSIGNED NOT NULL DEFAULT 0,
  is_explicit     TINYINT(1) NOT NULL DEFAULT 0,
  created_at      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted_at      TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uk_songs_artist_slug (artist_id, slug),
  KEY idx_songs_artist_status (artist_id, status),
  KEY idx_songs_release (artist_id, release_date),
  CONSTRAINT fk_song_artist FOREIGN KEY (artist_id) REFERENCES artists (id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Canciones multi-tenant';

CREATE TABLE albums (
  id           BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  artist_id    BIGINT UNSIGNED NOT NULL,
  title        VARCHAR(200) NOT NULL,
  slug         VARCHAR(220) NOT NULL,
  description  TEXT DEFAULT NULL,
  cover_url    VARCHAR(512) DEFAULT NULL,
  release_date DATE DEFAULT NULL,
  type         ENUM('single','ep','album') NOT NULL DEFAULT 'single',
  status       ENUM('draft','published','archived') NOT NULL DEFAULT 'draft',
  created_at   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted_at   TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uk_albums_artist_slug (artist_id, slug),
  KEY idx_albums_artist_status (artist_id, status),
  CONSTRAINT fk_album_artist FOREIGN KEY (artist_id) REFERENCES artists (id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Álbumes del artista';

CREATE TABLE album_songs (
  album_id     BIGINT UNSIGNED NOT NULL,
  song_id      BIGINT UNSIGNED NOT NULL,
  track_number SMALLINT UNSIGNED NOT NULL DEFAULT 1,
  disc_number  SMALLINT UNSIGNED NOT NULL DEFAULT 1,
  created_at   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (album_id, song_id),
  KEY idx_album_songs_song (song_id),
  CONSTRAINT fk_as_album FOREIGN KEY (album_id) REFERENCES albums (id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_as_song FOREIGN KEY (song_id) REFERENCES songs (id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Orden de canciones en álbum';

CREATE TABLE song_streaming_links (
  id        BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  song_id   BIGINT UNSIGNED NOT NULL,
  platform  VARCHAR(40) NOT NULL,
  url       VARCHAR(512) NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_ssl_song (song_id),
  KEY idx_ssl_song_platform (song_id, platform),
  CONSTRAINT fk_ssl_song FOREIGN KEY (song_id) REFERENCES songs (id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Enlaces de streaming por canción';

CREATE TABLE song_tags (
  id     BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  song_id BIGINT UNSIGNED NOT NULL,
  tag    VARCHAR(60) NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uk_song_tag (song_id, tag),
  KEY idx_songtags_tag (tag),
  CONSTRAINT fk_st_song FOREIGN KEY (song_id) REFERENCES songs (id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Etiquetas de canción';

-- ============================================================
-- GRUPO 4 — VIDEO Y MULTIMEDIA
-- ============================================================

CREATE TABLE videos (
  id                BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  artist_id         BIGINT UNSIGNED NOT NULL,
  title             VARCHAR(200) NOT NULL,
  slug              VARCHAR(220) NOT NULL,
  description       TEXT DEFAULT NULL,
  thumbnail_url     VARCHAR(512) DEFAULT NULL,
  video_url         VARCHAR(512) DEFAULT NULL,
  youtube_id        VARCHAR(60) DEFAULT NULL,
  duration_seconds  INT UNSIGNED DEFAULT NULL,
  views_count       INT UNSIGNED NOT NULL DEFAULT 0,
  status            ENUM('draft','published','archived') NOT NULL DEFAULT 'draft',
  published_at      TIMESTAMP NULL DEFAULT NULL,
  created_at        TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at        TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted_at        TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uk_videos_artist_slug (artist_id, slug),
  KEY idx_videos_artist_status (artist_id, status),
  KEY idx_videos_youtube (youtube_id),
  CONSTRAINT fk_video_artist FOREIGN KEY (artist_id) REFERENCES artists (id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Videoclips y multimedia';

CREATE TABLE gallery_items (
  id           BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  artist_id    BIGINT UNSIGNED NOT NULL,
  title        VARCHAR(200) DEFAULT NULL,
  description  TEXT DEFAULT NULL,
  file_url     VARCHAR(512) NOT NULL,
  file_type    ENUM('image','video') NOT NULL DEFAULT 'image',
  category     VARCHAR(60) DEFAULT 'general',
  sort_order   SMALLINT NOT NULL DEFAULT 0,
  status       ENUM('active','inactive') NOT NULL DEFAULT 'active',
  created_at   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted_at   TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (id),
  KEY idx_gallery_artist (artist_id),
  KEY idx_gallery_artist_cat (artist_id, category, sort_order),
  CONSTRAINT fk_gallery_artist FOREIGN KEY (artist_id) REFERENCES artists (id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Galería de imágenes/videos';

-- ============================================================
-- GRUPO 5 — EVENTOS
-- ============================================================

CREATE TABLE events (
  id             BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  artist_id      BIGINT UNSIGNED NOT NULL,
  title          VARCHAR(200) NOT NULL,
  slug           VARCHAR(220) NOT NULL,
  description    TEXT DEFAULT NULL,
  venue_name     VARCHAR(200) DEFAULT NULL,
  venue_address  VARCHAR(255) DEFAULT NULL,
  city           VARCHAR(100) DEFAULT NULL,
  country        CHAR(2) DEFAULT NULL,
  lat            DECIMAL(10,8) DEFAULT NULL,
  lng            DECIMAL(11,8) DEFAULT NULL,
  start_datetime DATETIME NOT NULL,
  end_datetime   DATETIME DEFAULT NULL,
  timezone       VARCHAR(64) NOT NULL DEFAULT 'America/Bogota',
  banner_url     VARCHAR(512) DEFAULT NULL,
  status         ENUM('draft','published','cancelled','sold_out') NOT NULL DEFAULT 'draft',
  is_free        TINYINT(1) NOT NULL DEFAULT 0,
  capacity       INT UNSIGNED DEFAULT NULL,
  created_at     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted_at     TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uk_events_artist_slug (artist_id, slug),
  KEY idx_events_artist_status (artist_id, status),
  KEY idx_events_start (artist_id, start_datetime),
  KEY idx_events_city (artist_id, city),
  CONSTRAINT fk_event_artist FOREIGN KEY (artist_id) REFERENCES artists (id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Eventos y conciertos';

CREATE TABLE tickets (
  id            BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  event_id      BIGINT UNSIGNED NOT NULL,
  artist_id     BIGINT UNSIGNED NOT NULL,
  name          VARCHAR(150) NOT NULL,
  description   TEXT DEFAULT NULL,
  price         DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  currency      CHAR(3) NOT NULL DEFAULT 'USD',
  quantity_total INT UNSIGNED NOT NULL DEFAULT 0,
  quantity_sold  INT UNSIGNED NOT NULL DEFAULT 0,
  sale_start_at  DATETIME DEFAULT NULL,
  sale_end_at    DATETIME DEFAULT NULL,
  status        ENUM('active','inactive','sold_out') NOT NULL DEFAULT 'active',
  created_at    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted_at    TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (id),
  KEY idx_tickets_event (event_id),
  KEY idx_tickets_artist (artist_id),
  CONSTRAINT fk_ticket_event FOREIGN KEY (event_id) REFERENCES events (id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_ticket_artist FOREIGN KEY (artist_id) REFERENCES artists (id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Tipos de ticket por evento';

CREATE TABLE ticket_purchases (
  id          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id     BIGINT UNSIGNED NOT NULL,
  ticket_id   BIGINT UNSIGNED NOT NULL,
  quantity    SMALLINT UNSIGNED NOT NULL DEFAULT 1,
  total_price DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  status      ENUM('pending','paid','cancelled','used') NOT NULL DEFAULT 'pending',
  qr_code     VARCHAR(255) DEFAULT NULL,
  used_at     TIMESTAMP NULL DEFAULT NULL,
  created_at  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_tp_user (user_id),
  KEY idx_tp_ticket (ticket_id),
  KEY idx_tp_status (status),
  CONSTRAINT fk_tp_user FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_tp_ticket FOREIGN KEY (ticket_id) REFERENCES tickets (id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Compras de tickets';

-- ============================================================
-- GRUPO 6 — TIENDA Y ECOMMERCE
-- ============================================================

CREATE TABLE product_categories (
  id          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  artist_id   BIGINT UNSIGNED NOT NULL,
  name        VARCHAR(150) NOT NULL,
  slug        VARCHAR(170) NOT NULL,
  description TEXT DEFAULT NULL,
  image_url   VARCHAR(512) DEFAULT NULL,
  parent_id   BIGINT UNSIGNED DEFAULT NULL,
  sort_order  SMALLINT NOT NULL DEFAULT 0,
  created_at  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted_at  TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uk_cat_artist_slug (artist_id, slug),
  KEY idx_cat_artist_parent (artist_id, parent_id, sort_order),
  CONSTRAINT fk_cat_artist FOREIGN KEY (artist_id) REFERENCES artists (id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_cat_parent FOREIGN KEY (parent_id) REFERENCES product_categories (id) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Categorías de productos (auto-referencial)';

CREATE TABLE products (
  id              BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  artist_id       BIGINT UNSIGNED NOT NULL,
  category_id     BIGINT UNSIGNED DEFAULT NULL,
  name            VARCHAR(200) NOT NULL,
  slug            VARCHAR(220) NOT NULL,
  description     TEXT DEFAULT NULL,
  price           DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  compare_at_price DECIMAL(10,2) DEFAULT NULL,
  currency        CHAR(3) NOT NULL DEFAULT 'USD',
  sku             VARCHAR(100) DEFAULT NULL,
  stock_quantity  INT UNSIGNED NOT NULL DEFAULT 0,
  type            ENUM('physical','digital','ticket') NOT NULL DEFAULT 'physical',
  cover_url       VARCHAR(512) DEFAULT NULL,
  status          ENUM('draft','active','archived') NOT NULL DEFAULT 'draft',
  weight_grams    INT UNSIGNED DEFAULT NULL,
  created_at      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted_at      TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uk_products_artist_slug (artist_id, slug),
  KEY idx_products_artist_status (artist_id, status),
  KEY idx_products_category (category_id),
  CONSTRAINT fk_prod_artist FOREIGN KEY (artist_id) REFERENCES artists (id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_prod_category FOREIGN KEY (category_id) REFERENCES product_categories (id) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Productos de la tienda';

CREATE TABLE product_images (
  id         BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  product_id BIGINT UNSIGNED NOT NULL,
  url        VARCHAR(512) NOT NULL,
  alt_text   VARCHAR(160) DEFAULT NULL,
  sort_order SMALLINT NOT NULL DEFAULT 0,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_pi_product (product_id, sort_order),
  CONSTRAINT fk_pi_product FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Imágenes de producto';

CREATE TABLE product_variants (
  id             BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  product_id     BIGINT UNSIGNED NOT NULL,
  name           VARCHAR(150) NOT NULL,
  options_json   JSON DEFAULT NULL,
  price          DECIMAL(10,2) DEFAULT NULL,
  sku            VARCHAR(100) DEFAULT NULL,
  stock_quantity INT UNSIGNED NOT NULL DEFAULT 0,
  created_at     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_pv_product (product_id),
  CONSTRAINT fk_pv_product FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Variantes de producto';

CREATE TABLE coupons (
  id           BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  artist_id    BIGINT UNSIGNED NOT NULL,
  code         VARCHAR(50) NOT NULL,
  type         ENUM('percent','fixed') NOT NULL DEFAULT 'percent',
  value        DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  min_purchase DECIMAL(10,2) DEFAULT 0.00,
  max_uses     INT UNSIGNED DEFAULT NULL,
  uses_count   INT UNSIGNED NOT NULL DEFAULT 0,
  expires_at   TIMESTAMP NULL DEFAULT NULL,
  status       ENUM('active','inactive','expired') NOT NULL DEFAULT 'active',
  created_at   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted_at   TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uk_coupons_artist_code (artist_id, code),
  KEY idx_coupons_artist (artist_id),
  CONSTRAINT fk_coupon_artist FOREIGN KEY (artist_id) REFERENCES artists (id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Cupones de descuento';

CREATE TABLE orders (
  id          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id     BIGINT UNSIGNED DEFAULT NULL,
  artist_id   BIGINT UNSIGNED NOT NULL,
  status      ENUM('pending','paid','processing','shipped','delivered','cancelled','refunded') NOT NULL DEFAULT 'pending',
  subtotal    DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  discount    DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  shipping    DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  tax         DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  total       DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  currency    CHAR(3) NOT NULL DEFAULT 'USD',
  coupon_id   BIGINT UNSIGNED DEFAULT NULL,
  notes       TEXT DEFAULT NULL,
  created_at  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted_at  TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (id),
  KEY idx_orders_artist (artist_id),
  KEY idx_orders_user (user_id),
  KEY idx_orders_status (artist_id, status),
  KEY idx_orders_created (artist_id, created_at),
  CONSTRAINT fk_order_user FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT fk_order_artist FOREIGN KEY (artist_id) REFERENCES artists (id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_order_coupon FOREIGN KEY (coupon_id) REFERENCES coupons (id) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Pedidos de la tienda';

CREATE TABLE order_items (
  id            BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  order_id      BIGINT UNSIGNED NOT NULL,
  product_id    BIGINT UNSIGNED DEFAULT NULL,
  variant_id    BIGINT UNSIGNED DEFAULT NULL,
  quantity      SMALLINT UNSIGNED NOT NULL DEFAULT 1,
  unit_price    DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  total_price   DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  snapshot_json JSON DEFAULT NULL COMMENT 'Copia del producto al momento de la compra',
  created_at    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_oi_order (order_id),
  KEY idx_oi_product (product_id),
  CONSTRAINT fk_oi_order FOREIGN KEY (order_id) REFERENCES orders (id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_oi_product FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT fk_oi_variant FOREIGN KEY (variant_id) REFERENCES product_variants (id) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Items de pedido';

CREATE TABLE order_shipping (
  id              BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  order_id        BIGINT UNSIGNED NOT NULL,
  carrier         VARCHAR(80) DEFAULT NULL,
  tracking_number VARCHAR(120) DEFAULT NULL,
  status          ENUM('pending','in_transit','delivered','returned') NOT NULL DEFAULT 'pending',
  shipped_at      TIMESTAMP NULL DEFAULT NULL,
  delivered_at    TIMESTAMP NULL DEFAULT NULL,
  address_json    JSON DEFAULT NULL,
  created_at      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uk_os_order (order_id),
  CONSTRAINT fk_os_order FOREIGN KEY (order_id) REFERENCES orders (id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Envíos de pedidos';

CREATE TABLE payments (
  id            BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  order_id      BIGINT UNSIGNED NOT NULL,
  user_id       BIGINT UNSIGNED DEFAULT NULL,
  artist_id     BIGINT UNSIGNED NOT NULL,
  provider      VARCHAR(40) NOT NULL DEFAULT 'stripe',
  provider_tx_id VARCHAR(255) DEFAULT NULL,
  amount        DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  currency      CHAR(3) NOT NULL DEFAULT 'USD',
  status        ENUM('pending','succeeded','failed','refunded') NOT NULL DEFAULT 'pending',
  response_json JSON DEFAULT NULL,
  paid_at       TIMESTAMP NULL DEFAULT NULL,
  created_at    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_pay_order (order_id),
  KEY idx_pay_artist (artist_id),
  KEY idx_pay_user (user_id),
  KEY idx_pay_status (artist_id, status),
  CONSTRAINT fk_pay_order FOREIGN KEY (order_id) REFERENCES orders (id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_pay_user FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT fk_pay_artist FOREIGN KEY (artist_id) REFERENCES artists (id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Pagos de pedidos';

-- ============================================================
-- GRUPO 7 — COMUNIDAD
-- ============================================================

CREATE TABLE posts (
  id           BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  artist_id    BIGINT UNSIGNED NOT NULL,
  user_id      BIGINT UNSIGNED DEFAULT NULL,
  type         ENUM('blog','news','update') NOT NULL DEFAULT 'blog',
  title        VARCHAR(200) NOT NULL,
  slug         VARCHAR(220) NOT NULL,
  content      LONGTEXT NOT NULL,
  excerpt      VARCHAR(400) DEFAULT NULL,
  cover_url    VARCHAR(512) DEFAULT NULL,
  status       ENUM('draft','published','archived') NOT NULL DEFAULT 'draft',
  published_at TIMESTAMP NULL DEFAULT NULL,
  views_count  INT UNSIGNED NOT NULL DEFAULT 0,
  created_at   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted_at   TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uk_posts_artist_slug (artist_id, slug),
  KEY idx_posts_artist_type (artist_id, type, status),
  KEY idx_posts_published (artist_id, published_at),
  CONSTRAINT fk_post_artist FOREIGN KEY (artist_id) REFERENCES artists (id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_post_user FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Blog, noticias y updates';

CREATE TABLE post_tags (
  id      BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  post_id BIGINT UNSIGNED NOT NULL,
  tag     VARCHAR(60) NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uk_post_tag (post_id, tag),
  KEY idx_posttags_tag (tag),
  CONSTRAINT fk_pt_post FOREIGN KEY (post_id) REFERENCES posts (id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Etiquetas de posts';

CREATE TABLE comments (
  id              BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id         BIGINT UNSIGNED NOT NULL,
  artist_id       BIGINT UNSIGNED NOT NULL,
  reference_id    BIGINT UNSIGNED NOT NULL COMMENT 'id de post/song/video',
  reference_type  ENUM('post','song','video','event') NOT NULL,
  content         TEXT NOT NULL,
  status          ENUM('pending','approved','spam') NOT NULL DEFAULT 'pending',
  parent_id       BIGINT UNSIGNED DEFAULT NULL,
  created_at      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted_at      TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (id),
  KEY idx_comments_ref (reference_type, reference_id),
  KEY idx_comments_artist (artist_id),
  KEY idx_comments_parent (parent_id),
  CONSTRAINT fk_comment_user FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_comment_artist FOREIGN KEY (artist_id) REFERENCES artists (id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_comment_parent FOREIGN KEY (parent_id) REFERENCES comments (id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Comentarios polimórficos';

CREATE TABLE likes (
  id              BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id         BIGINT UNSIGNED NOT NULL,
  artist_id       BIGINT UNSIGNED NOT NULL,
  reference_id    BIGINT UNSIGNED NOT NULL,
  reference_type  ENUM('post','song','video','album','event') NOT NULL,
  created_at      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uk_likes_user_ref (user_id, reference_type, reference_id),
  KEY idx_likes_ref (reference_type, reference_id),
  CONSTRAINT fk_like_user FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_like_artist FOREIGN KEY (artist_id) REFERENCES artists (id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Me gusta polimórficos';

CREATE TABLE follows (
  id         BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id    BIGINT UNSIGNED NOT NULL,
  artist_id  BIGINT UNSIGNED NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uk_follows_user_artist (user_id, artist_id),
  KEY idx_follows_artist (artist_id),
  CONSTRAINT fk_follow_user FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_follow_artist FOREIGN KEY (artist_id) REFERENCES artists (id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Seguidores de artistas';

CREATE TABLE newsletter_subscribers (
  id              BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  artist_id       BIGINT UNSIGNED NOT NULL,
  email           VARCHAR(191) NOT NULL,
  name            VARCHAR(150) DEFAULT NULL,
  status          ENUM('subscribed','unsubscribed','bounced') NOT NULL DEFAULT 'subscribed',
  subscribed_at   TIMESTAMP NULL DEFAULT NULL,
  unsubscribed_at TIMESTAMP NULL DEFAULT NULL,
  source          VARCHAR(60) DEFAULT 'website',
  created_at      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uk_news_artist_email (artist_id, email),
  KEY idx_news_artist_status (artist_id, status),
  CONSTRAINT fk_news_artist FOREIGN KEY (artist_id) REFERENCES artists (id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Suscriptores de newsletter';

CREATE TABLE newsletter_campaigns (
  id             BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  artist_id      BIGINT UNSIGNED NOT NULL,
  subject        VARCHAR(200) NOT NULL,
  content_html   LONGTEXT NOT NULL,
  sent_at        TIMESTAMP NULL DEFAULT NULL,
  total_sent     INT UNSIGNED NOT NULL DEFAULT 0,
  total_opened   INT UNSIGNED NOT NULL DEFAULT 0,
  total_clicked  INT UNSIGNED NOT NULL DEFAULT 0,
  created_at     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_newsc_artist (artist_id),
  CONSTRAINT fk_newsc_artist FOREIGN KEY (artist_id) REFERENCES artists (id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Campañas de newsletter';

-- ============================================================
-- GRUPO 8 — NOTIFICACIONES Y LOGS
-- ============================================================

CREATE TABLE notifications (
  id         BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id    BIGINT UNSIGNED NOT NULL,
  artist_id  BIGINT UNSIGNED NOT NULL,
  type       VARCHAR(60) NOT NULL,
  title      VARCHAR(200) NOT NULL,
  body       TEXT DEFAULT NULL,
  data_json  JSON DEFAULT NULL,
  read_at    TIMESTAMP NULL DEFAULT NULL,
  sent_at    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_notif_user (user_id, read_at),
  KEY idx_notif_artist (artist_id),
  CONSTRAINT fk_notif_user FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_notif_artist FOREIGN KEY (artist_id) REFERENCES artists (id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Notificaciones in-app';

CREATE TABLE audit_logs (
  id              BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id         BIGINT UNSIGNED DEFAULT NULL,
  artist_id       BIGINT UNSIGNED DEFAULT NULL,
  action          VARCHAR(60) NOT NULL,
  entity_type     VARCHAR(60) NOT NULL,
  entity_id       BIGINT UNSIGNED DEFAULT NULL,
  old_values_json JSON DEFAULT NULL,
  new_values_json JSON DEFAULT NULL,
  ip_address      VARCHAR(45) DEFAULT NULL,
  user_agent      VARCHAR(512) DEFAULT NULL,
  created_at      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_audit_entity (entity_type, entity_id),
  KEY idx_audit_artist (artist_id),
  KEY idx_audit_user (user_id),
  CONSTRAINT fk_audit_user FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT fk_audit_artist FOREIGN KEY (artist_id) REFERENCES artists (id) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Traza de auditoría';

CREATE TABLE error_logs (
  id            BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  level         ENUM('debug','info','warning','error','critical') NOT NULL DEFAULT 'error',
  message       VARCHAR(1000) NOT NULL,
  stack_trace   LONGTEXT DEFAULT NULL,
  context_json  JSON DEFAULT NULL,
  resolved_at   TIMESTAMP NULL DEFAULT NULL,
  created_at    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_error_level (level),
  KEY idx_error_created (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Logs de errores de la aplicación';

-- ============================================================
-- GRUPO 9 — ANALÍTICAS
-- ============================================================

CREATE TABLE page_views (
  id           BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  artist_id    BIGINT UNSIGNED NOT NULL,
  user_id      BIGINT UNSIGNED DEFAULT NULL,
  session_id   VARCHAR(64) DEFAULT NULL,
  page_url     VARCHAR(512) NOT NULL,
  referrer     VARCHAR(512) DEFAULT NULL,
  device_type  VARCHAR(40) DEFAULT NULL,
  country      CHAR(2) DEFAULT NULL,
  created_at   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_pv_artist (artist_id, created_at),
  KEY idx_pv_session (session_id),
  CONSTRAINT fk_pv_artist FOREIGN KEY (artist_id) REFERENCES artists (id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_pv_user FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Vistas de página (alta cardinalidad)';

CREATE TABLE events_tracking (
  id            BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  artist_id     BIGINT UNSIGNED NOT NULL,
  user_id       BIGINT UNSIGNED DEFAULT NULL,
  event_name    VARCHAR(80) NOT NULL,
  properties_json JSON DEFAULT NULL,
  created_at    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_et_artist_event (artist_id, event_name, created_at),
  CONSTRAINT fk_et_artist FOREIGN KEY (artist_id) REFERENCES artists (id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_et_user FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Eventos analíticos personalizados';

CREATE TABLE song_plays (
  id                       BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  song_id                  BIGINT UNSIGNED NOT NULL,
  artist_id                BIGINT UNSIGNED NOT NULL,
  user_id                  BIGINT UNSIGNED DEFAULT NULL,
  source                   VARCHAR(40) DEFAULT 'web',
  duration_played_seconds  INT UNSIGNED DEFAULT 0,
  completed                TINYINT(1) NOT NULL DEFAULT 0,
  created_at               TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_sp_song (song_id, created_at),
  KEY idx_sp_artist (artist_id, created_at),
  CONSTRAINT fk_sp_song FOREIGN KEY (song_id) REFERENCES songs (id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_sp_artist FOREIGN KEY (artist_id) REFERENCES artists (id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_sp_user FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Reproducciones de canciones';

SET FOREIGN_KEY_CHECKS = 1;

-- ============================================================
-- DATOS INICIALES (SEED)
-- ============================================================

-- Roles
INSERT INTO roles (name, slug, description) VALUES
  ('Super Admin', 'superadmin', 'Control total del SaaS, todos los artistas'),
  ('Artist Admin', 'artist_admin', 'Administrador del artista (dueño/gestor)'),
  ('User', 'user', 'Fan con cuenta (carrito, newsletter, comentarios)'),
  ('Guest', 'guest', 'Visitante público sin sesión');

-- Permisos por módulo
INSERT INTO permissions (name, slug, module, description) VALUES
  ('Ver dashboard', 'dashboard.view', 'dashboard', 'Acceder al panel del artista'),
  ('Editar perfil artista', 'artist.update', 'artist', 'Editar datos del artista'),
  ('Gestionar canciones', 'songs.manage', 'songs', 'CRUD de canciones'),
  ('Gestionar álbumes', 'albums.manage', 'albums', 'CRUD de álbumes'),
  ('Gestionar videos', 'videos.manage', 'videos', 'CRUD de videos'),
  ('Gestionar eventos', 'events.manage', 'events', 'CRUD de eventos'),
  ('Gestionar tienda', 'store.manage', 'store', 'CRUD de productos y pedidos'),
  ('Gestionar blog', 'blog.manage', 'blog', 'CRUD de posts'),
  ('Gestionar galería', 'gallery.manage', 'gallery', 'CRUD de galería'),
  ('Gestionar newsletter', 'newsletter.manage', 'newsletter', 'Suscriptores y campañas'),
  ('Ver analíticas', 'analytics.view', 'analytics', 'Métricas del artista'),
  ('Admin SaaS', 'saas.admin', 'saas', 'Gestión cross-artist (solo superadmin)');

-- Permisos para superadmin (todos)
INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r CROSS JOIN permissions p WHERE r.slug = 'superadmin';

-- Permisos para artist_admin (todo excepto saas.admin)
INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r CROSS JOIN permissions p
WHERE r.slug = 'artist_admin' AND p.slug != 'saas.admin';

-- Permiso de ver dashboard para user (solo lectura de su propio perfil/órdenes, ejemplo mínimo)
INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r CROSS JOIN permissions p
WHERE r.slug = 'user' AND p.slug IN ('analytics.view');

-- Artista inicial: Cabitaxx
INSERT INTO artists (slug, stage_name, real_name, bio, short_bio, genre, country, city, status)
VALUES (
  'cabitaxx',
  'Cabitaxx',
  'Juan Esteban Cabas Torres',
  'Cabitaxx es el proyecto musical de Juan Esteban Cabas Torres, artista multi-instrumentista y productor.',
  'Artista musical urbano y experimental.',
  'Latin Urban',
  'CO',
  'Bogotá',
  'active'
);

INSERT INTO users (name, email, password_hash, status)
VALUES (
  'MasterCode Admin',
  'admin@mastercode.co',
  '$2b$10$g6BHkvGtip9t2rYiW1xqWOqhO1IaLI0578q0fB2P7lDX8UKLftfaW',
  'active'
);

-- Asignar rol superadmin al usuario (alcance global: artist_id NULL)
INSERT INTO user_roles (user_id, role_id, artist_id)
SELECT u.id, r.id, NULL
FROM users u, roles r
WHERE u.email = 'admin@mastercode.co' AND r.slug = 'superadmin';

-- Relación artist_admin para Cabitaxx (se asigna al crear el usuario dueño real desde el backend)
-- Ejemplo (comentado): INSERT INTO user_roles (user_id, role_id, artist_id)
--   SELECT u.id, r.id, a.id FROM users u, roles r, artists a
--   WHERE u.email='juan@cabitaxx.com' AND r.slug='artist_admin' AND a.slug='cabitaxx';

-- ============================================================
-- DIAGRAMA DE RELACIONES (FK)
-- ============================================================
-- users 1──┐
--          ├─< user_roles >── roles
--          ├─< user_roles >── artists (alcance multi-tenant)
--          ├─< refresh_tokens
--          ├─< sessions
-- roles 1──< role_permissions >── permissions
--
-- artists 1──< artist_social_links
-- artists 1──< artist_themes
-- artists 1──< artist_seo
-- artists 1──< artist_settings
-- artists 1──< artist_domains
-- artists 1──< songs, albums, videos, gallery_items, events,
--              tickets, product_categories, products, coupons,
--              orders, posts, comments, likes, follows,
--              newsletter_subscribers, newsletter_campaigns,
--              notifications, page_views, events_tracking
-- artists 1──< user_roles (artist_id)
--
-- albums 1──< album_songs >── songs
-- songs  1──< song_streaming_links
-- songs  1──< song_tags
-- songs  1──< song_plays, likes, comments
-- events 1──< tickets
-- tickets 1──< ticket_purchases >── users
-- product_categories 1──< product_categories (parent_id, self)
-- product_categories 1──< products
-- products 1──< product_images, product_variants, order_items
-- coupons  1──< orders
-- orders   1──< order_items, order_shipping, payments
-- users    1──< orders, payments, comments, likes, follows,
--              ticket_purchases, notifications
-- posts    1──< post_tags, comments, likes

-- ============================================================
-- LISTA DE FK CON ON DELETE / ON UPDATE
-- ============================================================
-- role_permissions.role_id        -> roles.id            CASCADE / CASCADE
-- role_permissions.permission_id  -> permissions.id      CASCADE / CASCADE
-- user_roles.user_id              -> users.id            CASCADE / CASCADE
-- user_roles.role_id              -> roles.id            CASCADE / CASCADE
-- user_roles.artist_id            -> artists.id          CASCADE / CASCADE
-- refresh_tokens.user_id          -> users.id            CASCADE / CASCADE
-- sessions.user_id                -> users.id            CASCADE / CASCADE
-- artist_social_links.artist_id   -> artists.id          CASCADE / CASCADE
-- artist_themes.artist_id         -> artists.id          CASCADE / CASCADE
-- artist_seo.artist_id            -> artists.id          CASCADE / CASCADE
-- artist_settings.artist_id       -> artists.id          CASCADE / CASCADE
-- artist_domains.artist_id        -> artists.id          CASCADE / CASCADE
-- songs.artist_id                 -> artists.id          CASCADE / CASCADE
-- albums.artist_id                -> artists.id          CASCADE / CASCADE
-- album_songs.album_id            -> albums.id           CASCADE / CASCADE
-- album_songs.song_id             -> songs.id            CASCADE / CASCADE
-- song_streaming_links.song_id    -> songs.id            CASCADE / CASCADE
-- song_tags.song_id               -> songs.id            CASCADE / CASCADE
-- videos.artist_id                -> artists.id          CASCADE / CASCADE
-- gallery_items.artist_id         -> artists.id          CASCADE / CASCADE
-- events.artist_id                -> artists.id          CASCADE / CASCADE
-- tickets.event_id                -> events.id           CASCADE / CASCADE
-- tickets.artist_id               -> artists.id          CASCADE / CASCADE
-- ticket_purchases.user_id        -> users.id            CASCADE / CASCADE
-- ticket_purchases.ticket_id      -> tickets.id          CASCADE / CASCADE
-- product_categories.artist_id    -> artists.id          CASCADE / CASCADE
-- product_categories.parent_id    -> product_categories.id SET NULL / CASCADE
-- products.artist_id              -> artists.id          CASCADE / CASCADE
-- products.category_id            -> product_categories.id SET NULL / CASCADE
-- product_images.product_id       -> products.id         CASCADE / CASCADE
-- product_variants.product_id     -> products.id         CASCADE / CASCADE
-- coupons.artist_id               -> artists.id          CASCADE / CASCADE
-- orders.user_id                  -> users.id            SET NULL / CASCADE
-- orders.artist_id                -> artists.id          CASCADE / CASCADE
-- orders.coupon_id                -> coupons.id          SET NULL / CASCADE
-- order_items.order_id            -> orders.id           CASCADE / CASCADE
-- order_items.product_id          -> products.id         SET NULL / CASCADE
-- order_items.variant_id          -> product_variants.id SET NULL / CASCADE
-- order_shipping.order_id         -> orders.id           CASCADE / CASCADE
-- payments.order_id               -> orders.id           CASCADE / CASCADE
-- payments.user_id                -> users.id            SET NULL / CASCADE
-- payments.artist_id              -> artists.id          CASCADE / CASCADE
-- posts.artist_id                 -> artists.id          CASCADE / CASCADE
-- posts.user_id                   -> users.id            SET NULL / CASCADE
-- post_tags.post_id               -> posts.id            CASCADE / CASCADE
-- comments.user_id                -> users.id            CASCADE / CASCADE
-- comments.artist_id              -> artists.id          CASCADE / CASCADE
-- comments.parent_id              -> comments.id         CASCADE / CASCADE
-- likes.user_id                   -> users.id            CASCADE / CASCADE
-- likes.artist_id                 -> artists.id          CASCADE / CASCADE
-- follows.user_id                 -> users.id            CASCADE / CASCADE
-- follows.artist_id               -> artists.id          CASCADE / CASCADE
-- newsletter_subscribers.artist_id-> artists.id          CASCADE / CASCADE
-- newsletter_campaigns.artist_id  -> artists.id          CASCADE / CASCADE
-- notifications.user_id           -> users.id            CASCADE / CASCADE
-- notifications.artist_id         -> artists.id          CASCADE / CASCADE
-- audit_logs.user_id              -> users.id            SET NULL / CASCADE
-- audit_logs.artist_id            -> artists.id          SET NULL / CASCADE
-- page_views.artist_id            -> artists.id          CASCADE / CASCADE
-- page_views.user_id              -> users.id            SET NULL / CASCADE
-- events_tracking.artist_id       -> artists.id          CASCADE / CASCADE
-- events_tracking.user_id         -> users.id            SET NULL / CASCADE
-- song_plays.song_id              -> songs.id            CASCADE / CASCADE
-- song_plays.artist_id            -> artists.id          CASCADE / CASCADE
-- song_plays.user_id              -> users.id            SET NULL / CASCADE

-- ============================================================
-- NOTAS DE DISEÑO
-- ============================================================
-- 1. Multi-tenant: toda tabla de contenido posee artist_id como FK a artists.
-- 2. Soft delete: tablas de estado/entidad usan deleted_at (NULL = activo).
-- 3. ENUM solo para valores estables (status, type, currency, etc.).
-- 4. Relaciones polimórficas (comments, likes) usan reference_type + reference_id.
-- 5. auditoría y analíticas usan JSON para flexibilidad sin esquema rígido.
-- 6. Multi-tenant: toda tabla de contenido posee artist_id como FK a artists.
-- 7. Soft delete: tablas de estado/entidad usan deleted_at (NULL = activo).

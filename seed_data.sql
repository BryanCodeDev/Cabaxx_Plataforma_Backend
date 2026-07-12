USE map_platform;

SET SQL_SAFE_UPDATES = 0;

INSERT INTO artists (slug, stage_name, real_name, bio, short_bio, genre, country, city, status)
VALUES ('cabaxx','Cabitaxx','Cabitaxx',NULL,NULL,NULL,'CO','Medellín','active')
ON DUPLICATE KEY UPDATE id=id;

SET @cabaxx = (SELECT id FROM artists WHERE slug = 'cabaxx');

INSERT INTO users (name, email, password_hash, status)
VALUES ('Cabaxx Admin','admin@cabaxx.com','$2b$10$g6BHkvGtip9t2rYiW1xqWOqhO1IaLI0578q0fB2P7lDX8UKLftfaW','active')
ON DUPLICATE KEY UPDATE id=id;
SET @super = LAST_INSERT_ID();

INSERT INTO user_roles (user_id, role_id, artist_id)
VALUES (@super, (SELECT id FROM roles WHERE slug='superadmin'), NULL)
ON DUPLICATE KEY UPDATE user_id=user_id;

INSERT INTO users (name, email, password_hash, status)
VALUES ('Cabaxx','cabaxx@cabaxx.com','$2b$10$g6BHkvGtip9t2rYiW1xqWOqhO1IaLI0578q0fB2P7lDX8UKLftfaW','active')
ON DUPLICATE KEY UPDATE id=id;
SET @artista = LAST_INSERT_ID();

INSERT INTO user_roles (user_id, role_id, artist_id)
VALUES (@artista, (SELECT id FROM roles WHERE slug='artist_admin'), @cabaxx)
ON DUPLICATE KEY UPDATE user_id=user_id;

INSERT INTO users (name, email, password_hash, status)
VALUES ('Fan Demo','fan@cabaxx.com','$2b$10$XH3XRkifdZKdwGCtUZnA3OuNxn5SkFnfOT.fFpJEMmvj3tTo1S6La','active')
ON DUPLICATE KEY UPDATE id=id;
SET @fan = LAST_INSERT_ID();

INSERT INTO user_roles (user_id, role_id, artist_id)
VALUES (@fan, (SELECT id FROM roles WHERE slug='user'), @cabaxx)
ON DUPLICATE KEY UPDATE user_id=user_id;

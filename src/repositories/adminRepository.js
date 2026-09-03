const artistRepository = require('./artists.repository');
const db = require('../config/database');

async function listUsers({ page = 1, limit = 20 } = {}) {
  const safeLimit = Math.min(parseInt(limit, 10) || 20, 100);
  const safePage = Math.max(parseInt(page, 10) || 1, 1);
  const offset = (safePage - 1) * safeLimit;
  const [{ total }] = await db.query('SELECT COUNT(*) AS total FROM users');
  const rows = await db.query(
    `SELECT u.id, u.name, u.email, u.status AS user_status, u.created_at,
            GROUP_CONCAT(DISTINCT r.slug) AS roles,
            GROUP_CONCAT(DISTINCT ur.artist_id) AS artist_ids
     FROM users u
     LEFT JOIN user_roles ur ON ur.user_id = u.id
     LEFT JOIN roles r ON r.id = ur.role_id
     GROUP BY u.id
     ORDER BY u.created_at DESC
     LIMIT ${safeLimit} OFFSET ${offset}`,
  );
  return { rows, total };
}

module.exports = { listArtists: artistRepository.findAll, listUsers };

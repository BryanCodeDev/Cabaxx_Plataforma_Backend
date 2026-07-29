const artistRepository = require('./artists.repository');
const db = require('../config/database');

async function listUsers({ page = 1, limit = 20 } = {}) {
  const [{ total }] = await db.query('SELECT COUNT(*) AS total FROM users');
  const offset = (parseInt(page, 10) - 1) * parseInt(limit, 10);
  const rows = await db.query('SELECT id, email, role, artist_id, is_active FROM users ORDER BY created_at DESC LIMIT ? OFFSET ?', [parseInt(limit, 10), offset]);
  return { rows, total };
}

async function listSubscriptions({ page = 1, limit = 20 } = {}) {
  const [{ total }] = await db.query('SELECT COUNT(*) AS total FROM artist_subscriptions');
  const offset = (parseInt(page, 10) - 1) * parseInt(limit, 10);
  const rows = await db.query('SELECT * FROM artist_subscriptions ORDER BY created_at DESC LIMIT ? OFFSET ?', [parseInt(limit, 10), offset]);
  return { rows, total };
}

module.exports = { listArtists: artistRepository.findAll, listUsers, listSubscriptions };

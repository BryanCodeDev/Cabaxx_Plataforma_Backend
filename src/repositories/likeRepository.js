const db = require('../config/database');

async function findByUserAndRef(userId, referenceType, referenceId) {
  const [row] = await db.query(`SELECT * FROM likes WHERE user_id = ? AND reference_type = ? AND reference_id = ?`, [userId, referenceType, referenceId]);
  return row || null;
}

async function countByReference(artistId, referenceType, referenceId) {
  const [row] = await db.query(`SELECT COUNT(*) AS total FROM likes WHERE artist_id = ? AND reference_type = ? AND reference_id = ?`, [artistId, referenceType, referenceId]);
  return row?.total || 0;
}

async function create({ userId, artistId, referenceType, referenceId }) {
  const [result] = await db.query(`INSERT INTO likes (user_id, artist_id, reference_type, reference_id) VALUES (?, ?, ?, ?)`, [userId, artistId, referenceType, referenceId]);
  return findByUserAndRef(userId, referenceType, referenceId);
}

async function remove(userId, referenceType, referenceId) {
  await db.query(`DELETE FROM likes WHERE user_id = ? AND reference_type = ? AND reference_id = ?`, [userId, referenceType, referenceId]);
  return true;
}

async function findUserLikes(userId, artistId, referenceIds = [], referenceType) {
  if (!referenceIds.length) return [];
  const placeholders = referenceIds.map(() => '?').join(',');
  const [rows] = await db.query(`SELECT reference_id FROM likes WHERE user_id = ? AND artist_id = ? AND reference_type = ? AND reference_id IN (${placeholders})`, [userId, artistId, referenceType, ...referenceIds]);
  return rows.map((r) => r.reference_id);
}

module.exports = { findByUserAndRef, countByReference, create, remove, findUserLikes };

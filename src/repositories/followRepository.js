const db = require('../config/database');

async function findByUserAndArtist(userId, artistId) {
  const [row] = await db.query(`SELECT * FROM follows WHERE user_id = ? AND artist_id = ?`, [userId, artistId]);
  return row || null;
}

async function countByArtist(artistId) {
  const [row] = await db.query(`SELECT COUNT(*) AS total FROM follows WHERE artist_id = ?`, [artistId]);
  return row?.total || 0;
}

async function create({ userId, artistId }) {
  const [result] = await db.query(`INSERT INTO follows (user_id, artist_id) VALUES (?, ?)`, [userId, artistId]);
  return findByUserAndArtist(userId, artistId);
}

async function remove(userId, artistId) {
  await db.query(`DELETE FROM follows WHERE user_id = ? AND artist_id = ?`, [userId, artistId]);
  return true;
}

async function isFollowing(userId, artistId) {
  const [row] = await db.query(`SELECT id FROM follows WHERE user_id = ? AND artist_id = ?`, [userId, artistId]);
  return !!row;
}

module.exports = { findByUserAndArtist, countByArtist, create, remove, isFollowing };

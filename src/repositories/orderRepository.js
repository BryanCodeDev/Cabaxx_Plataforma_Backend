const db = require('../config/database');
const OrderModel = require('../models/Order.model');

async function create({ artistId, userId, total, currency, status = 'pending' }) {
  const [result] = await db.query(
    `INSERT INTO ${OrderModel.tableName} (artist_id, user_id, total, currency, status) VALUES (?, ?, ?, ?, ?)`,
    [artistId, userId, total, currency, status],
  );
  return findById(result.insertId);
}

async function findById(id) {
  const [row] = await db.query(`SELECT * FROM ${OrderModel.tableName} WHERE id = ?`, [id]);
  return row || null;
}

async function findByArtist(artistId, { page = 1, limit = 20 } = {}) {
  const [{ total }] = await db.query(`SELECT COUNT(*) AS total FROM ${OrderModel.tableName} WHERE artist_id = ?`, [artistId]);
  const offset = (parseInt(page, 10) - 1) * parseInt(limit, 10);
  const rows = await db.query(
    `SELECT * FROM ${OrderModel.tableName} WHERE artist_id = ? ORDER BY created_at DESC LIMIT ? OFFSET ?`,
    [artistId, parseInt(limit, 10), offset],
  );
  return { rows, total };
}

async function findByUser(userId, artistId) {
  const rows = await db.query(
    `SELECT * FROM ${OrderModel.tableName} WHERE user_id = ? AND artist_id = ? ORDER BY created_at DESC`,
    [userId, artistId],
  );
  return rows;
}

async function updateStatus(id, status, artistId = null) {
  let sql = `UPDATE ${OrderModel.tableName} SET status = ? WHERE id = ?`;
  const params = [status, id];
  if (artistId) {
    sql += ' AND artist_id = ?';
    params.push(artistId);
  }
  await db.query(sql, params);
  return findById(id);
}

module.exports = { create, findById, findByArtist, findByUser, updateStatus };

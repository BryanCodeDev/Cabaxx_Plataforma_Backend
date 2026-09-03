const db = require('../config/database');
const NotificationModel = require('../models/Notification.model');

async function create({ artistId, userId, type, title, body }) {
  const [result] = await db.query(
    `INSERT INTO ${NotificationModel.tableName} (artist_id, user_id, type, title, body) VALUES (?, ?, ?, ?, ?)`,
    [artistId, userId || null, type, title, body],
  );
  const [row] = await db.query(`SELECT * FROM ${NotificationModel.tableName} WHERE id = ?`, [result.insertId]);
  return row;
}

async function findByUser(userId, artistId, { limit = 50, onlyUnread = false } = {}) {
  const clauses = ['user_id = ?'];
  const params = [userId];
  if (artistId) {
    clauses.push('artist_id = ?');
    params.push(artistId);
  }
  if (onlyUnread) {
    clauses.push('read_at IS NULL');
  }
  const safeLimit = Math.min(parseInt(limit, 10) || 50, 200);
  const rows = await db.query(
    `SELECT * FROM ${NotificationModel.tableName}
     WHERE ${clauses.join(' AND ')}
     ORDER BY created_at DESC
     LIMIT ${safeLimit}`,
    params,
  );
  return rows;
}

async function markRead(id, userId) {
  const [result] = await db.query(
    `UPDATE ${NotificationModel.tableName} SET read_at = NOW() WHERE id = ? AND user_id = ? AND read_at IS NULL`,
    [id, userId],
  );
  return result.affectedRows > 0;
}

async function markAllRead(userId, artistId) {
  let sql = `UPDATE ${NotificationModel.tableName} SET read_at = NOW() WHERE user_id = ? AND read_at IS NULL`;
  const params = [userId];
  if (artistId) {
    sql += ' AND artist_id = ?';
    params.push(artistId);
  }
  const [result] = await db.query(sql, params);
  return result.affectedRows;
}

module.exports = { create, findByUser, markRead, markAllRead };

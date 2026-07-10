const db = require('../config/database');
const NotificationModel = require('../models/Notification.model');

async function create({ artistId, userId, type, title, body }) {
  const [result] = await db.query(
    `INSERT INTO ${NotificationModel.tableName} (artist_id, user_id, type, title, body, is_read) VALUES (?, ?, ?, ?, ?, ?)`,
    [artistId, userId || null, type, title, body, false],
  );
  const [row] = await db.query(`SELECT * FROM ${NotificationModel.tableName} WHERE id = ?`, [result.insertId]);
  return row;
}

async function findByUser(userId, artistId) {
  const rows = await db.query(
    `SELECT * FROM ${NotificationModel.tableName} WHERE user_id = ? AND artist_id = ? ORDER BY created_at DESC`,
    [userId, artistId],
  );
  return rows;
}

async function markRead(id, userId) {
  await db.query(`UPDATE ${NotificationModel.tableName} SET is_read = ? WHERE id = ? AND user_id = ?`, [true, id, userId]);
  return true;
}

async function markAllRead(userId, artistId) {
  await db.query(`UPDATE ${NotificationModel.tableName} SET is_read = ? WHERE user_id = ? AND artist_id = ?`, [true, userId, artistId]);
  return true;
}

module.exports = { create, findByUser, markRead, markAllRead };

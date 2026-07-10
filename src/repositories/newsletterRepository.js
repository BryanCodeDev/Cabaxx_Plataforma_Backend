const db = require('../config/database');
const SubscriberModel = require('../models/Subscriber.model');

async function subscribe({ artistId, email }) {
  const [existing] = await db.query(
    `SELECT * FROM ${SubscriberModel.tableName} WHERE artist_id = ? AND email = ?`,
    [artistId, email],
  );
  if (existing) {
    if (!existing.is_active) {
      await db.query(`UPDATE ${SubscriberModel.tableName} SET is_active = ? WHERE id = ?`, [true, existing.id]);
    }
    return existing;
  }
  const [result] = await db.query(
    `INSERT INTO ${SubscriberModel.tableName} (artist_id, email, is_active) VALUES (?, ?, ?)`,
    [artistId, email, true],
  );
  const [row] = await db.query(`SELECT * FROM ${SubscriberModel.tableName} WHERE id = ?`, [result.insertId]);
  return row;
}

async function findByArtist(artistId, { page = 1, limit = 20 } = {}) {
  const [{ total }] = await db.query(`SELECT COUNT(*) AS total FROM ${SubscriberModel.tableName} WHERE artist_id = ?`, [artistId]);
  const offset = (parseInt(page, 10) - 1) * parseInt(limit, 10);
  const rows = await db.query(
    `SELECT * FROM ${SubscriberModel.tableName} WHERE artist_id = ? ORDER BY subscribed_at DESC LIMIT ? OFFSET ?`,
    [artistId, parseInt(limit, 10), offset],
  );
  return { rows, total };
}

async function unsubscribe(token) {
  const [row] = await db.query(`SELECT * FROM ${SubscriberModel.tableName} WHERE unsub_token = ?`, [token]);
  if (row) await db.query(`UPDATE ${SubscriberModel.tableName} SET is_active = ? WHERE id = ?`, [false, row.id]);
  return !!row;
}

module.exports = { subscribe, findByArtist, unsubscribe };

const crypto = require('crypto');
const db = require('../config/database');
const SubscriberModel = require('../models/NewsletterSubscriber.model');
const CampaignModel = require('../models/NewsletterCampaign.model');

async function subscribe({ artistId, email, name, source }) {
  const [existing] = await db.query(
    `SELECT * FROM ${SubscriberModel.tableName} WHERE artist_id = ? AND email = ?`,
    [artistId, email],
  );
  if (existing) {
     if (existing.status === 'unsubscribed') {
      await db.query(
        `UPDATE ${SubscriberModel.tableName} SET status = 'subscribed', unsubscribed_at = NULL WHERE id = ?`,
        [existing.id],
      );
    }
    const [row] = await db.query(`SELECT * FROM ${SubscriberModel.tableName} WHERE id = ?`, [existing.id]);
    return row;
  }
  const unsubToken = crypto.randomBytes(16).toString('hex');
  const result = await db.query(
    `INSERT INTO ${SubscriberModel.tableName} (artist_id, email, name, source, status, unsub_token, subscribed_at)
     VALUES (?, ?, ?, ?, 'subscribed', ?, NOW())`,
    [artistId, email, name || null, source || 'website', unsubToken],
  );
  const [row] = await db.query(`SELECT * FROM ${SubscriberModel.tableName} WHERE id = ?`, [result.insertId]);
  return row;
}

async function unsubscribe(artistId, email, token) {
  let sql = `UPDATE ${SubscriberModel.tableName} SET status = 'unsubscribed', unsubscribed_at = NOW() WHERE artist_id = ? AND email = ?`;
  const params = [artistId, email];
  if (token) {
    sql += ' AND unsub_token = ?';
    params.push(token);
  }
  const [result] = await db.query(sql, params);
  return result.affectedRows > 0;
}

async function findAll(artistId, { page = 1, limit = 50, status, search } = {}) {
  const clauses = ['artist_id = ?'];
  const params = [artistId];
  if (status) {
    clauses.push('status = ?');
    params.push(status);
  }
  if (search) {
    clauses.push('(email LIKE ? OR name LIKE ?)');
    params.push(`%${search}%`, `%${search}%`);
  }
  const clause = `WHERE ${clauses.join(' AND ')}`;
  const [{ total }] = await db.query(`SELECT COUNT(*) AS total FROM ${SubscriberModel.tableName} ${clause}`, params);
  const offset = (parseInt(page, 10) - 1) * parseInt(limit, 10);
  const rows = await db.query(`SELECT id, email, name, status, source, subscribed_at FROM ${SubscriberModel.tableName} ${clause} ORDER BY subscribed_at DESC LIMIT ? OFFSET ?`, [...params, parseInt(limit, 10), offset]);
  return { rows, total };
}

async function getActiveBatch(artistId, limit, offset) {
  return db.query(
    `  SELECT id, email, name FROM ${SubscriberModel.tableName} WHERE artist_id = ? AND status = 'subscribed' LIMIT ? OFFSET ?`,
    [artistId, limit, offset],
  );
}

async function countActive(artistId) {
  const [{ c }] = await db.query(`SELECT COUNT(*) AS c FROM ${SubscriberModel.tableName} WHERE artist_id = ? AND status = 'active'`, [artistId]);
  return c;
}

async function saveCampaign(data) {
  const keys = Object.keys(data);
  const placeholders = keys.map(() => '?').join(', ');
  const [result] = await db.query(`INSERT INTO ${CampaignModel.tableName} (${keys.join(', ')}) VALUES (${placeholders})`, keys.map((k) => data[k]));
  const [row] = await db.query(`SELECT * FROM ${CampaignModel.tableName} WHERE id = ?`, [result.insertId]);
  return row;
}

async function updateCampaignStats(id, { totalSent, totalOpened, totalClicked }) {
  await db.query(
    `UPDATE ${CampaignModel.tableName} SET total_sent = ?, total_opened = ?, total_clicked = ?, sent_at = NOW() WHERE id = ?`,
    [totalSent, totalOpened || 0, totalClicked || 0, id],
  );
  const [row] = await db.query(`SELECT * FROM ${CampaignModel.tableName} WHERE id = ?`, [id]);
  return row;
}

async function removeSubscriber(id, artistId) {
  const [result] = await db.query(`DELETE FROM ${SubscriberModel.tableName} WHERE id = ? AND artist_id = ?`, [id, artistId]);
  return result.affectedRows > 0;
}

module.exports = { subscribe, unsubscribe, findAll, getActiveBatch, countActive, removeSubscriber, saveCampaign, updateCampaignStats };

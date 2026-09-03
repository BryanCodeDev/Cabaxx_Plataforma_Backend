const db = require('../config/database');
const PaymentModel = require('../models/Payment.model');

async function create({ orderId, userId, artistId, provider, providerTxId, amount, currency, status = 'pending', responseJson = null, paidAt = null }) {
  const [result] = await db.query(
    `INSERT INTO ${PaymentModel.tableName}
     (order_id, user_id, artist_id, provider, provider_tx_id, amount, currency, status, response_json, paid_at)
     VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
    [orderId, userId || null, artistId || null, provider, providerTxId || null, amount, currency, status, responseJson, paidAt],
  );
  const [row] = await db.query(`SELECT * FROM ${PaymentModel.tableName} WHERE id = ?`, [result.insertId]);
  return row;
}

async function findByOrder(orderId) {
  const rows = await db.query(
    `SELECT * FROM ${PaymentModel.tableName} WHERE order_id = ? ORDER BY created_at DESC`,
    [orderId],
  );
  return rows;
}

async function findByOrderId(orderId) {
  const [row] = await db.query(
    `SELECT * FROM ${PaymentModel.tableName} WHERE order_id = ? ORDER BY created_at DESC LIMIT 1`,
    [orderId],
  );
  return row || null;
}

async function findByProviderRef(provider, providerTxId) {
  if (!providerTxId) return null;
  const [row] = await db.query(
    `SELECT * FROM ${PaymentModel.tableName}
     WHERE provider = ? AND provider_tx_id = ?
     ORDER BY id DESC LIMIT 1`,
    [provider, providerTxId],
  );
  return row || null;
}

async function updateStatus(id, status) {
  const paidAt = status === 'succeeded' ? new Date() : null;
  await db.query(
    `UPDATE ${PaymentModel.tableName} SET status = ?, paid_at = COALESCE(?, paid_at) WHERE id = ?`,
    [status, paidAt, id],
  );
  const [row] = await db.query(`SELECT * FROM ${PaymentModel.tableName} WHERE id = ?`, [id]);
  return row;
}

module.exports = { create, findByOrder, findByOrderId, findByProviderRef, updateStatus };

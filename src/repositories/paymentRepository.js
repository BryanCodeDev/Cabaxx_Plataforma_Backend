const db = require('../config/database');
const PaymentModel = require('../models/Payment.model');

async function create({ orderId, provider, providerRef, amount, currency, status = 'pending', responseJson = null }) {
  const [result] = await db.query(
    `INSERT INTO ${PaymentModel.tableName} (order_id, provider, provider_ref, amount, currency, status, response_json) VALUES (?, ?, ?, ?, ?, ?, ?)`,
    [orderId, provider, providerRef, amount, currency, status, responseJson],
  );
  const [row] = await db.query(`SELECT * FROM ${PaymentModel.tableName} WHERE id = ?`, [result.insertId]);
  return row;
}

async function findByOrder(orderId) {
  const rows = await db.query(`SELECT * FROM ${PaymentModel.tableName} WHERE order_id = ? ORDER BY created_at DESC`, [orderId]);
  return rows;
}

async function findByOrderId(orderId) {
  const [row] = await db.query(`SELECT * FROM ${PaymentModel.tableName} WHERE order_id = ? ORDER BY created_at DESC LIMIT 1`, [orderId]);
  return row || null;
}

async function updateStatus(id, status) {
  await db.query(`UPDATE ${PaymentModel.tableName} SET status = ? WHERE id = ?`, [status, id]);
  const [row] = await db.query(`SELECT * FROM ${PaymentModel.tableName} WHERE id = ?`, [id]);
  return row;
}

module.exports = { create, findByOrder, findByOrderId, updateStatus };

const db = require('../config/database');
const OrderModel = require('../models/Order.model');
const OrderItemModel = require('../models/OrderItem.model');
const ProductModel = require('../models/Product.model');

async function createOrder(conn, { userId, artistId, subtotal, discount, shipping, tax, total, currency, couponId, notes, shippingAddress, items }) {
  const [result] = await conn.query(
    `INSERT INTO ${OrderModel.tableName}
     (user_id, artist_id, status, subtotal, discount, shipping, tax, total, currency, coupon_id, notes, shipping_address_json)
     VALUES (?, ?, 'pending', ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
    [userId, artistId, subtotal, discount, shipping, tax, total, currency, couponId || null, notes || null, JSON.stringify(shippingAddress || {})],
  );
  const orderId = result.insertId;
  for (const item of items) {
    await conn.query(
      `INSERT INTO ${OrderItemModel.tableName} (order_id, product_id, variant_id, quantity, unit_price, total_price, snapshot_json)
       VALUES (?, ?, ?, ?, ?, ?, ?)`,
      [orderId, item.productId, item.variantId || null, item.quantity, item.unitPrice, item.totalPrice, JSON.stringify(item.snapshot || {})],
    );
  }
  return orderId;
}

async function findById(id) {
  const [order] = await db.query(`SELECT * FROM ${OrderModel.tableName} WHERE id = ? AND deleted_at IS NULL`, [id]);
  if (!order) return null;
  order.items = await db.query(`SELECT * FROM ${OrderItemModel.tableName} WHERE order_id = ?`, [id]);
  return order;
}

async function findOrdersByUser(userId, { page = 1, limit = 20, status } = {}) {
  const clauses = ['user_id = ?'];
  const params = [userId];
  if (status) {
    clauses.push('status = ?');
    params.push(status);
  }
  const clause = `WHERE ${clauses.join(' AND ')} AND deleted_at IS NULL`;
  const [{ total }] = await db.query(`SELECT COUNT(*) AS total FROM ${OrderModel.tableName} ${clause}`, params);
  const offset = (parseInt(page, 10) - 1) * parseInt(limit, 10);
  const rows = await db.query(`SELECT * FROM ${OrderModel.tableName} ${clause} ORDER BY created_at DESC LIMIT ? OFFSET ?`, [...params, parseInt(limit, 10), offset]);
  if (!rows.length) return { rows, total };
  const orderIds = rows.map((o) => o.id);
  const placeholders = orderIds.map(() => '?').join(',');
  const items = await db.query(
    `SELECT order_id, product_id, quantity, unit_price, snapshot_json
     FROM ${OrderItemModel.tableName} WHERE order_id IN (${placeholders})`,
    orderIds,
  );
  const byOrder = new Map();
  for (const item of items) {
    const snapshot = JSON.parse(item.snapshot_json || '{}');
    const shaped = {
      name: snapshot.name || `Producto #${item.product_id}`,
      qty: item.quantity,
      price: Number(item.unit_price),
    };
    if (!byOrder.has(item.order_id)) byOrder.set(item.order_id, []);
    byOrder.get(item.order_id).push(shaped);
  }
  for (const order of rows) {
    order.items = byOrder.get(order.id) || [];
  }
  return { rows, total };
}

async function findOrdersByArtist(artistId, { page = 1, limit = 20, status } = {}) {
  const clauses = ['artist_id = ?'];
  const params = [artistId];
  if (status) {
    clauses.push('status = ?');
    params.push(status);
  }
  const clause = `WHERE ${clauses.join(' AND ')} AND deleted_at IS NULL`;
  const [{ total }] = await db.query(`SELECT COUNT(*) AS total FROM ${OrderModel.tableName} ${clause}`, params);
  const offset = (parseInt(page, 10) - 1) * parseInt(limit, 10);
  const rows = await db.query(`SELECT * FROM ${OrderModel.tableName} ${clause} ORDER BY created_at DESC LIMIT ? OFFSET ?`, [...params, parseInt(limit, 10), offset]);
  return { rows, total };
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

async function softDelete(id, artistId = null) {
  let sql = `UPDATE ${OrderModel.tableName} SET deleted_at = NOW() WHERE id = ?`;
  const params = [id];
  if (artistId) {
    sql += ' AND artist_id = ?';
    params.push(artistId);
  }
  const [result] = await db.query(sql, params);
  return result.affectedRows > 0;
}

module.exports = { createOrder, findById, findOrdersByUser, findOrdersByArtist, updateStatus, softDelete };

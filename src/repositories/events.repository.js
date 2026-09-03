const db = require('../config/database');
const EventModel = require('../models/Event.model');
const TicketModel = require('../models/Ticket.model');

function buildWhere(artistId, { status, city, from, to } = {}) {
  const clauses = ['artist_id = ?', 'deleted_at IS NULL'];
  const params = [artistId];
  if (status) {
    clauses.push('status = ?');
    params.push(status);
  }
  if (city) {
    clauses.push('city = ?');
    params.push(city);
  }
  if (from) {
    clauses.push('start_datetime >= ?');
    params.push(from);
  }
  if (to) {
    clauses.push('start_datetime <= ?');
    params.push(to);
  }
  return { clause: `WHERE ${clauses.join(' AND ')}`, params };
}

async function findUpcoming(artistId, limit = 10) {
  return db.query(
    `SELECT * FROM ${EventModel.tableName} WHERE artist_id = ? AND deleted_at IS NULL AND start_datetime >= NOW() AND status = 'published' ORDER BY start_datetime ASC LIMIT ?`,
    [artistId, limit],
  );
}

async function findAll(artistId, { page = 1, limit = 20, status, city, from, to } = {}) {
  const { clause, params } = buildWhere(artistId, { status, city, from, to });
  const [{ total }] = await db.query(`SELECT COUNT(*) AS total FROM ${EventModel.tableName} ${clause}`, params);
  const offset = (parseInt(page, 10) - 1) * parseInt(limit, 10);
  const rows = await db.query(`SELECT * FROM ${EventModel.tableName} ${clause} ORDER BY start_datetime DESC LIMIT ? OFFSET ?`, [...params, parseInt(limit, 10), offset]);
  return { rows, total };
}

async function findBySlug(artistId, slug) {
  const [event] = await db.query(`SELECT * FROM ${EventModel.tableName} WHERE artist_id = ? AND slug = ? AND deleted_at IS NULL`, [artistId, slug]);
  if (!event) return null;
  event.tickets = await db.query(
    `SELECT id, name, price, currency, quantity_total, quantity_sold, status, sale_start_at, sale_end_at
     FROM ${TicketModel.tableName} WHERE event_id = ? AND quantity_sold < quantity_total`,
    [event.id],
  );
  return event;
}

async function findById(id, artistId) {
  let sql = `SELECT * FROM ${EventModel.tableName} WHERE id = ?`;
  const params = [id];
  if (artistId) {
    sql += ' AND artist_id = ?';
    params.push(artistId);
  }
  sql += ' AND deleted_at IS NULL';
  const [row] = await db.query(sql, params);
  return row || null;
}

async function create(data) {
  const keys = Object.keys(data);
  const placeholders = keys.map(() => '?').join(', ');
  const [result] = await db.query(`INSERT INTO ${EventModel.tableName} (${keys.join(', ')}) VALUES (${placeholders})`, keys.map((k) => data[k]));
  return findById(result.insertId);
}

async function update(id, data, artistId) {
  const keys = Object.keys(data).filter((k) => k !== 'id');
  if (!keys.length) return findById(id, artistId);
  const assignments = keys.map((k) => `${k} = ?`).join(', ');
  let sql = `UPDATE ${EventModel.tableName} SET ${assignments} WHERE id = ?`;
  const params = keys.map((k) => data[k]);
  params.push(id);
  if (artistId) {
    sql += ' AND artist_id = ?';
    params.push(artistId);
  }
  await db.query(sql, params);
  return findById(id, artistId);
}

async function findTicket(ticketId) {
  const [row] = await db.query(`SELECT * FROM ${TicketModel.tableName} WHERE id = ?`, [ticketId]);
  return row || null;
}

async function createTicketPurchase({ userId, ticketId, quantity, totalPrice, status, qrCode }) {
  const [result] = await db.query(
    `INSERT INTO ticket_purchases (user_id, ticket_id, quantity, total_price, status, qr_code) VALUES (?, ?, ?, ?, ?, ?)`,
    [userId, ticketId, quantity, totalPrice, status, qrCode],
  );
  return result.insertId;
}

async function incrementSold(ticketId, quantity) {
  const [result] = await db.query(
    `UPDATE ${TicketModel.tableName}
     SET quantity_sold = quantity_sold + ?
     WHERE id = ? AND status = 'on_sale' AND quantity_sold + ? <= quantity_total`,
    [quantity, ticketId, quantity],
  );
  return result.affectedRows > 0;
}

async function findPurchaseByQr(qrCode) {
  const [row] = await db.query('SELECT * FROM ticket_purchases WHERE qr_code = ?', [qrCode]);
  return row || null;
}

async function markUsed(qrCode) {
  await db.query('UPDATE ticket_purchases SET used_at = NOW() WHERE qr_code = ? AND used_at IS NULL', [qrCode]);
}

async function remove(id, artistId) {
  const [result] = await db.query(
    `UPDATE ${EventModel.tableName} SET deleted_at = NOW() WHERE id = ? AND artist_id = ? AND deleted_at IS NULL`,
    [id, artistId],
  );
  return result.affectedRows > 0;
}

module.exports = {
  findUpcoming,
  findAll,
  findBySlug,
  findById,
  create,
  update,
  remove,
  findTicket,
  createTicketPurchase,
  incrementSold,
  findPurchaseByQr,
  markUsed,
};

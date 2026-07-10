const db = require('../config/database');
const GalleryItemModel = require('../models/GalleryItem.model');

function buildWhere(artistId, { category, fileType } = {}) {
  const clauses = ['artist_id = ?', 'deleted_at IS NULL'];
  const params = [artistId];
  if (category) {
    clauses.push('category = ?');
    params.push(category);
  }
  if (fileType) {
    clauses.push('file_type = ?');
    params.push(fileType);
  }
  return { clause: `WHERE ${clauses.join(' AND ')}`, params };
}

async function findAll(artistId, { page = 1, limit = 20, category, fileType, order = 'sort_order' } = {}) {
  const { clause, params } = buildWhere(artistId, { category, fileType });
  const [{ total }] = await db.query(`SELECT COUNT(*) AS total FROM ${GalleryItemModel.tableName} ${clause}`, params);
  const offset = (parseInt(page, 10) - 1) * parseInt(limit, 10);
  const allowedOrder = ['sort_order', 'created_at DESC', 'title'];
  const orderBy = allowedOrder.includes(order) ? order : 'sort_order';
  const rows = await db.query(`SELECT * FROM ${GalleryItemModel.tableName} ${clause} ORDER BY ${orderBy} LIMIT ? OFFSET ?`, [...params, parseInt(limit, 10), offset]);
  return { rows, total };
}

async function create(data) {
  const keys = Object.keys(data);
  const placeholders = keys.map(() => '?').join(', ');
  const [result] = await db.query(`INSERT INTO ${GalleryItemModel.tableName} (${keys.join(', ')}) VALUES (${placeholders})`, keys.map((k) => data[k]));
  const [row] = await db.query(`SELECT * FROM ${GalleryItemModel.tableName} WHERE id = ?`, [result.insertId]);
  return row;
}

async function findById(id, artistId) {
  const [row] = await db.query(`SELECT * FROM ${GalleryItemModel.tableName} WHERE id = ? AND artist_id = ? AND deleted_at IS NULL`, [id, artistId]);
  return row || null;
}

async function deleteById(id, artistId) {
  const [result] = await db.query(`UPDATE ${GalleryItemModel.tableName} SET deleted_at = NOW() WHERE id = ? AND artist_id = ?`, [id, artistId]);
  return result.affectedRows > 0;
}

// Reordenar: recibe [{id, sort_order}]
async function updateSortOrder(items = []) {
  for (const item of items) {
    await db.query(`UPDATE ${GalleryItemModel.tableName} SET sort_order = ? WHERE id = ?`, [item.sort_order, item.id]);
  }
  return true;
}

module.exports = { findAll, create, findById, deleteById, updateSortOrder };

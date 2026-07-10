const db = require('../config/database');
const ArtistModel = require('../models/Artist.model');

async function findBySlug(slug) {
  const [row] = await db.query(`SELECT * FROM ${ArtistModel.tableName} WHERE slug = ?`, [slug]);
  return row || null;
}

async function findById(id) {
  const [row] = await db.query(`SELECT * FROM ${ArtistModel.tableName} WHERE id = ?`, [id]);
  return row || null;
}

async function findAll({ page = 1, limit = 20, isActive = null } = {}) {
  const params = [];
  let sql = `SELECT * FROM ${ArtistModel.tableName}`;
  if (isActive !== null) {
    sql += ' WHERE is_active = ?';
    params.push(isActive);
  }
  const [{ total }] = await db.query(`SELECT COUNT(*) AS total FROM ${ArtistModel.tableName}`);
  const offset = (parseInt(page, 10) - 1) * parseInt(limit, 10);
  sql += ' ORDER BY created_at DESC LIMIT ? OFFSET ?';
  const rows = await db.query(sql, [...params, parseInt(limit, 10), offset]);
  return { rows, total };
}

async function create(data) {
  const keys = Object.keys(data);
  const placeholders = keys.map(() => '?').join(', ');
  const sql = `INSERT INTO ${ArtistModel.tableName} (${keys.join(', ')}) VALUES (${placeholders})`;
  const [result] = await db.query(sql, keys.map((k) => data[k]));
  return findById(result.insertId);
}

async function update(id, data) {
  const keys = Object.keys(data).filter((k) => k !== 'id');
  if (!keys.length) return findById(id);
  const assignments = keys.map((k) => `${k} = ?`).join(', ');
  await db.query(`UPDATE ${ArtistModel.tableName} SET ${assignments} WHERE id = ?`, [...keys.map((k) => data[k]), id]);
  return findById(id);
}

module.exports = { findBySlug, findById, findAll, create, update };

const db = require('../config/database');
const PostModel = require('../models/Post.model');

function buildWhere(artistId, { type, status, tag, search } = {}) {
  const clauses = ['artist_id = ?', 'deleted_at IS NULL'];
  const params = [artistId];
  if (type) {
    clauses.push('type = ?');
    params.push(type);
  }
  if (status) {
    clauses.push('status = ?');
    params.push(status);
  }
  if (tag) {
    clauses.push('id IN (SELECT post_id FROM post_tags WHERE tag = ?)');
    params.push(tag);
  }
  if (search) {
    clauses.push('(title LIKE ? OR excerpt LIKE ?)');
    params.push(`%${search}%`, `%${search}%`);
  }
  return { clause: `WHERE ${clauses.join(' AND ')}`, params };
}

async function findAll(artistId, { page = 1, limit = 20, type, status, tag, search } = {}) {
  const { clause, params } = buildWhere(artistId, { type, status, tag, search });
  const [{ total }] = await db.query(`SELECT COUNT(*) AS total FROM ${PostModel.tableName} ${clause}`, params);
  const offset = (parseInt(page, 10) - 1) * parseInt(limit, 10);
  const rows = await db.query(
    `SELECT id, type, title, slug, excerpt, cover_url, status, published_at, views_count FROM ${PostModel.tableName} ${clause} ORDER BY COALESCE(published_at, created_at) DESC LIMIT ? OFFSET ?`,
    [...params, parseInt(limit, 10), offset],
  );
  return { rows, total };
}

async function findBySlug(artistId, slug) {
  const [row] = await db.query(`SELECT * FROM ${PostModel.tableName} WHERE artist_id = ? AND slug = ? AND deleted_at IS NULL`, [artistId, slug]);
  if (!row) return null;
  row.tags = await db.query('SELECT tag FROM post_tags WHERE post_id = ?', [row.id]);
  return row;
}

async function findById(id, artistId) {
  let sql = `SELECT * FROM ${PostModel.tableName} WHERE id = ?`;
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
  const [result] = await db.query(`INSERT INTO ${PostModel.tableName} (${keys.join(', ')}) VALUES (${placeholders})`, keys.map((k) => data[k]));
  return findById(result.insertId);
}

async function update(id, data, artistId) {
  const keys = Object.keys(data).filter((k) => k !== 'id');
  if (!keys.length) return findById(id, artistId);
  const assignments = keys.map((k) => `${k} = ?`).join(', ');
  let sql = `UPDATE ${PostModel.tableName} SET ${assignments} WHERE id = ?`;
  const params = keys.map((k) => data[k]);
  params.push(id);
  if (artistId) {
    sql += ' AND artist_id = ?';
    params.push(artistId);
  }
  await db.query(sql, params);
  return findById(id, artistId);
}

async function remove(id, artistId) {
  let sql = `UPDATE ${PostModel.tableName} SET deleted_at = NOW() WHERE id = ?`;
  const params = [id];
  if (artistId) {
    sql += ' AND artist_id = ?';
    params.push(artistId);
  }
  const [result] = await db.query(sql, params);
  return result.affectedRows > 0;
}

async function incrementViews(postId) {
  await db.query(`UPDATE ${PostModel.tableName} SET views_count = views_count + 1 WHERE id = ?`, [postId]);
}

async function setTags(postId, tags = []) {
  await db.query('DELETE FROM post_tags WHERE post_id = ?', [postId]);
  for (const tag of tags) {
    await db.query('INSERT INTO post_tags (post_id, tag) VALUES (?, ?)', [postId, tag]);
  }
}

module.exports = { findAll, findBySlug, findById, create, update, remove, incrementViews, setTags };

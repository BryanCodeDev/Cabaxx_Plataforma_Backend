const db = require('../config/database');

function buildWhere(artistId, { referenceType, referenceId, status, parentId } = {}) {
  const clauses = ['artist_id = ?', 'deleted_at IS NULL'];
  const params = [artistId];
  if (referenceType) {
    clauses.push('reference_type = ?');
    params.push(referenceType);
  }
  if (referenceId) {
    clauses.push('reference_id = ?');
    params.push(referenceId);
  }
  if (status) {
    clauses.push('status = ?');
    params.push(status);
  }
  if (parentId !== undefined && parentId !== null) {
    clauses.push('parent_id = ?');
    params.push(parentId);
  }
  return { clause: `WHERE ${clauses.join(' AND ')}`, params };
}

async function findAll(artistId, filters = {}) {
  const { page = 1, limit = 20, referenceType, referenceId, status, parentId } = filters;
  const { clause, params } = buildWhere(artistId, { referenceType, referenceId, status, parentId });
  const [{ total }] = await db.query(`SELECT COUNT(*) AS total FROM comments ${clause}`, params);
  const offset = (parseInt(page, 10) - 1) * parseInt(limit, 10);
  const rows = await db.query(
    `SELECT c.*, u.name as user_name, u.avatar_url as user_avatar FROM comments c LEFT JOIN users u ON u.id = c.user_id ${clause} ORDER BY c.created_at ASC LIMIT ? OFFSET ?`,
    [...params, parseInt(limit, 10), offset],
  );
  return { rows, total };
}

async function findById(id, artistId) {
  const [row] = await db.query(`SELECT c.*, u.name as user_name, u.avatar_url as user_avatar FROM comments c LEFT JOIN users u ON u.id = c.user_id WHERE c.id = ? AND c.artist_id = ? AND c.deleted_at IS NULL`, [id, artistId]);
  return row || null;
}

async function create(data) {
  const keys = Object.keys(data);
  const placeholders = keys.map(() => '?').join(', ');
  const [result] = await db.query(`INSERT INTO comments (${keys.join(', ')}) VALUES (${placeholders})`, keys.map((k) => data[k]));
  const [row] = await db.query(`SELECT c.*, u.name as user_name, u.avatar_url as user_avatar FROM comments c LEFT JOIN users u ON u.id = c.user_id WHERE c.id = ?`, [result.insertId]);
  return row;
}

async function update(id, data, artistId) {
  const keys = Object.keys(data).filter((k) => k !== 'id');
  if (!keys.length) return findById(id, artistId);
  const assignments = keys.map((k) => `${k} = ?`).join(', ');
  await db.query(`UPDATE comments SET ${assignments} WHERE id = ? AND artist_id = ?`, [...keys.map((k) => data[k]), id, artistId]);
  return findById(id, artistId);
}

async function remove(id, artistId) {
  await db.query(`UPDATE comments SET deleted_at = NOW() WHERE id = ? AND artist_id = ?`, [id, artistId]);
  return true;
}

async function countByReference(artistId, referenceType, referenceId) {
  const [row] = await db.query(`SELECT COUNT(*) AS total FROM comments WHERE artist_id = ? AND reference_type = ? AND reference_id = ? AND deleted_at IS NULL`, [artistId, referenceType, referenceId]);
  return row?.total || 0;
}

module.exports = { findAll, findById, create, update, remove, countByReference };

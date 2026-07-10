const db = require('../config/database');
const ArtistModel = require('../models/Artist.model');

function buildWhere({ status, genre, search } = {}) {
  const clauses = [];
  const params = [];
  if (status) {
    clauses.push('status = ?');
    params.push(status);
  }
  if (genre) {
    clauses.push('genre = ?');
    params.push(genre);
  }
  if (search) {
    clauses.push('(name LIKE ? OR real_name LIKE ?)');
    params.push(`%${search}%`, `%${search}%`);
  }
  return { clause: clauses.length ? `WHERE ${clauses.join(' AND ')}` : '', params };
}

async function findAll({ page = 1, limit = 20, status, genre, search } = {}) {
  const { clause, params } = buildWhere({ status, genre, search });
  const [{ total }] = await db.query(`SELECT COUNT(*) AS total FROM ${ArtistModel.tableName} ${clause}`, params);
  const offset = (parseInt(page, 10) - 1) * parseInt(limit, 10);
  const rows = await db.query(
    `SELECT id, slug, name, real_name, genre, country, city, status, logo_url, cover_url
     FROM ${ArtistModel.tableName} ${clause} ORDER BY created_at DESC LIMIT ? OFFSET ?`,
    [...params, parseInt(limit, 10), offset],
  );
  return { rows, total };
}

async function findBySlug(slug) {
  const [row] = await db.query(`SELECT * FROM ${ArtistModel.tableName} WHERE slug = ?`, [slug]);
  return row || null;
}

async function findById(id) {
  const [row] = await db.query(`SELECT * FROM ${ArtistModel.tableName} WHERE id = ?`, [id]);
  return row || null;
}

async function create(data) {
  const keys = Object.keys(data);
  const placeholders = keys.map(() => '?').join(', ');
  const [result] = await db.query(
    `INSERT INTO ${ArtistModel.tableName} (${keys.join(', ')}) VALUES (${placeholders})`,
    keys.map((k) => data[k]),
  );
  return findById(result.insertId);
}

async function update(id, data) {
  const keys = Object.keys(data).filter((k) => k !== 'id');
  if (!keys.length) return findById(id);
  const assignments = keys.map((k) => `${k} = ?`).join(', ');
  await db.query(`UPDATE ${ArtistModel.tableName} SET ${assignments} WHERE id = ?`, [...keys.map((k) => data[k]), id]);
  return findById(id);
}

async function getStats(artistId) {
  const [songs] = await db.query('SELECT COUNT(*) AS c FROM songs WHERE artist_id = ? AND deleted_at IS NULL', [artistId]);
  const [videos] = await db.query('SELECT COUNT(*) AS c FROM videos WHERE artist_id = ? AND deleted_at IS NULL', [artistId]);
  const [events] = await db.query('SELECT COUNT(*) AS c FROM events WHERE artist_id = ? AND deleted_at IS NULL', [artistId]);
  const [followers] = await db.query('SELECT COUNT(*) AS c FROM follows WHERE artist_id = ?', [artistId]);
  const [orders] = await db.query('SELECT COUNT(*) AS c, COALESCE(SUM(total),0) AS revenue FROM orders WHERE artist_id = ?', [artistId]);
  return {
    songs: songs.c,
    videos: videos.c,
    events: events.c,
    followers: followers.c,
    orders: orders.c,
    revenue: Number(orders.revenue || 0),
  };
}

module.exports = { findAll, findBySlug, findById, create, update, getStats };

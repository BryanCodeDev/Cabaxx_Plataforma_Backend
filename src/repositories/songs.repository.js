const db = require('../config/database');
const SongModel = require('../models/Song.model');

function buildWhere(artistId, { status, search, albumId } = {}) {
  const clauses = ['artist_id = ?', 'deleted_at IS NULL'];
  const params = [artistId];
  if (status) {
    clauses.push('status = ?');
    params.push(status);
  }
  if (albumId) {
    clauses.push('album_id = ?');
    params.push(albumId);
  }
  if (search) {
    clauses.push('title LIKE ?');
    params.push(`%${search}%`);
  }
  return { clause: `WHERE ${clauses.join(' AND ')}`, params };
}

async function findByArtist(artistId, { page = 1, limit = 20, status, search, albumId } = {}) {
  const { clause, params } = buildWhere(artistId, { status, search, albumId });
  const [{ total }] = await db.query(`SELECT COUNT(*) AS total FROM ${SongModel.tableName} ${clause}`, params);
  const offset = (parseInt(page, 10) - 1) * parseInt(limit, 10);
  const rows = await db.query(
    `SELECT * FROM ${SongModel.tableName} ${clause} ORDER BY created_at DESC LIMIT ? OFFSET ?`,
    [...params, parseInt(limit, 10), offset],
  );
  return { rows, total };
}

async function findBySlug(artistId, slug) {
  const [row] = await db.query(`SELECT * FROM ${SongModel.tableName} WHERE artist_id = ? AND slug = ? AND deleted_at IS NULL`, [artistId, slug]);
  return row || null;
}

async function findById(id, artistId) {
  let sql = `SELECT * FROM ${SongModel.tableName} WHERE id = ?`;
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
  const [result] = await db.query(
    `INSERT INTO ${SongModel.tableName} (${keys.join(', ')}) VALUES (${placeholders})`,
    keys.map((k) => data[k]),
  );
  return findById(result.insertId);
}

async function update(id, data, artistId) {
  const keys = Object.keys(data).filter((k) => k !== 'id');
  if (!keys.length) return findById(id, artistId);
  const assignments = keys.map((k) => `${k} = ?`).join(', ');
  let sql = `UPDATE ${SongModel.tableName} SET ${assignments} WHERE id = ?`;
  const params = keys.map((k) => data[k]);
  params.push(id);
  if (artistId) {
    sql += ' AND artist_id = ?';
    params.push(artistId);
  }
  await db.query(sql, params);
  return findById(id, artistId);
}

// Soft delete
async function remove(id, artistId) {
  let sql = `UPDATE ${SongModel.tableName} SET deleted_at = NOW() WHERE id = ?`;
  const params = [id];
  if (artistId) {
    sql += ' AND artist_id = ?';
    params.push(artistId);
  }
  const [result] = await db.query(sql, params);
  return result.affectedRows > 0;
}

async function incrementPlays(songId, userId, data = {}) {
  await db.query(
    `INSERT INTO song_plays (song_id, artist_id, user_id, source, duration_played_seconds, completed)
     VALUES (?, (SELECT artist_id FROM songs WHERE id = ?), ?, ?, ?, ?)`,
    [songId, songId, userId || null, data.source || 'web', data.durationPlayedSeconds || 0, data.completed || false],
  );
  await db.query(`UPDATE ${SongModel.tableName} SET plays_count = plays_count + 1 WHERE id = ?`, [songId]);
}

async function getTopSongs(artistId, limit = 10) {
  return db.query(
    `SELECT id, title, slug, cover_url, plays_count FROM ${SongModel.tableName} WHERE artist_id = ? AND deleted_at IS NULL ORDER BY plays_count DESC LIMIT ?`,
    [artistId, limit],
  );
}

async function findStreamingLinks(songId) {
  return db.query('SELECT platform, url FROM song_streaming_links WHERE song_id = ?', [songId]);
}

module.exports = { findByArtist, findBySlug, findById, create, update, remove, incrementPlays, getTopSongs, findStreamingLinks };

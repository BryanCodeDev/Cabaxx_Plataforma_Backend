const db = require('../config/database');
const AlbumModel = require('../models/Album.model');
const AlbumSongModel = require('../models/AlbumSong.model');

function buildWhere(artistId, { status, type, search } = {}) {
  const clauses = ['artist_id = ?', 'deleted_at IS NULL'];
  const params = [artistId];
  if (status) {
    clauses.push('status = ?');
    params.push(status);
  }
  if (type) {
    clauses.push('type = ?');
    params.push(type);
  }
  if (search) {
    clauses.push('title LIKE ?');
    params.push(`%${search}%`);
  }
  return { clause: `WHERE ${clauses.join(' AND ')}`, params };
}

async function findByArtist(artistId, { page = 1, limit = 20, status, type, search } = {}) {
  const { clause, params } = buildWhere(artistId, { status, type, search });
  const [{ total }] = await db.query(`SELECT COUNT(*) AS total FROM ${AlbumModel.tableName} ${clause}`, params);
  const offset = (parseInt(page, 10) - 1) * parseInt(limit, 10);
  const rows = await db.query(`SELECT * FROM ${AlbumModel.tableName} ${clause} ORDER BY release_date DESC LIMIT ? OFFSET ?`, [...params, parseInt(limit, 10), offset]);
  return { rows, total };
}

async function findBySlug(artistId, slug) {
  const [album] = await db.query(`SELECT * FROM ${AlbumModel.tableName} WHERE artist_id = ? AND slug = ? AND deleted_at IS NULL`, [artistId, slug]);
  if (!album) return null;
  album.songs = await db.query(
    `SELECT s.id, s.title, s.slug, s.cover_url, s.duration_seconds, als.track_number, als.disc_number
     FROM ${AlbumSongModel.tableName} als
     JOIN songs s ON s.id = als.song_id
     WHERE als.album_id = ? ORDER BY als.disc_number, als.track_number`,
    [album.id],
  );
  return album;
}

async function findById(id, artistId) {
  let sql = `SELECT * FROM ${AlbumModel.tableName} WHERE id = ?`;
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
  const [result] = await db.query(`INSERT INTO ${AlbumModel.tableName} (${keys.join(', ')}) VALUES (${placeholders})`, keys.map((k) => data[k]));
  return findById(result.insertId);
}

async function update(id, data, artistId) {
  const keys = Object.keys(data).filter((k) => k !== 'id');
  if (!keys.length) return findById(id, artistId);
  const assignments = keys.map((k) => `${k} = ?`).join(', ');
  let sql = `UPDATE ${AlbumModel.tableName} SET ${assignments} WHERE id = ?`;
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
  let sql = `UPDATE ${AlbumModel.tableName} SET deleted_at = NOW() WHERE id = ?`;
  const params = [id];
  if (artistId) {
    sql += ' AND artist_id = ?';
    params.push(artistId);
  }
  const [result] = await db.query(sql, params);
  return result.affectedRows > 0;
}

async function addSong(albumId, songId, trackNumber, discNumber = 1) {
  await db.query(
    `INSERT INTO ${AlbumSongModel.tableName} (album_id, song_id, track_number, disc_number) VALUES (?, ?, ?, ?)
     ON DUPLICATE KEY UPDATE track_number = ?, disc_number = ?`,
    [albumId, songId, trackNumber, discNumber, trackNumber, discNumber],
  );
  return true;
}

async function removeSong(albumId, songId) {
  const [result] = await db.query(`DELETE FROM ${AlbumSongModel.tableName} WHERE album_id = ? AND song_id = ?`, [albumId, songId]);
  return result.affectedRows > 0;
}

// Reordenar: recibe [{song_id, track_number}]
async function reorderSongs(albumId, songsOrder = []) {
  for (const item of songsOrder) {
    await db.query(`UPDATE ${AlbumSongModel.tableName} SET track_number = ? WHERE album_id = ? AND song_id = ?`, [item.track_number, albumId, item.song_id]);
  }
  return true;
}

module.exports = { findByArtist, findBySlug, findById, create, update, remove, addSong, removeSong, reorderSongs };

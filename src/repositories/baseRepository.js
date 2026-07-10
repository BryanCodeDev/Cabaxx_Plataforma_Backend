const db = require('../config/database');

class BaseRepository {
  constructor(model) {
    this.model = model;
    this.table = model.tableName;
  }

  async findById(id, artistId = null) {
    let sql = `SELECT * FROM ${this.table} WHERE id = ?`;
    const params = [id];
    if (artistId) {
      sql += ' AND artist_id = ?';
      params.push(artistId);
    }
    const [row] = await db.query(sql, params);
    return row || null;
  }

  async findAll({ artistId = null, page = 1, limit = 20, where = {}, orderBy = 'created_at DESC' } = {}) {
    const params = [];
    let sql = `SELECT * FROM ${this.table}`;
    const clauses = [];
    if (artistId) {
      clauses.push('artist_id = ?');
      params.push(artistId);
    }
    Object.entries(where).forEach(([k, v]) => {
      clauses.push(`${k} = ?`);
      params.push(v);
    });
    if (clauses.length) sql += ` WHERE ${clauses.join(' AND ')}`;
    const countSql = `SELECT COUNT(*) AS total FROM ${this.table}${clauses.length ? ` WHERE ${clauses.join(' AND ')}` : ''}`;
    const [{ total }] = await db.query(countSql, params);
    const offset = (parseInt(page, 10) - 1) * parseInt(limit, 10);
    sql += ` ORDER BY ${orderBy} LIMIT ? OFFSET ?`;
    const rows = await db.query(sql, [...params, parseInt(limit, 10), offset]);
    return { rows, total };
  }

  async create(data) {
    const keys = Object.keys(data);
    const placeholders = keys.map(() => '?').join(', ');
    const sql = `INSERT INTO ${this.table} (${keys.join(', ')}) VALUES (${placeholders})`;
    const [result] = await db.query(sql, keys.map((k) => data[k]));
    return this.findById(result.insertId, data.artist_id);
  }

  async update(id, data, artistId = null) {
    const keys = Object.keys(data).filter((k) => k !== 'id');
    if (!keys.length) return this.findById(id, artistId);
    const assignments = keys.map((k) => `${k} = ?`).join(', ');
    let sql = `UPDATE ${this.table} SET ${assignments} WHERE id = ?`;
    const params = keys.map((k) => data[k]);
    params.push(id);
    if (artistId) {
      sql += ' AND artist_id = ?';
      params.push(artistId);
    }
    await db.query(sql, params);
    return this.findById(id, artistId);
  }

  async remove(id, artistId = null) {
    let sql = `DELETE FROM ${this.table} WHERE id = ?`;
    const params = [id];
    if (artistId) {
      sql += ' AND artist_id = ?';
      params.push(artistId);
    }
    const [result] = await db.query(sql, params);
    return result.affectedRows > 0;
  }
}

module.exports = BaseRepository;

const db = require('../config/database');
const UserModel = require('../models/User.model');

async function findByEmail(email) {
  const [row] = await db.query(`SELECT * FROM ${UserModel.tableName} WHERE email = ?`, [email]);
  return row || null;
}

async function findById(id) {
  const [row] = await db.query(`SELECT * FROM ${UserModel.tableName} WHERE id = ?`, [id]);
  return row || null;
}

async function create({ email, passwordHash, role, artistId, firstName, lastName }) {
  const [result] = await db.query(
    `INSERT INTO ${UserModel.tableName} (artist_id, email, password_hash, role, first_name, last_name, is_active)
     VALUES (?, ?, ?, ?, ?, ?, ?)`,
    [artistId || null, email, passwordHash, role, firstName || null, lastName || null, true],
  );
  return findById(result.insertId);
}

async function updatePassword(id, passwordHash) {
  await db.query(`UPDATE ${UserModel.tableName} SET password_hash = ? WHERE id = ?`, [passwordHash, id]);
  return findById(id);
}

module.exports = { findByEmail, findById, create, updatePassword };

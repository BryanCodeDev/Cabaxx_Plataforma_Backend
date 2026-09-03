const db = require('../config/database');
const UserModel = require('../models/User.model');

async function findByEmail(email) {
  const [row] = await db.query(`SELECT * FROM ${UserModel.tableName} WHERE email = ?`, [email]);
  return row || null;
}

async function findRolesByUserId(userId) {
  const rows = await db.query(
    `SELECT r.slug AS role, ur.artist_id AS artistId
     FROM user_roles ur
     JOIN roles r ON r.id = ur.role_id
     WHERE ur.user_id = ?`,
    [userId],
  );
  return rows;
}

async function findById(id) {
  const [row] = await db.query(`SELECT * FROM ${UserModel.tableName} WHERE id = ?`, [id]);
  return row || null;
}

async function create({ email, passwordHash, name }) {
  const [result] = await db.query(
    `INSERT INTO ${UserModel.tableName} (name, email, password_hash, status)
     VALUES (?, ?, ?, ?)`,
    [name, email, passwordHash, 'active'],
  );
  return findById(result.insertId);
}

async function updatePassword(id, passwordHash) {
  await db.query(`UPDATE ${UserModel.tableName} SET password_hash = ? WHERE id = ?`, [passwordHash, id]);
  return findById(id);
}

async function createPasswordReset(email, tokenHash) {
  await db.query(
    `INSERT INTO password_resets (email, token_hash, expires_at)
     VALUES (?, ?, DATE_ADD(NOW(), INTERVAL 1 HOUR))`,
    [email, tokenHash],
  );
}

async function findPasswordReset(tokenHash) {
  const [row] = await db.query(
    `SELECT * FROM password_resets WHERE token_hash = ? ORDER BY id DESC LIMIT 1`,
    [tokenHash],
  );
  return row || null;
}

async function markPasswordResetUsed(tokenHash) {
  await db.query(
    `UPDATE password_resets SET used_at = NOW() WHERE token_hash = ? AND used_at IS NULL`,
    [tokenHash],
  );
}

module.exports = {
  findByEmail, findById, findRolesByUserId, create, updatePassword,
  createPasswordReset, findPasswordReset, markPasswordResetUsed,
};

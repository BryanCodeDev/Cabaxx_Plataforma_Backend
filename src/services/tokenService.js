const db = require('../config/database');

async function storeRefreshToken(userId, tokenHash, expiresAt) {
  await db.query(
    `INSERT INTO refresh_tokens (user_id, token_hash, expires_at) VALUES (?, ?, ?)`,
    [userId, tokenHash, expiresAt],
  );
}

async function findRefreshToken(tokenHash) {
  const [row] = await db.query(`SELECT * FROM refresh_tokens WHERE token_hash = ? AND revoked = ?`, [tokenHash, false]);
  return row || null;
}

async function revokeRefreshToken(tokenHash) {
  await db.query(`UPDATE refresh_tokens SET revoked = ? WHERE token_hash = ?`, [true, tokenHash]);
}

async function revokeAllForUser(userId) {
  await db.query(`UPDATE refresh_tokens SET revoked = ? WHERE user_id = ?`, [true, userId]);
}

module.exports = { storeRefreshToken, findRefreshToken, revokeRefreshToken, revokeAllForUser };

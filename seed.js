/* eslint-disable no-console */
const mysql = require('mysql2/promise');
const bcrypt = require('bcrypt');
const fs = require('fs');
const path = require('path');
require('dotenv').config();

const { resolveConnection, runSqlFile, splitSqlStatements, ensureDatabase } = require('./migrate');

function parseMysqlUrl(urlString) {
  if (!urlString) return null;
  try {
    const u = new URL(urlString);
    if (!u.protocol.startsWith('mysql')) return null;
    return {
      host: u.hostname,
      port: Number(u.port) || 3306,
      user: decodeURIComponent(u.username),
      password: decodeURIComponent(u.password),
      database: u.pathname.replace(/^\//, ''),
    };
  } catch (e) {
    return null;
  }
}

async function ensureAdminUser(conn, { email, name, password }) {
  const hash = await bcrypt.hash(password, 10);
  await conn.query(
    `INSERT INTO users (name, email, password_hash, status)
     VALUES (?, ?, ?, 'active')
     ON DUPLICATE KEY UPDATE password_hash=VALUES(password_hash), status='active'`,
    [name, email, hash]
  );
  console.log(`  ✓ admin user upserted: ${email}`);
}

async function main() {
  const cfg = resolveConnection();
  const baseDir = __dirname;

  await ensureDatabase(cfg);

  const conn = await mysql.createConnection({
    ...cfg,
    multipleStatements: true,
  });

  try {
    console.log('[seed] Connecting to MySQL...');
    await conn.query(`USE \`${cfg.database}\`;`);

    const adminEmail = process.env.ADMIN_EMAIL || 'admin@cabaxx.com';
    const adminName = process.env.ADMIN_NAME || 'Cabaxx Admin';
    const adminPassword = process.env.ADMIN_PASSWORD || 'Cabaxx2024!';

    if (!process.env.ADMIN_PASSWORD) {
      console.warn(`[seed] ADMIN_PASSWORD not set — using default "${adminPassword}".`);
      console.warn('[seed] Set ADMIN_PASSWORD in your env to override.');
    }

    console.log('[seed] Ensuring admin user...');
    await ensureAdminUser(conn, { email: adminEmail, name: adminName, password: adminPassword });

    const seedFile = path.join(baseDir, 'seed_data.sql');
    if (fs.existsSync(seedFile)) {
      console.log('[seed] Applying seed_data.sql...');
      const n = await runSqlFile(conn, seedFile, 'seed_data.sql');
      console.log(`[seed] seed_data.sql: ${n} statements applied.`);
    } else {
      console.warn('[seed] seed_data.sql not found, skipping.');
    }

    console.log('[seed] Done.');
  } catch (err) {
    console.error('[seed] FAILED:', err.message);
    process.exitCode = 1;
  } finally {
    await conn.end();
  }
}

if (require.main === module) {
  main();
}

module.exports = { main, ensureAdminUser, parseMysqlUrl, splitSqlStatements };

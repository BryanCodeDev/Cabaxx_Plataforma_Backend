/* eslint-disable no-console */
const mysql = require('mysql2/promise');
const bcrypt = require('bcrypt');
const fs = require('fs');
const path = require('path');
require('dotenv').config();

const { resolveConnection, runSqlFile, splitSqlStatements, ensureDatabase, connectWithRetry } = require('./migrate');

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

  console.log('[seed] DB target:', {
    host: cfg.host,
    port: cfg.port,
    user: cfg.user,
    database: cfg.database,
    ssl: cfg.ssl ? 'enabled' : 'disabled',
  });
  if (cfg.host === 'localhost' && !process.env.DB_HOST) {
    console.warn(
      '[seed] WARNING: connecting to localhost. Set DATABASE_URL, MYSQL_URL, or DB_HOST/DB_PORT/DB_USER/DB_PASSWORD/DB_NAME in your environment.'
    );
  }

  await ensureDatabase(cfg);

  const conn = await connectWithRetry(cfg);

  try {
    console.log('[seed] Connected.');
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

module.exports = { main, ensureAdminUser, splitSqlStatements };

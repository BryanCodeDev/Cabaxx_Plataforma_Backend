/* eslint-disable no-console */
const mysql = require('mysql2/promise');
const fs = require('fs');
const path = require('path');
require('dotenv').config();

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

function resolveConnection() {
  const fromUrl = parseMysqlUrl(process.env.DATABASE_URL || process.env.MYSQL_URL);
  if (fromUrl) {
    return {
      ...fromUrl,
      ssl: process.env.DB_SSL === 'true' || (process.env.NODE_ENV === 'production') ? { rejectUnauthorized: false } : false,
    };
  }
  return {
    host: process.env.DB_HOST || 'localhost',
    port: Number(process.env.DB_PORT) || 3306,
    user: process.env.DB_USER || 'root',
    password: process.env.DB_PASSWORD || '',
    database: process.env.DB_NAME || 'map_platform',
  };
}

function splitSqlStatements(sql) {
  return sql
    .split(/;\s*(?:\r?\n|$)/)
    .map((s) => s.replace(/^--.*$/gm, '').trim())
    .filter((s) => {
      if (!s) return false;
      const upper = s.toUpperCase();
      if (upper.startsWith('CREATE DATABASE')) return false;
      if (upper.startsWith('USE ')) return false;
      return true;
    });
}

async function ensureDatabase(cfg) {
  const { database, ...serverCfg } = cfg;
  const root = await mysql.createConnection({
    ...serverCfg,
    multipleStatements: true,
  });
  try {
    console.log(`[migrate] Ensuring database \`${database}\` exists...`);
    await root.query(
      `CREATE DATABASE IF NOT EXISTS \`${database}\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;`
    );
  } finally {
    await root.end();
  }
}

async function runSqlFile(conn, filePath, label) {
  if (!fs.existsSync(filePath)) {
    console.warn(`[migrate] ${label} not found at ${filePath} — skipping.`);
    return 0;
  }
  const raw = fs.readFileSync(filePath, 'utf8');
  const statements = splitSqlStatements(raw);
  let applied = 0;
  for (const stmt of statements) {
    const head = stmt.slice(0, 60).replace(/\s+/g, ' ');
    try {
      await conn.query(stmt);
      applied += 1;
      console.log(`  ✓ ${head}${stmt.length > 60 ? '…' : ''}`);
    } catch (err) {
      console.error(`  ✗ ${head}  →  ${err.code || err.message}`);
      throw err;
    }
  }
  return applied;
}

async function main() {
  const cfg = resolveConnection();
  const baseDir = __dirname;

  await ensureDatabase(cfg);

  const conn = await mysql.createConnection({
    ...cfg,
    multipleStatements: true,
  });

  let total = 0;
  try {
    console.log('[migrate] Connecting to MySQL...');
    await conn.query(`USE \`${cfg.database}\`;`);

    const files = [
      { path: path.join(baseDir, 'database.sql'), label: 'schema (database.sql)' },
    ];

    for (const f of files) {
      console.log(`[migrate] Applying ${f.label}...`);
      const n = await runSqlFile(conn, f.path, f.label);
      console.log(`[migrate] ${f.label}: ${n} statements applied.`);
      total += n;
    }

    console.log(`[migrate] Done. ${total} statements applied.`);
  } catch (err) {
    console.error('[migrate] FAILED:', err.message);
    process.exitCode = 1;
  } finally {
    await conn.end();
  }
}

if (require.main === module) {
  main();
}

module.exports = { main, runSqlFile, splitSqlStatements, resolveConnection, ensureDatabase };

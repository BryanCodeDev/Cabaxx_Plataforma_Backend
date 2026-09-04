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
  const urlString =
    process.env.DATABASE_URL ||
    process.env.MYSQL_URL ||
    process.env.MYSQL_PUBLIC_URL ||
    process.env.MYSQLDATABASE_URL;
  const fromUrl = parseMysqlUrl(urlString);
  if (fromUrl) {
    const useSsl =
      process.env.DB_SSL === 'true' || process.env.NODE_ENV === 'production';
    return {
      ...fromUrl,
      ssl: useSsl ? { rejectUnauthorized: false } : false,
    };
  }

  const host =
    process.env.MYSQLHOST ||
    process.env.MYSQL_HOST ||
    process.env.RAILWAY_PRIVATE_DOMAIN ||
    process.env.DB_HOST;

  const user =
    process.env.MYSQLUSER ||
    process.env.MYSQL_USER ||
    process.env.DB_USER;

  if (host && user) {
    const useSsl =
      process.env.DB_SSL === 'true' || process.env.NODE_ENV === 'production';
    return {
      host,
      port: Number(process.env.MYSQLPORT || process.env.MYSQL_PORT || process.env.DB_PORT) || 3306,
      user,
      password:
        process.env.MYSQLPASSWORD ||
        process.env.MYSQL_PASSWORD ||
        process.env.MYSQL_ROOT_PASSWORD ||
        process.env.DB_PASSWORD ||
        '',
      database:
        process.env.MYSQLDATABASE ||
        process.env.MYSQL_DATABASE ||
        process.env.MYSQL_DATABASE_NAME ||
        process.env.DB_NAME ||
        'railway',
      ssl: useSsl ? { rejectUnauthorized: false } : false,
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
  const root = await connectWithRetry(serverOnly(cfg));
  try {
    console.log(`[migrate] Ensuring database \`${cfg.database}\` exists...`);
    await root.query(
      `CREATE DATABASE IF NOT EXISTS \`${cfg.database}\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;`
    );
  } finally {
    await root.end();
  }
}

function serverOnly(cfg) {
  const { host, port, user, password, ssl } = cfg;
  return { host, port, user, password, ssl };
}

function summarizeConn(cfg) {
  return {
    host: cfg.host,
    port: cfg.port,
    user: cfg.user,
    database: cfg.database,
    ssl: cfg.ssl ? 'enabled' : 'disabled',
  };
}

function describeEnv() {
  const keys = [
    'DATABASE_URL',
    'MYSQL_URL',
    'MYSQL_PUBLIC_URL',
    'MYSQLDATABASE_URL',
    'MYSQLHOST',
    'MYSQL_HOST',
    'MYSQLUSER',
    'MYSQL_USER',
    'MYSQLPASSWORD',
    'MYSQL_PASSWORD',
    'MYSQL_ROOT_PASSWORD',
    'MYSQLPORT',
    'MYSQL_PORT',
    'MYSQLDATABASE',
    'MYSQL_DATABASE',
    'RAILWAY_PRIVATE_DOMAIN',
    'DB_HOST',
    'DB_PORT',
    'DB_USER',
    'DB_PASSWORD',
    'DB_NAME',
  ];
  return keys.reduce((acc, k) => {
    if (process.env[k]) acc[k] = '***';
    return acc;
  }, {});
}

async function connectWithRetry(cfg, { tries = 15, delayMs = 2000 } = {}) {
  let lastErr;
  for (let i = 1; i <= tries; i += 1) {
    try {
      const conn = await mysql.createConnection({
        ...cfg,
        multipleStatements: true,
        connectTimeout: 8000,
      });
      return conn;
    } catch (err) {
      lastErr = err;
      console.warn(
        `[migrate] DB not ready (attempt ${i}/${tries}) — ${err.code || err.message}. Retrying in ${delayMs}ms…`
      );
      await new Promise((r) => setTimeout(r, delayMs));
    }
  }
  throw lastErr;
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

  console.log('[migrate] DB env keys present:', describeEnv());
  console.log('[migrate] DB target:', summarizeConn(cfg));

  const hasAnyReal =
    process.env.DATABASE_URL ||
    process.env.MYSQL_URL ||
    process.env.MYSQLHOST ||
    process.env.MYSQL_HOST ||
    process.env.RAILWAY_PRIVATE_DOMAIN;

  if (!hasAnyReal && cfg.host === 'localhost') {
    console.error(
      '[migrate] FATAL: no real database configuration found.\n' +
        '  - If you are on Railway, link your MySQL service to this backend service (Service → Variables → "Add Reference" → pick the MySQL service), or\n' +
        '  - Set DATABASE_URL=mysql://user:pass@host:3306/db on this service.'
    );
    process.exit(2);
  }

  if (cfg.host.endsWith('.railway.internal') && cfg.host !== process.env.RAILWAY_PRIVATE_DOMAIN) {
    console.warn(
      `[migrate] WARNING: host "${cfg.host}" looks like the *backend* service internal domain, not the MySQL one. ` +
        'Set DATABASE_URL to mysql://root:<password>@<MYSQL_PRIVATE_DOMAIN>:3306/<db> on this service.'
    );
  }

  await ensureDatabase(cfg);

  const conn = await connectWithRetry(cfg);

  let total = 0;
  try {
    console.log('[migrate] Connected. Applying schema...');
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

module.exports = {
  main,
  runSqlFile,
  splitSqlStatements,
  resolveConnection,
  ensureDatabase,
  connectWithRetry,
  summarizeConn,
};

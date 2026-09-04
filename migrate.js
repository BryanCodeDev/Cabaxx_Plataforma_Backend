/* eslint-disable no-console */

const mysql = require('mysql2/promise');
const fs = require('fs');
const path = require('path');

require('dotenv').config();

/**
 * ==========================================
 * DATABASE CONFIGURATION
 * ==========================================
 *
 * Railway Backend variables:
 *
 * DB_HOST
 * DB_PORT
 * DB_USER
 * DB_PASSWORD
 * DB_NAME
 * DB_SSL
 *
 * These variables should reference the MySQL
 * service in Railway.
 */

function resolveConnection() {
  const host = process.env.DB_HOST;
  const port = Number(process.env.DB_PORT || 3306);
  const user = process.env.DB_USER;
  const password = process.env.DB_PASSWORD;
  const database = process.env.DB_NAME || 'railway';

  const sslEnabled = process.env.DB_SSL === 'true';

  if (!host) {
    throw new Error(
      'Database configuration error: DB_HOST is missing.'
    );
  }

  if (!user) {
    throw new Error(
      'Database configuration error: DB_USER is missing.'
    );
  }

  if (!password) {
    throw new Error(
      'Database configuration error: DB_PASSWORD is missing.'
    );
  }

  return {
    host,
    port,
    user,
    password,
    database,
    ssl: sslEnabled
      ? {
          rejectUnauthorized: false,
        }
      : false,
  };
}

/**
 * ==========================================
 * ENVIRONMENT INFORMATION
 * ==========================================
 *
 * Never print passwords or secrets.
 */

function describeEnv() {
  const keys = [
    'NODE_ENV',
    'PORT',

    'DB_HOST',
    'DB_PORT',
    'DB_USER',
    'DB_PASSWORD',
    'DB_NAME',
    'DB_SSL',
    'DB_CONNECTION_LIMIT',

    'DATABASE_URL',

    'MYSQL_URL',
    'MYSQL_PUBLIC_URL',
    'MYSQLDATABASE_URL',

    'MYSQLHOST',
    'MYSQLUSER',
    'MYSQLPASSWORD',
    'MYSQLPORT',
    'MYSQLDATABASE',

    'RAILWAY_PRIVATE_DOMAIN',
  ];

  return keys.reduce((acc, key) => {
    if (process.env[key]) {
      acc[key] = '***';
    }

    return acc;
  }, {});
}

/**
 * ==========================================
 * CONNECTION SUMMARY
 * ==========================================
 */

function summarizeConn(cfg) {
  return {
    host: cfg.host,
    port: cfg.port,
    user: cfg.user,
    database: cfg.database,
    ssl: cfg.ssl ? 'enabled' : 'disabled',
  };
}

/**
 * ==========================================
 * SERVER-ONLY CONNECTION
 * ==========================================
 *
 * Used to create the database if necessary.
 */

function serverOnly(cfg) {
  const {
    host,
    port,
    user,
    password,
    ssl,
  } = cfg;

  return {
    host,
    port,
    user,
    password,
    ssl,
  };
}

/**
 * ==========================================
 * MYSQL CONNECTION WITH RETRIES
 * ==========================================
 */

async function connectWithRetry(
  cfg,
  {
    tries = 15,
    delayMs = 2000,
  } = {}
) {
  let lastErr;

  for (let attempt = 1; attempt <= tries; attempt += 1) {
    try {
      console.log(
        `[migrate] Connecting to MySQL ` +
        `${cfg.host}:${cfg.port} ` +
        `(attempt ${attempt}/${tries})...`
      );

      const connection = await mysql.createConnection({
        ...cfg,

        multipleStatements: true,

        connectTimeout: 8000,
      });

      console.log('[migrate] MySQL connection established.');

      return connection;
    } catch (error) {
      lastErr = error;

      console.warn(
        `[migrate] DB not ready ` +
        `(attempt ${attempt}/${tries}) — ` +
        `${error.code || error.message}. ` +
        `Retrying in ${delayMs}ms...`
      );

      if (attempt < tries) {
        await new Promise((resolve) => {
          setTimeout(resolve, delayMs);
        });
      }
    }
  }

  throw lastErr;
}

/**
 * ==========================================
 * ENSURE DATABASE EXISTS
 * ==========================================
 */

async function ensureDatabase(cfg) {
  console.log(
    `[migrate] Ensuring database "${cfg.database}" exists...`
  );

  const connection = await connectWithRetry(
    serverOnly(cfg)
  );

  try {
    const databaseName = cfg.database.replace(/`/g, '``');

    await connection.query(
      `CREATE DATABASE IF NOT EXISTS \`${databaseName}\`
       CHARACTER SET utf8mb4
       COLLATE utf8mb4_unicode_ci`
    );

    console.log(
      `[migrate] Database "${cfg.database}" is ready.`
    );
  } finally {
    await connection.end();
  }
}

/**
 * ==========================================
 * SQL PARSER
 * ==========================================
 */

function splitSqlStatements(sql) {
  return sql
    .split(/;\s*(?:\r?\n|$)/)
    .map((statement) =>
      statement
        .replace(/^--.*$/gm, '')
        .trim()
    )
    .filter((statement) => {
      if (!statement) {
        return false;
      }

      const upper = statement.toUpperCase();

      if (upper.startsWith('CREATE DATABASE')) {
        return false;
      }

      if (upper.startsWith('USE ')) {
        return false;
      }

      return true;
    });
}

/**
 * ==========================================
 * RUN SQL FILE
 * ==========================================
 */

async function runSqlFile(
  connection,
  filePath,
  label
) {
  if (!fs.existsSync(filePath)) {
    console.warn(
      `[migrate] ${label} not found at ${filePath} — skipping.`
    );

    return 0;
  }

  console.log(
    `[migrate] Reading ${label}...`
  );

  const raw = fs.readFileSync(
    filePath,
    'utf8'
  );

  const statements = splitSqlStatements(raw);

  console.log(
    `[migrate] ${label}: ` +
    `${statements.length} SQL statements found.`
  );

  let applied = 0;

  for (
    const statement of statements
  ) {
    const head = statement
      .slice(0, 100)
      .replace(/\s+/g, ' ');

    try {
      await connection.query(statement);

      applied += 1;

      console.log(
        `  ✓ ${head}` +
        `${statement.length > 100 ? '...' : ''}`
      );
    } catch (error) {
      console.error(
        `  ✗ ${head} → ` +
        `${error.code || error.message}`
      );

      throw error;
    }
  }

  return applied;
}

/**
 * ==========================================
 * VALIDATE CONFIGURATION
 * ==========================================
 */

function validateConfiguration() {
  const required = [
    'DB_HOST',
    'DB_PORT',
    'DB_USER',
    'DB_PASSWORD',
    'DB_NAME',
  ];

  const missing = required.filter(
    (key) => !process.env[key]
  );

  if (missing.length > 0) {
    throw new Error(
      `Missing required database variables: ` +
      `${missing.join(', ')}`
    );
  }
}

/**
 * ==========================================
 * MAIN MIGRATION
 * ==========================================
 */

async function main() {
  console.log(
    '=========================================='
  );

  console.log(
    '[migrate] Starting database migration...'
  );

  console.log(
    `[migrate] NODE_ENV=${process.env.NODE_ENV || 'undefined'}`
  );

  console.log(
    '=========================================='
  );

  /**
   * Validate DB variables.
   */
  try {
    validateConfiguration();
  } catch (error) {
    console.error(
      '[migrate] FATAL CONFIGURATION ERROR:'
    );

    console.error(error.message);

    process.exit(2);
  }

  /**
   * Resolve database configuration.
   */
  let cfg;

  try {
    cfg = resolveConnection();
  } catch (error) {
    console.error(
      '[migrate] FATAL DATABASE CONFIGURATION ERROR:'
    );

    console.error(error.message);

    process.exit(2);
  }

  /**
   * Print safe environment information.
   */
  console.log(
    '[migrate] DB env keys present:',
    describeEnv()
  );

  console.log(
    '[migrate] DB target:',
    summarizeConn(cfg)
  );

  /**
   * Safety check:
   *
   * The backend must NEVER use its own
   * Railway private domain as MySQL host.
   */

  if (
    process.env.RAILWAY_PRIVATE_DOMAIN &&
    cfg.host === process.env.RAILWAY_PRIVATE_DOMAIN
  ) {
    console.error(
      '[migrate] FATAL: DB_HOST is pointing to ' +
      'the Backend private domain.'
    );

    console.error(
      `[migrate] Backend domain: ${process.env.RAILWAY_PRIVATE_DOMAIN}`
    );

    console.error(
      '[migrate] DB_HOST must point to the MySQL service, ' +
      'for example: mysql.railway.internal'
    );

    process.exit(2);
  }

  /**
   * Ensure database exists.
   */
  await ensureDatabase(cfg);

  /**
   * Connect to the selected database.
   */
  const connection = await connectWithRetry(cfg);

  let total = 0;

  try {
    console.log(
      `[migrate] Selecting database "${cfg.database}"...`
    );

    await connection.query(
      `USE \`${cfg.database.replace(/`/g, '``')}\`;`
    );

    console.log(
      '[migrate] Database selected successfully.'
    );

    /**
     * SQL files to execute.
     */
    const files = [
      {
        path: path.join(
          __dirname,
          'database.sql'
        ),
        label: 'schema (database.sql)',
      },
    ];

    /**
     * Apply each SQL file.
     */
    for (const file of files) {
      console.log(
        `[migrate] Applying ${file.label}...`
      );

      const applied = await runSqlFile(
        connection,
        file.path,
        file.label
      );

      console.log(
        `[migrate] ${file.label}: ` +
        `${applied} statements applied.`
      );

      total += applied;
    }

    console.log(
      '=========================================='
    );

    console.log(
      `[migrate] Migration completed successfully.`
    );

    console.log(
      `[migrate] Total statements applied: ${total}`
    );

    console.log(
      '=========================================='
    );
  } catch (error) {
    console.error(
      '=========================================='
    );

    console.error(
      '[migrate] MIGRATION FAILED'
    );

    console.error(
      error.message
    );

    console.error(
      '=========================================='
    );

    process.exitCode = 1;
  } finally {
    await connection.end();

    console.log(
      '[migrate] MySQL connection closed.'
    );
  }
}

/**
 * ==========================================
 * RUN
 * ==========================================
 */

if (require.main === module) {
  main().catch((error) => {
    console.error(
      '[migrate] UNHANDLED ERROR:',
      error
    );

    process.exit(1);
  });
}

/**
 * ==========================================
 * EXPORTS
 * ==========================================
 */

module.exports = {
  main,
  resolveConnection,
  validateConfiguration,
  ensureDatabase,
  connectWithRetry,
  runSqlFile,
  splitSqlStatements,
  summarizeConn,
};
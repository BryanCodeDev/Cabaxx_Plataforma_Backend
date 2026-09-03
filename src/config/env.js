require('dotenv').config();

const required = [
  'NODE_ENV',
  'PORT',
  'DB_HOST',
  'DB_NAME',
  'DB_USER',
  'DB_PASSWORD',
  'JWT_ACCESS_SECRET',
  'JWT_REFRESH_SECRET',
];

const missing = required.filter((key) => !process.env[key]);
const isProd = (process.env.NODE_ENV || 'development') === 'production';

if (missing.length) {
  // eslint-disable-next-line no-console
  console.warn(`[env] Missing recommended variables: ${missing.join(', ')}`);
}

if (isProd) {
  const weakSecrets = [];
  if (!process.env.JWT_ACCESS_SECRET || process.env.JWT_ACCESS_SECRET.length < 32) {
    weakSecrets.push('JWT_ACCESS_SECRET (must be >= 32 chars)');
  }
  if (!process.env.JWT_REFRESH_SECRET || process.env.JWT_REFRESH_SECRET.length < 32) {
    weakSecrets.push('JWT_REFRESH_SECRET (must be >= 32 chars)');
  }
  if (weakSecrets.length) {
    // eslint-disable-next-line no-console
    console.error(`[env] Insecure configuration in production: ${weakSecrets.join('; ')}`);
    process.exit(1);
  }
}

const env = {
  nodeEnv: process.env.NODE_ENV || 'development',
  port: Number(process.env.PORT) || 4000,
  apiPrefix: process.env.API_PREFIX || '/api/v1',
  isProduction: (process.env.NODE_ENV || 'development') === 'production',

  db: {
    host: process.env.DB_HOST || process.env.MYSQLHOST || 'localhost',
    port: Number(process.env.DB_PORT || process.env.MYSQLPORT) || 3306,
    name: process.env.DB_NAME || process.env.MYSQLDATABASE || process.env.MYSQL_DATABASE || 'map_db',
    user: process.env.DB_USER || process.env.MYSQLUSER || 'map_user',
    password: process.env.DB_PASSWORD || process.env.MYSQLPASSWORD || '',
    connectionLimit: Number(process.env.DB_CONNECTION_LIMIT) || 10,
    ssl: process.env.DB_SSL === 'true' || process.env.NODE_ENV === 'production',
  },

  jwt: {
    accessSecret: process.env.JWT_ACCESS_SECRET || 'dev-access-secret',
    refreshSecret: process.env.JWT_REFRESH_SECRET || 'dev-refresh-secret',
    accessExpiresIn: process.env.JWT_ACCESS_EXPIRES_IN || '15m',
    refreshExpiresIn: process.env.JWT_REFRESH_EXPIRES_IN || '7d',
    issuer: process.env.JWT_ISSUER || 'cabaxx.com',
  },

  cookie: {
    secure: process.env.COOKIE_SECURE === 'true',
    sameSite: process.env.COOKIE_SAME_SITE || 'strict',
  },

  cloudinary: {
    cloudName: process.env.CLOUDINARY_CLOUD_NAME || '',
    apiKey: process.env.CLOUDINARY_API_KEY || '',
    apiSecret: process.env.CLOUDINARY_API_SECRET || '',
    folder: process.env.CLOUDINARY_FOLDER || 'map',
  },

  upload: {
    maxFileSize: Number(process.env.MAX_FILE_SIZE) || 10485760,
    allowedImageTypes: (process.env.ALLOWED_IMAGE_TYPES || 'image/jpeg,image/png,image/webp').split(','),
    allowedAudioTypes: (process.env.ALLOWED_AUDIO_TYPES || 'audio/mpeg,audio/wav').split(','),
  },

  smtp: {
    host: process.env.SMTP_HOST || '',
    port: Number(process.env.SMTP_PORT) || 587,
    user: process.env.SMTP_USER || '',
    pass: process.env.SMTP_PASS || '',
    from: process.env.MAIL_FROM || 'no-reply@cabaxx.com',
  },

  corsOrigin: process.env.CORS_ORIGIN || 'http://localhost:3000',
  clientUrl: process.env.CLIENT_URL || 'http://localhost:3000',

  payment: {
    provider: process.env.PAYMENT_PROVIDER || 'stripe',
    stripeSecretKey: process.env.STRIPE_SECRET_KEY || '',
    stripeWebhookSecret: process.env.STRIPE_WEBHOOK_SECRET || '',
  },

  rateLimit: {
    windowMs: Number(process.env.RATE_LIMIT_WINDOW_MS) || 900000,
    max: Number(process.env.RATE_LIMIT_MAX) || 100,
  },

  logLevel: process.env.LOG_LEVEL || 'info',
};

module.exports = env;

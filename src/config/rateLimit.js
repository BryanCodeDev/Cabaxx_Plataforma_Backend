const env = require('./env');
const { ipKeyGenerator } = require('express-rate-limit');

const rateLimitConfig = {
  windowMs: env.rateLimit.windowMs,
  max: env.rateLimit.max,
  standardHeaders: true,
  legacyHeaders: false,
  keyGenerator: (req) => ipKeyGenerator(req),
};

module.exports = rateLimitConfig;

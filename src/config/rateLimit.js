const env = require('./env');

const rateLimitConfig = {
  windowMs: env.rateLimit.windowMs,
  max: env.rateLimit.max,
  standardHeaders: true,
  legacyHeaders: false,
  keyGenerator: (req) => req.ip,
};

module.exports = rateLimitConfig;

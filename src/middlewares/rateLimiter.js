const rateLimit = require('express-rate-limit');
const rateLimitConfig = require('../config/rateLimit');
const { ipKeyGenerator } = require('express-rate-limit');

const apiRateLimiter = rateLimit(rateLimitConfig);

const authLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 20,
  standardHeaders: true,
  legacyHeaders: false,
  keyGenerator: (req) => ipKeyGenerator(req),
  message: { success: false, message: 'Demasiados intentos. Intenta más tarde.' },
});

const contactLimiter = rateLimit({
  windowMs: 60 * 60 * 1000,
  max: 10,
  standardHeaders: true,
  legacyHeaders: false,
  keyGenerator: (req) => ipKeyGenerator(req),
  message: { success: false, message: 'Demasiados mensajes. Intenta más tarde.' },
});

module.exports = apiRateLimiter;
module.exports.apiRateLimiter = apiRateLimiter;
module.exports.authLimiter = authLimiter;
module.exports.contactLimiter = contactLimiter;

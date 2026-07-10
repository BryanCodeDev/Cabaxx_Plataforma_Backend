const rateLimit = require('express-rate-limit');
const rateLimitConfig = require('../config/rateLimit');

const apiRateLimiter = rateLimit(rateLimitConfig);

module.exports = apiRateLimiter;

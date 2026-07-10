const helmet = require('helmet');
const env = require('../config/env');

const helmetConfig = helmet({
  contentSecurityPolicy: env.isProduction
    ? {
        directives: {
          defaultSrc: ["'self'"],
          imgSrc: ["'self'", 'data:', 'res.cloudinary.com'],
          scriptSrc: ["'self'"],
          styleSrc: ["'self'", "'unsafe-inline'"],
        },
      }
    : false,
  crossOriginResourcePolicy: { policy: 'cross-origin' },
});

module.exports = helmetConfig;

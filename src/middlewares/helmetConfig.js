const helmet = require('helmet');
const env = require('../config/env');

const helmetConfig = helmet({
  contentSecurityPolicy: env.isProduction
    ? {
        directives: {
          defaultSrc: ["'self'"],
          imgSrc: ["'self'", 'data:', 'res.cloudinary.com', 'https:', 'blob:'],
          scriptSrc: ["'self'"],
          scriptSrcAttr: ["'none'"],
          styleSrc: ["'self'", "'unsafe-inline'", 'https://fonts.googleapis.com'],
          styleSrcElem: ["'self'", "'unsafe-inline'", 'https://fonts.googleapis.com'],
          fontSrc: ["'self'", 'data:', 'https://fonts.gstatic.com'],
          mediaSrc: ["'self'", 'res.cloudinary.com', 'https://res.cloudinary.com'],
          connectSrc: [
            "'self'",
            'https://api.stripe.com',
            'https://api.mercadopago.com',
            'https://*.railway.app',
            'https://*.netlify.app',
            'https://cabaxx.netlify.app',
            'http://localhost:5173',
            'http://localhost:4000',
            'ws:',
            'wss:',
          ],
          frameAncestors: ["'self'", 'https://cabaxx.netlify.app', 'https://*.netlify.app'],
          objectSrc: ["'none'"],
          baseUri: ["'self'"],
          formAction: ["'self'"],
        },
      }
    : false,
  crossOriginResourcePolicy: { policy: 'cross-origin' },
  referrerPolicy: { policy: 'strict-origin-when-cross-origin' },
  hsts: env.isProduction
    ? { maxAge: 31536000, includeSubDomains: true, preload: true }
    : false,
  noSniff: true,
  frameguard: { action: 'sameorigin' },
});

module.exports = helmetConfig;

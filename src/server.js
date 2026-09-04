require('dotenv').config();
const express = require('express');
const cors = require('cors');
const compression = require('compression');

const env = require('./config/env');
const helmetConfig = require('./middlewares/helmetConfig');
const corsConfig = require('./config/cors');
const loggerMiddleware = require('./middlewares/logger');
const errorHandler = require('./middlewares/errorHandler');
const notFoundHandler = require('./middlewares/notFoundHandler');
const logger = require('./utils/logger');

const apiRouter = require('./routes');
const seoService = require('./services/seo.service');

const app = express();

if (env.isProduction) {
  app.set('trust proxy', 1);
}

app.use(helmetConfig);
app.use(cors(corsConfig));
app.use(compression());
app.use(express.json({ limit: '2mb' }));
app.use(express.urlencoded({ extended: true }));
app.use(loggerMiddleware);

app.get('/health', (req, res) => res.json({ status: 'ok', env: env.nodeEnv, uptime: process.uptime() }));

app.get('/', (req, res) => {
  res.json({
    name: 'Cabaxx API',
    env: env.nodeEnv,
    version: process.env.npm_package_version || '1.0.0',
    docs: `${env.apiPrefix}/health`,
    api: env.apiPrefix,
  });
});

const ARTIST_SLUG = env.clientUrl && env.clientUrl.includes('cabitaxx') ? 'cabaxx' : 'cabaxx';

app.get('/sitemap.xml', (req, res, next) => {
  seoService.getSitemap(ARTIST_SLUG).then((xml) => {
    res.set('Content-Type', 'application/xml');
    res.send(xml);
  }).catch(next);
});

app.get('/robots.txt', (req, res, next) => {
  seoService.getRobotsTxt(ARTIST_SLUG).then((text) => {
    res.set('Content-Type', 'text/plain');
    res.send(text);
  }).catch(next);
});

app.use('/api', apiRouter);

app.use(notFoundHandler);
app.use(errorHandler);

const PORT = env.port || 4000;
let server;
if (require.main === module) {
  server = app.listen(PORT, () => logger.info(`Cabaxx API listening on :${PORT}`));

  const shutdown = async (signal) => {
    logger.info(`${signal} received — closing server`);
    server.close(() => {
      logger.info('HTTP server closed');
      process.exit(0);
    });
    setTimeout(() => process.exit(1), 10000).unref();
  };
  process.on('SIGTERM', () => shutdown('SIGTERM'));
  process.on('SIGINT', () => shutdown('SIGINT'));
}

module.exports = app;

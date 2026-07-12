require('dotenv').config();
const express = require('express');
const helmet = require('helmet');
const cors = require('cors');

const env = require('./config/env');
const helmetConfig = require('./middlewares/helmetConfig');
const corsConfig = require('./config/cors');
const loggerMiddleware = require('./middlewares/logger');
const errorHandler = require('./middlewares/errorHandler');
const notFoundHandler = require('./middlewares/notFoundHandler');
const logger = require('./utils/logger');

const apiRouter = require('./routes');
const seoRouter = require('./routes/v1/seo.routes');

const app = express();

app.use(helmetConfig);
app.use(cors(corsConfig));
app.use(express.json({ limit: '2mb' }));
app.use(express.urlencoded({ extended: true }));
app.use(loggerMiddleware);

app.get('/health', (req, res) => res.json({ status: 'ok' }));

app.get('/sitemap.xml', (req, res, next) => {
  const artistSlug = req.query.artist || 'cabitaxx';
  req.params = { artist_slug: artistSlug };
  seoRouter.handle(req, res, next);
});

app.get('/robots.txt', (req, res, next) => {
  const artistSlug = req.query.artist || 'cabitaxx';
  req.params = { artist_slug: artistSlug };
  seoRouter.handle(req, res, next);
});

app.use('/api', apiRouter);

app.use(notFoundHandler);
app.use(errorHandler);

const PORT = env.port || 4000;
if (require.main === module) {
  app.listen(PORT, () => logger.info(`MAP API listening on :${PORT}`));
}

module.exports = app;

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
const seoService = require('./services/seo.service');

const app = express();

app.use(helmetConfig);
app.use(cors(corsConfig));
app.use(express.json({ limit: '2mb' }));
app.use(express.urlencoded({ extended: true }));
app.use(loggerMiddleware);

app.get('/health', (req, res) => res.json({ status: 'ok' }));

const ARTIST_SLUG = 'cabaxx';

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
if (require.main === module) {
  app.listen(PORT, () => logger.info(`Cabaxx API listening on :${PORT}`));
}

module.exports = app;

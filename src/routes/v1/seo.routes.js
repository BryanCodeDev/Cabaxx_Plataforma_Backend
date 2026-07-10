const express = require('express');
const router = express.Router();
const seoController = require('../../controllers/seoController');
const { artistScopeMiddleware } = require('../../middlewares/artistScopeMiddleware');

router.use(artistScopeMiddleware);

router.get('/sitemap.xml', seoController.getSitemap);
router.get('/robots.txt', seoController.getRobotsTxt);
router.get('/', seoController.getSeo);

module.exports = router;

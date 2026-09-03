const express = require('express');
const router = express.Router();

const dashboardController = require('../../controllers/dashboardController');
const authMiddleware = require('../../middlewares/authMiddleware');
const { artistScopeMiddleware, requireArtistAdmin } = require('../../middlewares/artistScopeMiddleware');

router.use(authMiddleware);
router.use(artistScopeMiddleware);
router.get('/overview', requireArtistAdmin, dashboardController.overview);

module.exports = router;

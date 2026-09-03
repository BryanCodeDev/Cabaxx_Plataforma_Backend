const express = require('express');
const router = express.Router();

const settingsController = require('../../controllers/settingsController');
const authMiddleware = require('../../middlewares/authMiddleware');
const { artistScopeMiddleware, requireArtistAdmin } = require('../../middlewares/artistScopeMiddleware');

router.use(authMiddleware);
router.use(artistScopeMiddleware);
router.get('/', requireArtistAdmin, settingsController.getSettings);
router.put('/', requireArtistAdmin, settingsController.updateSettings);

module.exports = router;

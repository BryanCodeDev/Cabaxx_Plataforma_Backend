const express = require('express');
const router = express.Router();

const artistsController = require('../../controllers/artists.controller');
const artistsValidation = require('../../validations/artists.validation');
const authMiddleware = require('../../middlewares/authMiddleware');
const roleMiddleware = require('../../middlewares/roleMiddleware');
const validateMiddleware = require('../../middlewares/validateMiddleware');
const upload = require('../../middlewares/uploadMiddleware');
const { artistScopeMiddleware, requireArtistAdmin } = require('../../middlewares/artistScopeMiddleware');

// Públicas
router.get('/', artistsValidation.list, validateMiddleware, artistsController.list);
router.get('/:slug', artistsValidation.getBySlug, validateMiddleware, artistsController.getBySlug);

// Solo superadmin
router.post(
  '/',
  authMiddleware,
  roleMiddleware('superadmin'),
  upload.fields([{ name: 'avatar', maxCount: 1 }, { name: 'banner', maxCount: 1 }]),
  artistsValidation.create,
  validateMiddleware,
  artistsController.create,
);

// artist_admin o superadmin (scope por id)
router.get('/:slug/stats', artistsValidation.stats, validateMiddleware, artistsController.stats);

router.put(
  '/:id',
  authMiddleware,
  requireArtistAdmin,
  upload.fields([{ name: 'avatar', maxCount: 1 }, { name: 'banner', maxCount: 1 }]),
  artistsValidation.update,
  validateMiddleware,
  artistsController.update,
);

module.exports = router;


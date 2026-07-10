const express = require('express');
const router = express.Router();

const songsController = require('../../controllers/songs.controller');
const songsValidation = require('../../validations/songs.validation');
const authMiddleware = require('../../middlewares/authMiddleware');
const validateMiddleware = require('../../middlewares/validateMiddleware');
const upload = require('../../middlewares/uploadMiddleware');
const { artistScopeMiddleware, requireArtistAdmin } = require('../../middlewares/artistScopeMiddleware');

router.use(artistScopeMiddleware);

// Públicas
router.get('/', songsValidation.list, validateMiddleware, songsController.list);
router.get('/:slug', songsValidation.getBySlug, validateMiddleware, songsController.getBySlug);
router.post('/:id/play', authMiddleware, songsValidation.play, validateMiddleware, songsController.play);

// artist_admin
router.post(
  '/',
  authMiddleware,
  requireArtistAdmin,
  upload.fields([{ name: 'cover', maxCount: 1 }, { name: 'audio', maxCount: 1 }]),
  songsValidation.create,
  validateMiddleware,
  songsController.create,
);
router.put('/:id', authMiddleware, requireArtistAdmin, upload.fields([{ name: 'cover', maxCount: 1 }, { name: 'audio', maxCount: 1 }]), songsValidation.update, validateMiddleware, songsController.update);
router.delete('/:id', authMiddleware, requireArtistAdmin, songsValidation.remove, validateMiddleware, songsController.remove);

module.exports = router;


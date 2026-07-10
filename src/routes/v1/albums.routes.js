const express = require('express');
const router = express.Router();

const albumsController = require('../../controllers/albums.controller');
const albumsValidation = require('../../validations/albums.validation');
const authMiddleware = require('../../middlewares/authMiddleware');
const validateMiddleware = require('../../middlewares/validateMiddleware');
const { artistScopeMiddleware, requireArtistAdmin } = require('../../middlewares/artistScopeMiddleware');

router.use(artistScopeMiddleware);

router.get('/', albumsValidation.list, validateMiddleware, albumsController.list);
router.get('/:slug', albumsValidation.getBySlug, validateMiddleware, albumsController.getBySlug);

router.post('/', authMiddleware, requireArtistAdmin, albumsValidation.create, validateMiddleware, albumsController.create);
router.put('/:id', authMiddleware, requireArtistAdmin, albumsValidation.create, validateMiddleware, albumsController.update);
router.delete('/:id', authMiddleware, requireArtistAdmin, albumsController.remove);

router.post('/:id/songs', authMiddleware, requireArtistAdmin, albumsValidation.createSongLink, validateMiddleware, albumsController.addSong);
router.delete('/:id/songs/:songId', authMiddleware, requireArtistAdmin, albumsController.removeSong);
router.put('/:id/reorder', authMiddleware, requireArtistAdmin, albumsValidation.reorder, validateMiddleware, albumsController.reorder);

module.exports = router;


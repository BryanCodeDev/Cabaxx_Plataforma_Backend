const express = require('express');
const router = express.Router();

const videoController = require('../../controllers/videoController');
const videoValidation = require('../../validations/videoValidation');
const authMiddleware = require('../../middlewares/authMiddleware');
const validateMiddleware = require('../../middlewares/validateMiddleware');
const { artistScopeMiddleware, requireArtistAdmin } = require('../../middlewares/artistScopeMiddleware');

router.use(artistScopeMiddleware);

// Públicas
router.get('/', videoController.list);
router.get('/:slug', videoController.getBySlug);

// artist_admin
router.post('/', authMiddleware, requireArtistAdmin, videoValidation.createVideo, validateMiddleware, videoController.create);
router.patch('/:id', authMiddleware, requireArtistAdmin, videoValidation.updateVideo, validateMiddleware, videoController.update);
router.delete('/:id', authMiddleware, requireArtistAdmin, videoController.remove);

module.exports = router;

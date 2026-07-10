const express = require('express');
const router = express.Router();

const galleryController = require('../../controllers/gallery.controller');
const galleryValidation = require('../../validations/gallery.validation');
const authMiddleware = require('../../middlewares/authMiddleware');
const validateMiddleware = require('../../middlewares/validateMiddleware');
const upload = require('../../middlewares/uploadMiddleware');
const { artistScopeMiddleware, requireArtistAdmin } = require('../../middlewares/artistScopeMiddleware');

router.use(artistScopeMiddleware);

router.get('/', galleryValidation.list, validateMiddleware, galleryController.list);
router.post('/reorder', authMiddleware, requireArtistAdmin, galleryValidation.reorder, validateMiddleware, galleryController.reorder);
router.post('/', authMiddleware, requireArtistAdmin, upload.single('file'), galleryController.upload);
router.delete('/:id', authMiddleware, requireArtistAdmin, galleryValidation.remove, validateMiddleware, galleryController.remove);

module.exports = router;


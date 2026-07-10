const express = require('express');
const router = express.Router();

const postsController = require('../../controllers/posts.controller');
const postsValidation = require('../../validations/posts.validation');
const authMiddleware = require('../../middlewares/authMiddleware');
const validateMiddleware = require('../../middlewares/validateMiddleware');
const { artistScopeMiddleware, requireArtistAdmin } = require('../../middlewares/artistScopeMiddleware');

router.use(artistScopeMiddleware);

// Públicas
router.get('/', postsValidation.list, validateMiddleware, postsController.list);
router.get('/:slug', postsValidation.getBySlug, validateMiddleware, postsController.getBySlug);

// artist_admin
router.post('/', authMiddleware, requireArtistAdmin, postsValidation.create, validateMiddleware, postsController.create);
router.put('/:id', authMiddleware, requireArtistAdmin, postsValidation.update, validateMiddleware, postsController.update);
router.delete('/:id', authMiddleware, requireArtistAdmin, postsValidation.remove, validateMiddleware, postsController.remove);

module.exports = router;


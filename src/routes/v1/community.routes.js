const express = require('express');
const router = express.Router();

const commentController = require('../../controllers/commentController');
const likeController = require('../../controllers/likeController');
const followController = require('../../controllers/followController');
const authMiddleware = require('../../middlewares/authMiddleware');
const validateMiddleware = require('../../middlewares/validateMiddleware');
const communityValidation = require('../../validations/community.validation');
const { artistScopeMiddleware } = require('../../middlewares/artistScopeMiddleware');

router.use(artistScopeMiddleware);

router.get('/comments', communityValidation.commentsList, validateMiddleware, commentController.list);
router.post('/comments', authMiddleware, communityValidation.commentCreate, validateMiddleware, commentController.create);
router.put('/comments/:id', authMiddleware, communityValidation.commentUpdate, validateMiddleware, commentController.update);
router.delete('/comments/:id', authMiddleware, communityValidation.commentRemove, validateMiddleware, commentController.remove);
router.get('/comments/count', communityValidation.commentsCount, validateMiddleware, commentController.count);

router.post('/likes', authMiddleware, communityValidation.likesToggle, validateMiddleware, likeController.toggle);
router.get('/likes/count', communityValidation.likesCount, validateMiddleware, likeController.count);
router.post('/likes/check', authMiddleware, communityValidation.likesCheck, validateMiddleware, likeController.userLikes);

router.post('/follows', authMiddleware, communityValidation.followsToggle, validateMiddleware, followController.toggle);
router.get('/follows/count', followController.count);
router.get('/follows/check', authMiddleware, followController.check);

module.exports = router;

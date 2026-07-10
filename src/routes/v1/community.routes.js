const express = require('express');
const router = express.Router();

const commentController = require('../../controllers/commentController');
const likeController = require('../../controllers/likeController');
const followController = require('../../controllers/followController');
const authMiddleware = require('../../middlewares/authMiddleware');
const validateMiddleware = require('../../middlewares/validateMiddleware');

router.get('/comments', commentController.list);
router.post('/comments', authMiddleware, commentController.create);
router.put('/comments/:id', authMiddleware, commentController.update);
router.delete('/comments/:id', authMiddleware, commentController.remove);
router.get('/comments/count', commentController.count);

router.post('/likes', authMiddleware, likeController.toggle);
router.get('/likes/count', likeController.count);
router.post('/likes/check', authMiddleware, likeController.userLikes);

router.post('/follows', authMiddleware, followController.toggle);
router.get('/follows/count', followController.count);
router.get('/follows/check', authMiddleware, followController.check);

module.exports = router;

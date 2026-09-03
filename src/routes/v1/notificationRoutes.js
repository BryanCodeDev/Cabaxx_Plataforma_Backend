const express = require('express');
const router = express.Router();

const notificationController = require('../../controllers/notificationController');
const authMiddleware = require('../../middlewares/authMiddleware');
const { artistScopeMiddleware } = require('../../middlewares/artistScopeMiddleware');

router.use(authMiddleware);
router.use(artistScopeMiddleware);
router.get('/', notificationController.list);
router.patch('/:id/read', notificationController.markRead);
router.post('/read-all', notificationController.markAllRead);

module.exports = router;

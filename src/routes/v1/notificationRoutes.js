const express = require('express');
const router = express.Router();

const notificationController = require('../../controllers/notificationController');
const authMiddleware = require('../../middlewares/authMiddleware');

router.use(authMiddleware);
router.get('/', notificationController.list);
router.patch('/:id/read', notificationController.markRead);
router.post('/read-all', notificationController.markAllRead);

module.exports = router;

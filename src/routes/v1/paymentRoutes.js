const express = require('express');
const router = express.Router();

const paymentController = require('../../controllers/paymentController');
const authMiddleware = require('../../middlewares/authMiddleware');

router.post('/checkout', authMiddleware, paymentController.checkout);
router.get('/status', authMiddleware, paymentController.status);
router.get('/success', authMiddleware, paymentController.success);
router.get('/failure', authMiddleware, paymentController.failure);
router.get('/pending', authMiddleware, paymentController.pending);
router.post('/webhook', express.raw({ type: 'application/json' }), paymentController.webhook);

module.exports = router;

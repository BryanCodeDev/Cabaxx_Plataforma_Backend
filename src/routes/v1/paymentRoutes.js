const express = require('express');
const router = express.Router();

const paymentController = require('../../controllers/paymentController');
const authMiddleware = require('../../middlewares/authMiddleware');

router.post('/checkout', authMiddleware, paymentController.checkout);
router.get('/status', paymentController.status);
router.get('/success', paymentController.success);
router.get('/failure', paymentController.failure);
router.get('/pending', paymentController.pending);
router.post('/webhook', paymentController.webhook);

module.exports = router;

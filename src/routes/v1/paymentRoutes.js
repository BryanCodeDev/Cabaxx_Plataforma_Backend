const express = require('express');
const router = express.Router();

const paymentController = require('../../controllers/paymentController');
const authMiddleware = require('../../middlewares/authMiddleware');
const tenantMiddleware = require('../../middlewares/tenantMiddleware');

router.post('/checkout', authMiddleware, tenantMiddleware, paymentController.checkout);
router.get('/status', paymentController.status);
router.get('/success', paymentController.success);
router.get('/failure', paymentController.failure);
router.get('/pending', paymentController.pending);
router.post('/webhook', paymentController.webhook);

module.exports = router;

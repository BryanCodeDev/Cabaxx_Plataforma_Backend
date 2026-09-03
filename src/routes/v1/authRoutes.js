const express = require('express');
const router = express.Router();

const authController = require('../../controllers/authController');
const authValidation = require('../../validations/authValidation');
const authMiddleware = require('../../middlewares/authMiddleware');
const validateMiddleware = require('../../middlewares/validateMiddleware');
const { authLimiter } = require('../../middlewares/rateLimiter');

router.post('/register', authLimiter, authValidation.register, validateMiddleware, authController.register);
router.post('/login', authLimiter, authValidation.login, validateMiddleware, authController.login);
router.post('/refresh', authLimiter, authController.refresh);
router.post('/logout', authMiddleware, authController.logout);
router.get('/me', authMiddleware, authController.me);
router.post('/forgot-password', authLimiter, authValidation.forgotPassword, validateMiddleware, authController.forgotPassword);
router.post('/reset-password', authLimiter, authValidation.resetPassword, validateMiddleware, authController.resetPassword);

module.exports = router;

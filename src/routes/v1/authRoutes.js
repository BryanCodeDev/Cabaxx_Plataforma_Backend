const express = require('express');
const router = express.Router();

const authController = require('../../controllers/authController');
const authValidation = require('../../validations/authValidation');
const authMiddleware = require('../../middlewares/authMiddleware');
const validateMiddleware = require('../../middlewares/validateMiddleware');

router.post('/register', authValidation.register, validateMiddleware, authController.register);
router.post('/login', authValidation.login, validateMiddleware, authController.login);
router.post('/refresh', authController.refresh);
router.post('/logout', authMiddleware, authController.logout);
router.get('/me', authMiddleware, authController.me);
router.post('/forgot-password', authValidation.forgotPassword, validateMiddleware, authController.forgotPassword);
router.post('/reset-password', authValidation.resetPassword, validateMiddleware, authController.resetPassword);

module.exports = router;

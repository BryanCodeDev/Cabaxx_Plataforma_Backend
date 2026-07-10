const { body } = require('express-validator');

const register = [
  body('email').isEmail().normalizeEmail().withMessage('Invalid email'),
  body('password').isLength({ min: 8 }).withMessage('Password min 8 chars'),
  body('firstName').optional().isString(),
  body('lastName').optional().isString(),
];

const login = [
  body('email').isEmail().normalizeEmail().withMessage('Invalid email'),
  body('password').notEmpty().withMessage('Password required'),
];

const forgotPassword = [body('email').isEmail().normalizeEmail()];
const resetPassword = [body('password').isLength({ min: 8 })];

module.exports = { register, login, forgotPassword, resetPassword };

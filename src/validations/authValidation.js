const { body } = require('express-validator');

const register = [
  body('email').isEmail().normalizeEmail().withMessage('Email inválido'),
  body('password').isLength({ min: 8, max: 72 }).withMessage('La contraseña debe tener entre 8 y 72 caracteres'),
  body('name').trim().isLength({ min: 2, max: 150 }).withMessage('Nombre requerido (2-150 caracteres)'),
];

const login = [
  body('email').isEmail().normalizeEmail().withMessage('Email inválido'),
  body('password').isString().notEmpty().withMessage('Contraseña requerida'),
];

const forgotPassword = [body('email').isEmail().normalizeEmail()];
const resetPassword = [
  body('token').isString().notEmpty().withMessage('Token requerido'),
  body('password').isLength({ min: 8, max: 72 }).withMessage('La contraseña debe tener entre 8 y 72 caracteres'),
];

module.exports = { register, login, forgotPassword, resetPassword };

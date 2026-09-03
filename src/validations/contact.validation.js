const { body } = require('express-validator');

const contact = [
  body('name').trim().isLength({ min: 2, max: 120 }).withMessage('Nombre requerido (2-120)'),
  body('email').isEmail().normalizeEmail().withMessage('Email inválido'),
  body('subject').trim().isLength({ min: 2, max: 160 }).withMessage('Asunto requerido (2-160)'),
  body('message').trim().isLength({ min: 5, max: 4000 }).withMessage('Mensaje requerido (5-4000)'),
];

module.exports = { contact };

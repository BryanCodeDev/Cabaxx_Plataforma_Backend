const { body } = require('express-validator');

const contact = [
  body('name').notEmpty().withMessage('Name required'),
  body('email').isEmail().normalizeEmail().withMessage('Valid email required'),
  body('subject').notEmpty().withMessage('Subject required'),
  body('message').notEmpty().withMessage('Message required'),
];

module.exports = { contact };

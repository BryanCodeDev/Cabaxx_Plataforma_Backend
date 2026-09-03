const { body, param, query } = require('express-validator');

const subscribe = [
  body('email').isEmail().normalizeEmail().withMessage('Email válido requerido'),
  body('name').optional().isString().isLength({ max: 150 }),
  body('source').optional().isString().isLength({ max: 80 }),
];

const unsubscribe = [
  query('email').optional().isEmail().normalizeEmail(),
  query('token').optional().isString(),
];

const remove = [param('id').isInt()];

const createCampaign = [
  body('subject').trim().isLength({ min: 1, max: 200 }).withMessage('Asunto requerido (max 200)'),
  body('content_html').isString().isLength({ min: 1, max: 100000 }).withMessage('Contenido requerido (max 100000)'),
];

module.exports = { subscribe, unsubscribe, remove, createCampaign };

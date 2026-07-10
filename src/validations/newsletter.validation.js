const { body, query } = require('express-validator');

const subscribe = [
  body('email').isEmail().normalizeEmail().withMessage('Valid email required'),
  body('name').optional().isString(),
  body('source').optional().isString(),
];

const unsubscribe = [
  query('email').isEmail().normalizeEmail(),
  query('token').optional().isString(),
];

const createCampaign = [
  body('subject').notEmpty().withMessage('Subject required'),
  body('content_html').notEmpty().withMessage('content_html required'),
];

module.exports = { subscribe, unsubscribe, createCampaign };

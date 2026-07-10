const { body, param, query } = require('express-validator');

const list = [
  query('status').optional().isString(),
  query('city').optional().isString(),
  query('from').optional().isISO8601(),
  query('to').optional().isISO8601(),
];

const getBySlug = [param('slug').notEmpty()];

const create = [
  body('title').notEmpty().withMessage('Title required'),
  body('start_datetime').isISO8601().withMessage('Valid start_datetime required'),
  body('city').optional().isString(),
  body('is_free').optional().isBoolean(),
];

const purchase = [
  param('id').isInt(),
  body('quantity').optional().isInt({ min: 1, max: 10 }),
];

const verify = [param('qr_code').notEmpty().withMessage('qr_code required')];

module.exports = { list, getBySlug, create, purchase, verify };

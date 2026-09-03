const { body, param, query } = require('express-validator');

const list = [
  query('category').optional().isString().isLength({ max: 80 }),
  query('file_type').optional().isIn(['image', 'video']),
  query('order').optional().isString().isLength({ max: 40 }),
  query('limit').optional().isInt({ min: 1, max: 100 }),
  query('page').optional().isInt({ min: 1 }),
];

const reorder = [
  body('items').isArray({ min: 1 }).withMessage('items array required'),
  body('items.*.id').isInt(),
  body('items.*.sort_order').isInt(),
];

const upload = [
  body('title').optional().isString().isLength({ max: 200 }),
  body('category').optional().isString().isLength({ max: 80 }),
  body('sort_order').optional().isInt({ min: 0 }),
];

const remove = [param('id').isInt()];

module.exports = { list, reorder, upload, remove };

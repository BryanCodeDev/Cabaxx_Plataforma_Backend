const { body, param, query } = require('express-validator');

const list = [
  query('category').optional().isString(),
  query('file_type').optional().isIn(['image', 'video']),
  query('order').optional().isString(),
];

const reorder = [
  body('items').isArray().withMessage('items array required'),
  body('items.*.id').isInt(),
  body('items.*.sort_order').isInt(),
];

const remove = [param('id').isInt()];

module.exports = { list, reorder, remove };

const { body, param, query } = require('express-validator');

const list = [
  query('type').optional().isIn(['blog', 'news', 'update']),
  query('status').optional().isString(),
  query('tag').optional().isString(),
];

const getBySlug = [param('slug').notEmpty()];

const create = [
  body('title').notEmpty().withMessage('Title required'),
  body('type').optional().isIn(['blog', 'news', 'update']),
  body('status').optional().isIn(['draft', 'published']),
  body('tags').optional().isArray(),
];

const update = [
  param('id').isInt(),
  body('title').optional().isString(),
];

const remove = [param('id').isInt()];

module.exports = { list, getBySlug, create, update, remove };

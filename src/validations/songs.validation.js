const { body, param, query } = require('express-validator');

const list = [
  query('page').optional().isInt({ min: 1 }),
  query('limit').optional().isInt({ min: 1, max: 100 }),
  query('status').optional().isString(),
  query('album').optional().isInt(),
];

const getBySlug = [param('slug').notEmpty()];

const create = [
  body('title').notEmpty().withMessage('Title required'),
  body('duration_seconds').optional().isInt({ min: 1 }),
  body('status').optional().isIn(['draft', 'published']),
  body('is_explicit').optional().isBoolean(),
];

const update = [
  param('id').isInt(),
  body('title').optional().isString(),
];

const remove = [param('id').isInt()];

const play = [
  param('id').isInt(),
  body('source').optional().isString(),
  body('duration_played_seconds').optional().isInt({ min: 0 }),
  body('completed').optional().isBoolean(),
];

module.exports = { list, getBySlug, create, update, remove, play };

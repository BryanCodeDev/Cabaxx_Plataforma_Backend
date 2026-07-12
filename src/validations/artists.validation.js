const { body, param, query } = require('express-validator');

const list = [
  query('page').optional().isInt({ min: 1 }),
  query('limit').optional().isInt({ min: 1, max: 100 }),
  query('status').optional().isString(),
  query('genre').optional().isString(),
  query('search').optional().isString(),
];

const getBySlug = [param('slug').notEmpty().withMessage('Slug required')];

const create = [
  body('name').notEmpty().withMessage('Name required'),
  body('genre').optional().isString(),
  body('country').optional().isString(),
  body('status').optional().isIn(['active', 'inactive', 'suspended']),
];

const update = [
  param('id').isInt().withMessage('Valid id required'),
  body('name').optional().isString(),
  body('status').optional().isIn(['active', 'inactive', 'suspended']),
];

const stats = [param('slug').notEmpty().withMessage('Slug required')];

module.exports = { list, getBySlug, create, update, stats };

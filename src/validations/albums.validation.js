const { body, param } = require('express-validator');

const list = [
  body('page').optional().isInt(),
  body('limit').optional().isInt({ max: 100 }),
  body('type').optional().isIn(['single', 'ep', 'album']),
];

const getBySlug = [param('slug').notEmpty()];

const create = [
  body('title').notEmpty().withMessage('Title required'),
  body('type').optional().isIn(['single', 'ep', 'album']),
  body('songs').optional().isArray(),
];

const createSongLink = [
  param('id').isInt(),
  body('song_id').isInt().withMessage('song_id required'),
  body('track_number').optional().isInt({ min: 1 }),
];

const reorder = [
  param('id').isInt(),
  body('songs_order').isArray().withMessage('songs_order array required'),
];

module.exports = { list, getBySlug, create, createSongLink, reorder };

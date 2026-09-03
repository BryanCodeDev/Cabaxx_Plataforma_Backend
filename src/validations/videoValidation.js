const { body, param, query } = require('express-validator');

const list = [
  query('limit').optional().isInt({ min: 1, max: 100 }),
  query('page').optional().isInt({ min: 1 }),
  query('category').optional().isString(),
];

const getBySlug = [param('slug').notEmpty()];

const createVideo = [
  body('title').trim().isLength({ min: 1, max: 200 }).withMessage('Título requerido'),
  body('video_url').optional().isURL().withMessage('video_url inválido'),
  body('youtube_id').optional().isString().isLength({ min: 1, max: 50 }),
  body('description').optional().isString().isLength({ max: 5000 }),
  body('category').optional().isString().isLength({ max: 80 }),
];

const updateVideo = [
  param('id').isInt(),
  body('title').optional().trim().isLength({ min: 1, max: 200 }),
  body('video_url').optional().isURL(),
  body('youtube_id').optional().isString().isLength({ min: 1, max: 50 }),
  body('description').optional().isString().isLength({ max: 5000 }),
];

const remove = [param('id').isInt()];

module.exports = { list, getBySlug, createVideo, updateVideo, remove };

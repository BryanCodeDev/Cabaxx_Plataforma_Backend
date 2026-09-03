const { body, param, query } = require('express-validator');

const ALLOWED_REFS = ['song', 'album', 'event', 'post', 'video', 'product'];

const commentsList = [
  query('reference_type').optional().isIn(ALLOWED_REFS),
  query('reference_id').optional().isInt(),
  query('page').optional().isInt({ min: 1 }),
  query('limit').optional().isInt({ min: 1, max: 100 }),
];

const commentsCount = [
  query('reference_type').optional().isIn(ALLOWED_REFS),
  query('reference_id').optional().isInt(),
];

const commentCreate = [
  body('reference_type').isIn(ALLOWED_REFS).withMessage('reference_type inválido'),
  body('reference_id').isInt().withMessage('reference_id requerido'),
  body('content').isString().trim().isLength({ min: 1, max: 2000 }).withMessage('Comentario requerido (1-2000)'),
  body('parent_id').optional().isInt(),
];

const commentUpdate = [
  param('id').isInt(),
  body('content').isString().trim().isLength({ min: 1, max: 2000 }),
];

const commentRemove = [param('id').isInt()];

const likesCount = [
  query('reference_type').optional().isIn(ALLOWED_REFS),
  query('reference_id').optional().isInt(),
];

const likesToggle = [
  body('reference_type').isIn(ALLOWED_REFS).withMessage('reference_type inválido'),
  body('reference_id').isInt().withMessage('reference_id requerido'),
];

const likesCheck = [
  body('reference_type').optional().isIn(ALLOWED_REFS),
  body('reference_ids').isArray({ min: 1, max: 200 }).withMessage('reference_ids requerido (max 200)'),
  body('reference_ids.*').isInt(),
];

const followsToggle = [body('artist_id').optional().isInt()];

module.exports = {
  commentsList, commentsCount, commentCreate, commentUpdate, commentRemove,
  likesCount, likesToggle, likesCheck, followsToggle,
};
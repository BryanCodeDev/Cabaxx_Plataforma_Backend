const { body } = require('express-validator');

const createVideo = [
  body('title').notEmpty().withMessage('Title required'),
  body('video_url').optional().isURL(),
  body('youtube_id').optional().isString(),
];

const updateVideo = [body('title').optional().isString()];

module.exports = { createVideo, updateVideo };

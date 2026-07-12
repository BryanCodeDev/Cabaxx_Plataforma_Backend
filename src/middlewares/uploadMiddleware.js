const multer = require('multer');
const env = require('../config/env');

const storage = multer.memoryStorage();

const upload = multer({
  storage,
  limits: { fileSize: env.upload.maxFileSize },
  fileFilter: (req, file, cb) => {
    const allowed = [...env.upload.allowedImageTypes, ...env.upload.allowedAudioTypes];
    if (allowed.includes(file.mimetype) || file.mimetype.startsWith('video/')) return cb(null, true);
    cb(new Error(`Unsupported file type: ${file.mimetype}`));
  },
});

module.exports = upload;

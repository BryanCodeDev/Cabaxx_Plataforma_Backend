const multer = require('multer');
const env = require('../config/env');

const storage = multer.memoryStorage();

const upload = multer({
  storage,
  limits: { fileSize: env.upload.maxFileSize },
  fileFilter: (req, file, cb) => {
    const all = [...env.upload.allowedImageTypes, ...env.upload.allowedAudioTypes];
    if (all.includes(file.mimetype)) return cb(null, true);
    cb(new Error(`Unsupported file type: ${file.mimetype}`));
  },
});

module.exports = upload;

const { validationResult } = require('express-validator');
const { ValidationError } = require('../exceptions');

function validateMiddleware(req, res, next) {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    const details = errors.array().map((e) => ({ field: e.path || e.param, message: e.msg }));
    return next(new ValidationError('Validation failed', details));
  }
  return next();
}

module.exports = validateMiddleware;

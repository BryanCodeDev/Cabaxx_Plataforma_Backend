const { buildError } = require('../utils/apiResponse');
const { AppError } = require('../exceptions');
const logger = require('../utils/logger');
const env = require('../config/env');

// eslint-disable-next-line no-unused-vars
function errorHandler(err, req, res, next) {
  if (err instanceof AppError) {
    if (err.statusCode >= 500) {
      logger.error({
        type: 'AppError',
        method: req.method,
        url: req.originalUrl,
        status: err.statusCode,
        code: err.code,
        message: err.message,
        stack: err.stack,
        details: err.details,
      });
    }
    const response = buildError({
      message: err.message,
      code: err.code,
      details: err.details || null,
      statusCode: err.statusCode,
    });
    return res.status(err.statusCode).json(response);
  }

  if (err.name === 'JsonWebTokenError' || err.name === 'TokenExpiredError') {
    return res.status(401).json(buildError({ message: 'Invalid token', code: 'UNAUTHORIZED', statusCode: 401 }));
  }

  if (err.code === 'ER_DUP_ENTRY') {
    return res.status(409).json(buildError({ message: 'Resource already exists', code: 'CONFLICT', statusCode: 409 }));
  }

  logger.error({
    type: 'UnhandledError',
    method: req.method,
    url: req.originalUrl,
    status: 500,
    code: err.code,
    name: err.name,
    message: err.message,
    stack: err.stack,
    sql: err.sql,
    sqlMessage: err.sqlMessage,
  });

  return res.status(500).json(buildError({
    message: env.isProduction ? 'Internal server error' : err.message,
    code: 'INTERNAL_ERROR',
    statusCode: 500,
  }));
}

module.exports = errorHandler;

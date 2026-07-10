const { buildError } = require('../utils/apiResponse');

function notFoundHandler(req, res) {
  res.status(404).json(buildError({ message: `Route not found: ${req.method} ${req.originalUrl}`, code: 'NOT_FOUND', statusCode: 404 }));
}

module.exports = notFoundHandler;

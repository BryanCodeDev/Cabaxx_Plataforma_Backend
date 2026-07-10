const morgan = require('morgan');
const env = require('../config/env');
const logger = require('../utils/logger');

const morganFormat = env.isProduction ? 'combined' : 'dev';

const loggerMiddleware = morgan(morganFormat, {
  skip: () => env.nodeEnv === 'test',
  stream: {
    write: (message) => logger.http(message.trim()),
  },
});

module.exports = loggerMiddleware;

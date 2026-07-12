const morgan = require('morgan');
const env = require('../config/env');
const logger = require('../utils/logger');

const morganFormat = (tokens, req, res) => {
  const method = tokens.method(req, res);
  const url = tokens.url(req, res);
  const status = Number(tokens.status(req, res)) || 0;
  const time = tokens['response-time'](req, res);
  const ip = tokens['remote-addr'](req, res);
  return `${method} ${status} ${time}ms ${url}${ip ? ` ${ip}` : ''}`;
};

const loggerMiddleware = morgan(morganFormat, {
  skip: () => env.nodeEnv === 'test',
  stream: {
    write: (message) => {
      const status = Number(message.split(' ')[1]) || 0;
      const level = status >= 500 ? 'error' : status >= 400 ? 'warn' : 'http';
      logger[level](message.trim());
    },
  },
});

module.exports = loggerMiddleware;

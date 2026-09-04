const winston = require('winston');
const env = require('../config/env');
const path = require('path');

const { combine, timestamp, errors, json, colorize, printf } = winston.format;

const stringifyMessage = (msg) => {
  if (msg == null) return '';
  if (typeof msg === 'string') return msg;
  try {
    return JSON.stringify(msg, Object.getOwnPropertyNames(msg), 2);
  } catch (e) {
    return String(msg);
  }
};

const consoleFormat = combine(
  colorize({ all: false }),
  timestamp({ format: 'YYYY-MM-DD HH:mm:ss' }),
  errors({ stack: true }),
  printf(({ level, message, timestamp: ts, label, stack }) => {
    const tag = label ? `[${label}] ` : '';
    const body = stack || stringifyMessage(message);
    return `${ts} ${level} ${tag}${body}`;
  }),
);

const fileFormat = combine(
  timestamp({ format: 'YYYY-MM-DDTHH:mm:ssZ' }),
  errors({ stack: true }),
  json(),
);

const logger = winston.createLogger({
  level: env.logLevel,
  format: fileFormat,
  transports: [
    new winston.transports.Console({
      silent: env.nodeEnv === 'test',
      format: consoleFormat,
    }),
    new winston.transports.File({ filename: path.join(__dirname, '..', 'logs', 'combined.log') }),
    new winston.transports.File({ filename: path.join(__dirname, '..', 'logs', 'error.log'), level: 'error' }),
  ],
});

module.exports = logger;

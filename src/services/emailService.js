const nodemailer = require('nodemailer');
const env = require('../config/env');
const logger = require('../utils/logger');

const transport = nodemailer.createTransport({
  host: env.smtp.host,
  port: env.smtp.port,
  secure: env.smtp.port === 465,
  auth: env.smtp.user ? { user: env.smtp.user, pass: env.smtp.pass } : undefined,
});

async function send({ to, subject, html, text }) {
  if (!env.smtp.host) {
    logger.warn(`[email] SMTP not configured. Would send to ${to}: ${subject}`);
    return { skipped: true };
  }
  return transport.sendMail({ from: env.smtp.from, to, subject, html, text });
}

module.exports = { send };

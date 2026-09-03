const { ok } = require('./controllerHelper');
const emailService = require('../services/emailService');

const escapeHtml = (value = '') =>
  String(value).replace(/[&<>"']/g, (c) => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]));

async function sendContact(req, res, next) {
  try {
    const { name, email, subject, message } = req.body;
    const safeName = escapeHtml(name).slice(0, 120);
    const safeEmail = escapeHtml(email).slice(0, 191);
    const safeSubject = escapeHtml(subject).slice(0, 160);
    const safeMessage = escapeHtml(message).slice(0, 4000).replace(/\n/g, '<br>');
    const html = `<p><strong>${safeName}</strong> (${safeEmail}) escribió:</p><p><strong>${safeSubject}</strong></p><p>${safeMessage}</p>`;
    await emailService.send({
      to: process.env.MAIL_FROM || 'no-reply@cabaxx.com',
      subject: `[Contacto] ${safeSubject}`,
      html,
    });
    return ok(res, null, 'Mensaje enviado correctamente');
  } catch (err) {
    next(err);
  }
}

module.exports = { sendContact };

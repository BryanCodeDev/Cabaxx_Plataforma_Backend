const { ok } = require('./controllerHelper');
const emailService = require('../services/emailService');

async function sendContact(req, res, next) {
  try {
    const { name, email, subject, message } = req.body;
    const html = `<p><strong>${name}</strong> (${email}) escribió:</p><p><strong>${subject}</strong></p><p>${message.replace(/\n/g, '<br>')}</p>`;
    await emailService.send({
      to: process.env.MAIL_FROM || 'no-reply@cabaxx.com',
      subject: `[Contacto] ${subject}`,
      html,
    });
    return ok(res, null, 'Mensaje enviado correctamente');
  } catch (err) {
    next(err);
  }
}

module.exports = { sendContact };

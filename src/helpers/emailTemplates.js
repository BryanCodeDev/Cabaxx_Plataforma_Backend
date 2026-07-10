function resetPasswordTemplate(name, link) {
  return `
  <div style="font-family:Arial,sans-serif;max-width:480px;margin:auto">
    <h2>Hola ${name || ''}</h2>
    <p>Haz clic para restablecer tu contraseña. Este enlace expira en 1 hora.</p>
    <a href="${link}" style="display:inline-block;padding:12px 20px;background:#111;color:#fff;border-radius:8px;text-decoration:none">Restablecer</a>
  </div>`;
}

function orderConfirmationTemplate(name, orderId, total) {
  return `
  <div style="font-family:Arial,sans-serif;max-width:480px;margin:auto">
    <h2>¡Gracias ${name || ''}!</h2>
    <p>Tu pedido <strong>#${orderId}</strong> por <strong>${total}</strong> fue confirmado.</p>
  </div>`;
}

module.exports = { resetPasswordTemplate, orderConfirmationTemplate };

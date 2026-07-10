const env = require('../config/env');

function formatCurrency(amount, currency = 'USD') {
  return new Intl.NumberFormat('es-CO', { style: 'currency', currency }).format(amount);
}

module.exports = { formatCurrency, defaultCurrency: env.payment.provider ? 'USD' : 'USD' };

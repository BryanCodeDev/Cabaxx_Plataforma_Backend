const paymentRepository = require('../repositories/paymentRepository');
const orderRepository = require('../repositories/orderRepository');
const orderService = require('./orderService');
const crypto = require('crypto');
const env = require('../config/env');

function generateMockMercadoPagoPreference(amount, currency, orderId, artistId) {
  const preferenceId = `mock_mp_${crypto.randomBytes(8).toString('hex')}`;
  const clientUrl = env.clientUrl || 'http://localhost:5173';
  const initPoint = `${clientUrl}/pagos/mercado-pago?pref_id=${preferenceId}&order_id=${orderId}`;
  const sandboxInitPoint = initPoint;
  return {
    id: preferenceId,
    status: 'pending',
    init_point: initPoint,
    sandbox_init_point: sandboxInitPoint,
    collector_id: artistId,
    external_reference: String(orderId),
    items: [
      {
        id: String(orderId),
        title: `Orden #${orderId}`,
        description: `Pago de orden en Cabaxx — Artista ${artistId}`,
        quantity: 1,
        unit_price: Number(amount),
        currency_id: currency || 'COP',
      },
    ],
  };
}

async function checkout({ orderId, amount, currency, provider = 'stripe', artistId }) {
  const resolvedProvider = provider === 'mercadopago' ? 'mercadopago' : 'stripe';

  if (resolvedProvider === 'mercadopago') {
    const preference = generateMockMercadoPagoPreference(amount, currency, orderId, artistId);
    const payment = await paymentRepository.create({
      orderId,
      provider: 'mercadopago',
      providerRef: preference.id,
      amount,
      currency: currency || 'COP',
      status: 'pending',
      responseJson: JSON.stringify(preference),
    });
    return {
      provider: 'mercadopago',
      payment,
      initPoint: preference.sandbox_init_point || preference.init_point,
      preferenceId: preference.id,
    };
  }

  const payment = await paymentRepository.create({ orderId, provider: 'stripe', providerRef: `mock_${Date.now()}`, amount, currency: currency || 'USD', status: 'pending' });
  return { provider: 'stripe', payment, clientSecret: `mock_secret_${payment.id}` };
}

async function handleWebhook(payload) {
  const { orderId, status, provider } = payload;
  const current = orderId ? await orderRepository.findById(orderId) : null;
  if (!current) return { received: true };

  if (status === 'succeeded' || status === 'paid') {
    if (current.status !== 'paid') {
      await orderRepository.updateStatus(orderId, 'paid');
      await orderService.updateStatus(orderId, 'paid', current.artist_id);
    }
  } else if (status === 'failure' || status === 'cancelled') {
    if (current.status !== 'cancelled') {
      await orderRepository.updateStatus(orderId, 'cancelled');
      await orderService.updateStatus(orderId, 'cancelled', current.artist_id);
    }
  }

  await paymentRepository.create({
    orderId,
    provider: provider || 'unknown',
    providerRef: `webhook_${Date.now()}`,
    amount: current.total,
    currency: current.currency,
    status: status === 'succeeded' || status === 'paid' ? 'paid' : 'failed',
    responseJson: JSON.stringify(payload),
  });

  return { received: true };
}

async function getPaymentByOrder(orderId) {
  return paymentRepository.findByOrderId(orderId);
}

module.exports = { checkout, handleWebhook, getPaymentByOrder };

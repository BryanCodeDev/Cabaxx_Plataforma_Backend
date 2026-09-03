const paymentRepository = require('../repositories/paymentRepository');
const orderRepository = require('../repositories/order.repository');
const orderService = require('./order.service');
const crypto = require('crypto');
const env = require('../config/env');

function generateMercadoPagoPreference(amount, currency, orderId, artistId) {
  const preferenceId = `mp_${crypto.randomBytes(8).toString('hex')}`;
  const clientUrl = env.clientUrl || 'http://localhost:5173';
  const initPoint = `${clientUrl}/pagos/mercado-pago?pref_id=${preferenceId}&order_id=${orderId}`;
  return {
    id: preferenceId,
    status: 'pending',
    init_point: initPoint,
    sandbox_init_point: initPoint,
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

async function checkout({ orderId, amount, currency, provider = 'stripe', artistId, userId }) {
  const order = await orderRepository.findById(orderId);
  if (!order) {
    const { NotFoundError } = require('../exceptions');
    throw new NotFoundError('Order not found');
  }
  if (order.user_id && userId && order.user_id !== userId) {
    const { ForbiddenError } = require('../exceptions');
    throw new ForbiddenError('Order does not belong to user');
  }
  const serverAmount = Number(order.total);
  if (amount !== undefined && Math.abs(Number(amount) - serverAmount) > 0.01) {
    const { ValidationError } = require('../exceptions');
    throw new ValidationError('Amount does not match order total');
  }

  const resolvedProvider = provider === 'mercadopago' ? 'mercadopago' : 'stripe';
  const finalCurrency = order.currency || currency || 'COP';
  const finalArtistId = order.artist_id || artistId;

  if (resolvedProvider === 'mercadopago') {
    const preference = generateMercadoPagoPreference(serverAmount, finalCurrency, orderId, finalArtistId);
    const payment = await paymentRepository.create({
      orderId,
      userId,
      artistId: finalArtistId,
      provider: 'mercadopago',
      providerTxId: preference.id,
      amount: serverAmount,
      currency: finalCurrency,
      status: 'pending',
      responseJson: JSON.stringify(preference),
    });
    return {
      provider: 'mercadopago',
      payment,
      initPoint: preference.init_point,
      preferenceId: preference.id,
    };
  }

  const payment = await paymentRepository.create({
    orderId,
    userId,
    artistId: finalArtistId,
    provider: 'stripe',
    providerTxId: `stripe_${Date.now()}`,
    amount: serverAmount,
    currency: finalCurrency,
    status: 'pending',
  });
  return { provider: 'stripe', payment, clientSecret: `secret_${payment.id}` };
}

async function handleWebhook(payload) {
  const { orderId, status, provider, providerTxId, providerRef, amount } = payload;

  if (!orderId || !provider) {
    return { received: true, ignored: 'missing fields' };
  }

  const order = await orderRepository.findById(orderId);
  if (!order) return { received: true, ignored: 'order not found' };

  // Idempotency: skip if providerTxId was already processed.
  const dedupeKey = providerTxId || providerRef;
  if (dedupeKey) {
    const existing = await paymentRepository.findByProviderRef(provider, dedupeKey);
    if (existing) {
      return { received: true, idempotent: true, paymentId: existing.id };
    }
  }

  if (amount !== undefined) {
    const diff = Math.abs(Number(amount) - Number(order.total));
    if (diff > 0.01) {
      return { received: true, ignored: 'amount mismatch' };
    }
  }

  const finalStatus = status === 'succeeded' || status === 'paid'
    ? 'succeeded'
    : status === 'failure' || status === 'cancelled' || status === 'failed'
      ? 'failed'
      : 'pending';

  if (finalStatus === 'succeeded' && order.status !== 'paid') {
    await orderRepository.updateStatus(orderId, 'paid');
    await orderService.updateOrderStatus(orderId, 'paid', order.artist_id);
  } else if (finalStatus === 'failed' && order.status !== 'cancelled') {
    await orderRepository.updateStatus(orderId, 'cancelled');
    await orderService.updateOrderStatus(orderId, 'cancelled', order.artist_id);
  }

  const payment = await paymentRepository.create({
    orderId,
    userId: order.user_id,
    artistId: order.artist_id,
    provider,
    providerTxId: dedupeKey || `webhook_${Date.now()}`,
    amount: amount !== undefined ? Number(amount) : order.total,
    currency: order.currency,
    status: finalStatus,
    responseJson: JSON.stringify(payload),
    paidAt: finalStatus === 'succeeded' ? new Date() : null,
  });

  return { received: true, paymentId: payment.id };
}

async function getPaymentByOrder(orderId) {
  return paymentRepository.findByOrderId(orderId);
}

module.exports = { checkout, handleWebhook, getPaymentByOrder };

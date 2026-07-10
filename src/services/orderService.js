const orderRepository = require('../repositories/orderRepository');
const paymentRepository = require('../repositories/paymentRepository');
const notificationRepository = require('../repositories/notificationRepository');
const { NotFoundError } = require('../exceptions');
const { orderConfirmationTemplate } = require('../helpers/emailTemplates');
const emailService = require('./emailService');

async function list(artistId, { page, limit } = {}) {
  return orderRepository.findByArtist(artistId, { page, limit });
}

async function getById(id, artistId) {
  const order = await orderRepository.findById(id);
  if (!order || (artistId && order.artist_id !== artistId)) throw new NotFoundError('Order not found');
  return order;
}

async function create({ artistId, userId, items, currency = 'USD' }) {
  let total = 0;
  for (const item of items) total += Number(item.price) * Number(item.qty);
  const order = await orderRepository.create({ artistId, userId, total: total.toFixed(2), currency, status: 'pending' });
  await notificationRepository.create({ artistId, userId, type: 'order', title: 'Nuevo pedido', body: `Pedido #${order.id} creado` });
  return order;
}

async function updateStatus(id, status, artistId = null) {
  const order = await orderRepository.updateStatus(id, status, artistId);
  if (status === 'paid') {
    await emailService.send({ to: 'fan@example.com', subject: 'Pedido confirmado', html: orderConfirmationTemplate('', order.id, order.total) });
  }
  return order;
}

async function listPayments(orderId) {
  return paymentRepository.findByOrder(orderId);
}

module.exports = { list, getById, create, updateStatus, listPayments };

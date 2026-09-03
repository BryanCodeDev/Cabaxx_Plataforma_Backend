const crypto = require('crypto');
const eventsRepository = require('../repositories/events.repository');
const { slugify } = require('../utils/slug');
const { NotFoundError, ConflictError, ValidationError } = require('../exceptions');

async function getUpcomingEvents(artistId) {
  return eventsRepository.findUpcoming(artistId);
}

async function getEvents(artistId, filters = {}) {
  return eventsRepository.findAll(artistId, filters);
}

async function getEventBySlug(artistId, slug) {
  const event = await eventsRepository.findBySlug(artistId, slug);
  if (!event) throw new NotFoundError('Event not found');
  return event;
}

async function createEvent(artistId, data, files = {}) {
  if (files.banner) {
    // upload opcional a Cloudinary
  }
  const payload = { ...data, artist_id: artistId, slug: slugify(data.title) };
  return eventsRepository.create(payload);
}

async function updateEvent(id, artistId, data) {
  return eventsRepository.update(id, data, artistId);
}

async function purchaseTicket(userId, ticketId, quantity) {
  const ticket = await eventsRepository.findTicket(ticketId);
  if (!ticket) throw new NotFoundError('Ticket not found');
  if (ticket.status !== 'on_sale') throw new ConflictError('Ticket not on sale');
  const now = new Date();
  if (ticket.sale_start_at && new Date(ticket.sale_start_at) > now) throw new ConflictError('Sale not started');
  if (ticket.sale_end_at && new Date(ticket.sale_end_at) < now) throw new ConflictError('Sale ended');
  if (ticket.quantity_sold + quantity > ticket.quantity_total) {
    throw new ValidationError('Not enough stock', [{ field: 'quantity', message: 'Stock insuficiente' }]);
  }

  const totalPrice = Number(ticket.price) * quantity;
  const qrCode = crypto.randomBytes(16).toString('hex');
  const purchaseId = await eventsRepository.createTicketPurchase({
    userId,
    ticketId,
    quantity,
    totalPrice,
    status: 'paid',
    qrCode,
  });
  const reserved = await eventsRepository.incrementSold(ticketId, quantity);
  if (!reserved) {
    throw new ValidationError('Not enough stock', [{ field: 'quantity', message: 'Stock insuficiente' }]);
  }
  return { purchaseId, qrCode, totalPrice };
}

async function verifyTicket(qrCode) {
  const purchase = await eventsRepository.findPurchaseByQr(qrCode);
  if (!purchase) throw new NotFoundError('Ticket not found');
  if (purchase.used_at) throw new ConflictError('Ticket already used');
  await eventsRepository.markUsed(qrCode);
  return { valid: true, purchase };
}

async function deleteEvent(id, artistId) {
  const ok = await eventsRepository.remove(id, artistId);
  if (!ok) throw new NotFoundError('Event not found');
  return true;
}

module.exports = { getUpcomingEvents, getEvents, getEventBySlug, createEvent, updateEvent, deleteEvent, purchaseTicket, verifyTicket };

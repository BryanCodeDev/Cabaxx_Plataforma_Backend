const crypto = require('crypto');
const db = require('../config/database');
const eventsRepository = require('../repositories/events.repository');
const cloudinaryHelper = require('../helpers/cloudinaryHelper');
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
  let bannerUrl = null;
  if (files.banner) {
    try {
      const result = await cloudinaryHelper.uploadBuffer(files.banner, 'events/banners');
      bannerUrl = result.secure_url || result.url || null;
    } catch (err) {
      throw new ValidationError(`Banner upload failed: ${err.message}`);
    }
  }
  const payload = {
    ...data,
    artist_id: artistId,
    slug: slugify(data.title),
    banner_url: bannerUrl || data.banner_url || null,
  };
  return eventsRepository.create(payload);
}

async function updateEvent(id, artistId, data, files = {}) {
  if (files.banner) {
    try {
      const result = await cloudinaryHelper.uploadBuffer(files.banner, 'events/banners');
      data.banner_url = result.secure_url || result.url;
    } catch (err) {
      throw new ValidationError(`Banner upload failed: ${err.message}`);
    }
  }
  return eventsRepository.update(id, data, artistId);
}

async function purchaseTicket(userId, ticketId, quantity) {
  return db.transaction(async (conn) => {
    const ticket = await eventsRepository.findTicketConn(conn, ticketId);
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
    const purchaseId = await eventsRepository.createTicketPurchaseConn(conn, {
      userId,
      ticketId,
      quantity,
      totalPrice,
      status: 'paid',
      qrCode,
    });
    const reserved = await eventsRepository.incrementSoldConn(conn, ticketId, quantity);
    if (!reserved) {
      throw new ValidationError('Not enough stock', [{ field: 'quantity', message: 'Stock insuficiente' }]);
    }
    return { purchaseId, qrCode, totalPrice };
  });
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

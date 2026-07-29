const eventsService = require('../services/events.service');
const { ok, paginated, created, noContent } = require('./controllerHelper');

async function upcoming(req, res, next) {
  try {
    const events = await eventsService.getUpcomingEvents(req.artistId);
    return ok(res, { events });
  } catch (err) {
    next(err);
  }
}

async function list(req, res, next) {
  try {
    const { rows, total } = await eventsService.getEvents(req.artistId, req.query);
    return paginated(res, rows, total, req.query.page, req.query.limit);
  } catch (err) {
    next(err);
  }
}

async function getBySlug(req, res, next) {
  try {
    const event = await eventsService.getEventBySlug(req.artistId, req.params.slug);
    return ok(res, { event });
  } catch (err) {
    next(err);
  }
}

async function create(req, res, next) {
  try {
    const event = await eventsService.createEvent(req.artistId, req.body, req.files);
    return created(res, { event });
  } catch (err) {
    next(err);
  }
}

async function update(req, res, next) {
  try {
    const event = await eventsService.updateEvent(req.params.id, req.artistId, req.body);
    return ok(res, { event });
  } catch (err) {
    next(err);
  }
}

async function purchase(req, res, next) {
  try {
    const result = await eventsService.purchaseTicket(req.user.id, req.params.id, req.body.quantity || 1);
    return created(res, result);
  } catch (err) {
    next(err);
  }
}

async function verify(req, res, next) {
  try {
    const result = await eventsService.verifyTicket(req.params.qr_code);
    return ok(res, result);
  } catch (err) {
    next(err);
  }
}

async function remove(req, res, next) {
  try {
    await eventsService.deleteEvent(req.params.id, req.artistId);
    return noContent(res);
  } catch (err) {
    next(err);
  }
}

module.exports = { upcoming, list, getBySlug, create, update, remove, purchase, verify };

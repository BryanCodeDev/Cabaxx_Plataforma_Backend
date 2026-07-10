const notificationService = require('../services/notificationService');
const { ok } = require('./controllerHelper');

async function list(req, res, next) {
  try {
    const notifications = await notificationService.list(req.user.id, req.artistId);
    return ok(res, { notifications });
  } catch (err) {
    next(err);
  }
}

async function markRead(req, res, next) {
  try {
    const notification = await notificationService.markRead(req.params.id, req.user.id);
    return ok(res, { notification });
  } catch (err) {
    next(err);
  }
}

async function markAllRead(req, res, next) {
  try {
    await notificationService.markAllRead(req.user.id, req.artistId);
    return ok(res, null, 'All read');
  } catch (err) {
    next(err);
  }
}

module.exports = { list, markRead, markAllRead };

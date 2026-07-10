const adminService = require('../services/adminService');
const { ok, paginated } = require('./controllerHelper');

async function listArtists(req, res, next) {
  try {
    const { rows, total } = await adminService.listArtists(req.query);
    return paginated(res, rows, total, req.query.page, req.query.limit);
  } catch (err) {
    next(err);
  }
}

async function listUsers(req, res, next) {
  try {
    const { rows, total } = await adminService.listUsers(req.query);
    return paginated(res, rows, total, req.query.page, req.query.limit);
  } catch (err) {
    next(err);
  }
}

async function listSubscriptions(req, res, next) {
  try {
    const { rows, total } = await adminService.listSubscriptions(req.query);
    return paginated(res, rows, total, req.query.page, req.query.limit);
  } catch (err) {
    next(err);
  }
}

module.exports = { listArtists, listUsers, listSubscriptions };

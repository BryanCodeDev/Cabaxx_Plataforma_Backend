const adminService = require('../services/adminService');
const { ok, paginatedAs } = require('./controllerHelper');

async function listArtists(req, res, next) {
  try {
    const { rows, total } = await adminService.listArtists(req.query);
    return paginatedAs(res, 'artists', rows, total, req.query.page, req.query.limit);
  } catch (err) {
    next(err);
  }
}

async function listUsers(req, res, next) {
  try {
    const { rows, total } = await adminService.listUsers(req.query);
    return paginatedAs(res, 'users', rows, total, req.query.page, req.query.limit);
  } catch (err) {
    next(err);
  }
}

module.exports = { listArtists, listUsers };

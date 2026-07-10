const videoService = require('../services/videoService');
const { ok, paginated, created, noContent } = require('./controllerHelper');

async function list(req, res, next) {
  try {
    const { page, limit } = req.query;
    const { rows, total } = await videoService.list(req.artistId, { page, limit });
    return paginated(res, rows, total, page, limit);
  } catch (err) {
    next(err);
  }
}

async function getById(req, res, next) {
  try {
    const video = await videoService.getById(req.params.id, req.artistId);
    return ok(res, { video });
  } catch (err) {
    next(err);
  }
}

async function getBySlug(req, res, next) {
  try {
    const video = await videoService.getBySlug(req.params.slug, req.artistId);
    return ok(res, { video });
  } catch (err) {
    next(err);
  }
}

async function create(req, res, next) {
  try {
    const video = await videoService.create(req.artistId, req.body);
    return created(res, { video });
  } catch (err) {
    next(err);
  }
}

async function update(req, res, next) {
  try {
    const video = await videoService.update(req.params.id, req.artistId, req.body);
    return ok(res, { video });
  } catch (err) {
    next(err);
  }
}

async function remove(req, res, next) {
  try {
    await videoService.remove(req.params.id, req.artistId);
    return noContent(res);
  } catch (err) {
    next(err);
  }
}

module.exports = { list, getById, getBySlug, create, update, remove };

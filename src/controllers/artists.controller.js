const artistsService = require('../services/artists.service');
const { ok, paginated, created } = require('./controllerHelper');

async function list(req, res, next) {
  try {
    const { page, limit, status, genre, search } = req.query;
    const { rows, total } = await artistsService.getArtists({ page, limit, status, genre, search });
    return paginated(res, rows, total, page, limit);
  } catch (err) {
    next(err);
  }
}

async function getBySlug(req, res, next) {
  try {
    const artist = await artistsService.getArtistBySlug(req.params.slug);
    return ok(res, { artist });
  } catch (err) {
    next(err);
  }
}

async function create(req, res, next) {
  try {
    const artist = await artistsService.createArtist(req.body, req.user && req.user.id);
    return created(res, { artist });
  } catch (err) {
    next(err);
  }
}

async function update(req, res, next) {
  try {
    const files = {
      avatar: req.files && req.files.avatar && req.files.avatar[0],
      banner: req.files && req.files.banner && req.files.banner[0],
    };
    const artist = await artistsService.updateArtist(req.params.id, req.body, files);
    return ok(res, { artist });
  } catch (err) {
    next(err);
  }
}

async function stats(req, res, next) {
  try {
    const stats = await artistsService.getArtistStats(req.params.id);
    return ok(res, { stats });
  } catch (err) {
    next(err);
  }
}

module.exports = { list, getBySlug, create, update, stats };

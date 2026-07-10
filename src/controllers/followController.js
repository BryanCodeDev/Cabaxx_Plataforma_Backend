const followService = require('../services/followService');
const { ok, created, noContent } = require('./controllerHelper');

async function toggle(req, res, next) {
  try {
    const result = await followService.toggleFollow(req.user.id, req.artistId);
    return ok(res, result);
  } catch (err) {
    next(err);
  }
}

async function count(req, res, next) {
  try {
    const artistId = req.params.artist_id || req.artistId;
    const total = await followService.getCount(artistId);
    return ok(res, { total });
  } catch (err) {
    next(err);
  }
}

async function check(req, res, next) {
  try {
    const following = await followService.checkFollow(req.user.id, req.artistId);
    return ok(res, { following });
  } catch (err) {
    next(err);
  }
}

module.exports = { toggle, count, check };

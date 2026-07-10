const likeService = require('../services/likeService');
const { ok, created, noContent } = require('./controllerHelper');

async function toggle(req, res, next) {
  try {
    const { reference_type, reference_id } = req.body;
    const result = await likeService.toggleLike(req.artistId, req.user.id, reference_type, reference_id);
    return ok(res, result);
  } catch (err) {
    next(err);
  }
}

async function count(req, res, next) {
  try {
    const { reference_type, reference_id } = req.query;
    const total = await likeService.getCount(req.artistId, reference_type, reference_id);
    return ok(res, { total });
  } catch (err) {
    next(err);
  }
}

async function userLikes(req, res, next) {
  try {
    const { reference_type } = req.query;
    const { reference_ids } = req.body;
    const liked = await likeService.getUserLikes(req.user.id, req.artistId, reference_ids, reference_type);
    return ok(res, { liked });
  } catch (err) {
    next(err);
  }
}

module.exports = { toggle, count, userLikes };

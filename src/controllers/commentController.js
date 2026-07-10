const commentService = require('../services/commentService');
const { ok, paginated, created, noContent } = require('./controllerHelper');

async function list(req, res, next) {
  try {
    const { reference_type, reference_id, parent_id } = req.query;
    const { rows, total } = await commentService.getComments(req.artistId, {
      referenceType: reference_type,
      referenceId: reference_id,
      parentId: parent_id,
      page: req.query.page,
      limit: req.query.limit,
    });
    return paginated(res, rows, total, req.query.page, req.query.limit);
  } catch (err) {
    next(err);
  }
}

async function create(req, res, next) {
  try {
    const comment = await commentService.createComment(req.artistId, req.user.id, req.body);
    return created(res, { comment });
  } catch (err) {
    next(err);
  }
}

async function update(req, res, next) {
  try {
    const comment = await commentService.updateComment(req.params.id, req.artistId, req.body);
    return ok(res, { comment });
  } catch (err) {
    next(err);
  }
}

async function remove(req, res, next) {
  try {
    await commentService.deleteComment(req.params.id, req.artistId);
    return noContent(res);
  } catch (err) {
    next(err);
  }
}

async function count(req, res, next) {
  try {
    const { reference_type, reference_id } = req.query;
    const total = await commentService.countComments(req.artistId, reference_type, reference_id);
    return ok(res, { total });
  } catch (err) {
    next(err);
  }
}

module.exports = { list, create, update, remove, count };

const postsService = require('../services/posts.service');
const { ok, paginatedAs, created, noContent } = require('./controllerHelper');

async function list(req, res, next) {
  try {
    const { rows, total } = await postsService.getPosts(req.artistId, req.query);
    return paginatedAs(res, 'posts', rows, total, req.query.page, req.query.limit);
  } catch (err) {
    next(err);
  }
}

async function getBySlug(req, res, next) {
  try {
    const post = await postsService.getPostBySlug(req.artistId, req.params.slug);
    return ok(res, { post });
  } catch (err) {
    next(err);
  }
}

async function create(req, res, next) {
  try {
    const post = await postsService.createPost(req.artistId, req.user.id, req.body);
    return created(res, { post });
  } catch (err) {
    next(err);
  }
}

async function update(req, res, next) {
  try {
    const post = await postsService.updatePost(req.params.id, req.artistId, req.body);
    return ok(res, { post });
  } catch (err) {
    next(err);
  }
}

async function remove(req, res, next) {
  try {
    await postsService.deletePost(req.params.id, req.artistId);
    return noContent(res);
  } catch (err) {
    next(err);
  }
}

module.exports = { list, getBySlug, create, update, remove };

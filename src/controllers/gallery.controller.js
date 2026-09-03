const galleryService = require('../services/gallery.service');
const { ok, paginatedAs, created, noContent } = require('./controllerHelper');

async function list(req, res, next) {
  try {
    const { rows, total } = await galleryService.getGallery(req.artistId, req.query);
    return paginatedAs(res, 'gallery', rows, total, req.query.page, req.query.limit);
  } catch (err) {
    next(err);
  }
}

async function upload(req, res, next) {
  try {
    const item = await galleryService.uploadItem(req.artistId, req.body, req.file);
    return created(res, { item });
  } catch (err) {
    next(err);
  }
}

async function reorder(req, res, next) {
  try {
    await galleryService.reorderItems(req.artistId, req.body.items || []);
    return ok(res, null, 'reordered');
  } catch (err) {
    next(err);
  }
}

async function remove(req, res, next) {
  try {
    await galleryService.deleteItem(req.params.id, req.artistId);
    return noContent(res);
  } catch (err) {
    next(err);
  }
}

module.exports = { list, upload, reorder, remove };

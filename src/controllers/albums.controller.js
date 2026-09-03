const albumsService = require('../services/albums.service');
const { ok, paginatedAs, created, noContent } = require('./controllerHelper');

async function list(req, res, next) {
  try {
    const { rows, total } = await albumsService.getAlbums(req.artistId, req.query);
    return paginatedAs(res, 'albums', rows, total, req.query.page, req.query.limit);
  } catch (err) {
    next(err);
  }
}

async function getBySlug(req, res, next) {
  try {
    const album = await albumsService.getAlbumBySlug(req.artistId, req.params.slug);
    return ok(res, { album });
  } catch (err) {
    next(err);
  }
}

async function create(req, res, next) {
  try {
    const album = await albumsService.createAlbum(req.artistId, req.body);
    return created(res, { album });
  } catch (err) {
    next(err);
  }
}

async function update(req, res, next) {
  try {
    const album = await albumsService.updateAlbum(req.params.id, req.artistId, req.body);
    return ok(res, { album });
  } catch (err) {
    next(err);
  }
}

async function remove(req, res, next) {
  try {
    await albumsService.deleteAlbum(req.params.id, req.artistId);
    return noContent(res);
  } catch (err) {
    next(err);
  }
}

async function addSong(req, res, next) {
  try {
    await albumsService.addSong(req.params.id, req.body.song_id, req.body.track_number);
    return ok(res, null, 'song added');
  } catch (err) {
    next(err);
  }
}

async function removeSong(req, res, next) {
  try {
    await albumsService.removeSong(req.params.id, req.params.songId);
    return noContent(res);
  } catch (err) {
    next(err);
  }
}

async function reorder(req, res, next) {
  try {
    await albumsService.reorderSongs(req.params.id, req.body.songs_order);
    return ok(res, null, 'reordered');
  } catch (err) {
    next(err);
  }
}

module.exports = { list, getBySlug, create, update, remove, addSong, removeSong, reorder };

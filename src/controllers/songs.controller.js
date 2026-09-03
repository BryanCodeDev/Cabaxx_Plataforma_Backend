const songsService = require('../services/songs.service');
const { ok, paginatedAs, created, noContent } = require('./controllerHelper');

async function list(req, res, next) {
  try {
    const { page, limit, status, search, album } = req.query;
    const { rows, total } = await songsService.getSongs(req.artistId, { page, limit, status, search, albumId: album });
    return paginatedAs(res, 'songs', rows, total, page, limit);
  } catch (err) {
    next(err);
  }
}

async function getBySlug(req, res, next) {
  try {
    const song = await songsService.getSongBySlug(req.artistId, req.params.slug);
    return ok(res, { song });
  } catch (err) {
    next(err);
  }
}

async function create(req, res, next) {
  try {
    const files = {
      cover: req.files && req.files.cover && req.files.cover[0],
      audio: req.files && req.files.audio && req.files.audio[0],
    };
    const song = await songsService.createSong(req.artistId, req.body, files);
    return created(res, { song });
  } catch (err) {
    next(err);
  }
}

async function update(req, res, next) {
  try {
    const files = {
      cover: req.files && req.files.cover && req.files.cover[0],
      audio: req.files && req.files.audio && req.files.audio[0],
    };
    const song = await songsService.updateSong(req.params.id, req.artistId, req.body, files);
    return ok(res, { song });
  } catch (err) {
    next(err);
  }
}

async function remove(req, res, next) {
  try {
    await songsService.deleteSong(req.params.id, req.artistId);
    return noContent(res);
  } catch (err) {
    next(err);
  }
}

async function play(req, res, next) {
  try {
    await songsService.registerPlay(req.params.id, req.user && req.user.id, req.body);
    return ok(res, null, 'play registered');
  } catch (err) {
    next(err);
  }
}

module.exports = { list, getBySlug, create, update, remove, play };

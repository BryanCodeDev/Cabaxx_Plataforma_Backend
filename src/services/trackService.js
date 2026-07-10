const trackRepository = require('../repositories/trackRepository');
const { slugify } = require('../utils/slug');
const { NotFoundError } = require('../exceptions');

async function list(artistId, { page, limit, albumId } = {}) {
  if (albumId) return { rows: await trackRepository.findByAlbum(albumId, artistId), total: 0 };
  return trackRepository.findAll({ artistId, page, limit });
}

async function getById(id, artistId) {
  const track = await trackRepository.findById(id, artistId);
  if (!track) throw new NotFoundError('Track not found');
  return track;
}

async function create(artistId, data) {
  return trackRepository.create({ ...data, artist_id: artistId, slug: slugify(data.title) });
}

async function update(id, artistId, data) {
  return trackRepository.update(id, { ...data, artist_id: artistId }, artistId);
}

async function remove(id, artistId) {
  return trackRepository.remove(id, artistId);
}

module.exports = { list, getById, create, update, remove };

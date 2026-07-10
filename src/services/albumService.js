const albumRepository = require('../repositories/albumRepository');
const { slugify } = require('../utils/slug');
const { NotFoundError } = require('../exceptions');

async function list(artistId, { page, limit } = {}) {
  return albumRepository.findAll({ artistId, page, limit });
}

async function getById(id, artistId) {
  const album = await albumRepository.findById(id, artistId);
  if (!album) throw new NotFoundError('Album not found');
  return album;
}

async function create(artistId, data) {
  return albumRepository.create({ ...data, artist_id: artistId, slug: slugify(data.title) });
}

async function update(id, artistId, data) {
  return albumRepository.update(id, { ...data, artist_id: artistId }, artistId);
}

async function remove(id, artistId) {
  return albumRepository.remove(id, artistId);
}

module.exports = { list, getById, create, update, remove };

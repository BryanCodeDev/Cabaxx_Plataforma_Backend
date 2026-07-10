const videoRepository = require('../repositories/videoRepository');
const { slugify } = require('../utils/slug');
const { NotFoundError } = require('../exceptions');

async function list(artistId, { page, limit } = {}) {
  return videoRepository.findAll({ artistId, page, limit });
}

async function getById(id, artistId) {
  const video = await videoRepository.findById(id, artistId);
  if (!video) throw new NotFoundError('Video not found');
  return video;
}

async function getBySlug(slug, artistId) {
  const video = await videoRepository.findBySlug(slug, artistId);
  if (!video) throw new NotFoundError('Video not found');
  return video;
}

async function create(artistId, data) {
  return videoRepository.create({ ...data, artist_id: artistId, slug: slugify(data.title) });
}

async function update(id, artistId, data) {
  return videoRepository.update(id, { ...data, artist_id: artistId }, artistId);
}

async function remove(id, artistId) {
  return videoRepository.remove(id, artistId);
}

module.exports = { list, getById, create, update, remove };

const galleryRepository = require('../repositories/galleryRepository');
const { NotFoundError } = require('../exceptions');

async function list(artistId, { page, limit } = {}) {
  return galleryRepository.findAll({ artistId, page, limit });
}

async function getById(id, artistId) {
  const img = await galleryRepository.findById(id, artistId);
  if (!img) throw new NotFoundError('Image not found');
  return img;
}

async function create(artistId, data) {
  return galleryRepository.create({ ...data, artist_id: artistId });
}

async function remove(id, artistId) {
  return galleryRepository.remove(id, artistId);
}

module.exports = { list, getById, create, remove };

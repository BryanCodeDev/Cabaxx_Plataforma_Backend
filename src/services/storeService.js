const storeRepository = require('../repositories/storeRepository');
const { slugify } = require('../utils/slug');
const { NotFoundError } = require('../exceptions');

async function list(artistId, { page, limit } = {}) {
  return storeRepository.findAll({ artistId, page, limit });
}

async function getById(id, artistId) {
  const product = await storeRepository.findById(id, artistId);
  if (!product) throw new NotFoundError('Product not found');
  return product;
}

async function create(artistId, data) {
  return storeRepository.create({ ...data, artist_id: artistId, slug: slugify(data.name) });
}

async function update(id, artistId, data) {
  return storeRepository.update(id, { ...data, artist_id: artistId }, artistId);
}

async function remove(id, artistId) {
  return storeRepository.remove(id, artistId);
}

module.exports = { list, getById, create, update, remove };

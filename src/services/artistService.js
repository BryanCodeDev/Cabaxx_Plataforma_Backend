const artistRepository = require('../repositories/artistRepository');
const { slugify } = require('../utils/slug');
const { NotFoundError } = require('../exceptions');

async function getBySlug(slug) {
  const artist = await artistRepository.findBySlug(slug);
  if (!artist) throw new NotFoundError('Artist not found');
  return artist;
}

async function getById(id) {
  const artist = await artistRepository.findById(id);
  if (!artist) throw new NotFoundError('Artist not found');
  return artist;
}

async function list({ page, limit, isActive }) {
  return artistRepository.findAll({ page, limit, isActive });
}

async function create(data) {
  const payload = { ...data, slug: slugify(data.name) };
  return artistRepository.create(payload);
}

async function update(id, data) {
  return artistRepository.update(id, data);
}

module.exports = { getBySlug, getById, list, create, update };

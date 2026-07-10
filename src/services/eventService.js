const eventRepository = require('../repositories/eventRepository');
const { slugify } = require('../utils/slug');
const { NotFoundError } = require('../exceptions');

async function list(artistId, { page, limit } = {}) {
  return eventRepository.findAll({ artistId, page, limit });
}

async function getById(id, artistId) {
  const event = await eventRepository.findById(id, artistId);
  if (!event) throw new NotFoundError('Event not found');
  return event;
}

async function create(artistId, data) {
  return eventRepository.create({ ...data, artist_id: artistId, slug: slugify(data.title) });
}

async function update(id, artistId, data) {
  return eventRepository.update(id, { ...data, artist_id: artistId }, artistId);
}

async function remove(id, artistId) {
  return eventRepository.remove(id, artistId);
}

module.exports = { list, getById, create, update, remove };

const blogRepository = require('../repositories/blogRepository');
const { slugify } = require('../utils/slug');
const { NotFoundError } = require('../exceptions');

async function list(artistId, { page, limit } = {}) {
  return blogRepository.findAll({ artistId, page, limit });
}

async function getBySlug(slug, artistId) {
  const post = await blogRepository.findBySlug(slug, artistId);
  if (!post) throw new NotFoundError('Post not found');
  return post;
}

async function create(artistId, data) {
  return blogRepository.create({ ...data, artist_id: artistId, slug: slugify(data.title) });
}

async function update(id, artistId, data) {
  return blogRepository.update(id, { ...data, artist_id: artistId }, artistId);
}

async function remove(id, artistId) {
  return blogRepository.remove(id, artistId);
}

module.exports = { list, getBySlug, create, update, remove };

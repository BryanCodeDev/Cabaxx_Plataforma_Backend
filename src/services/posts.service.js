const postsRepository = require('../repositories/posts.repository');
const { slugify } = require('../utils/slug');
const { NotFoundError } = require('../exceptions');

async function getPosts(artistId, filters = {}) {
  return postsRepository.findAll(artistId, filters);
}

async function getPostBySlug(artistId, slug) {
  const post = await postsRepository.findBySlug(artistId, slug);
  if (!post) throw new NotFoundError('Post not found');
  await postsRepository.incrementViews(post.id);
  return post;
}

async function createPost(artistId, userId, data) {
  const payload = {
    artist_id: artistId,
    user_id: userId,
    type: data.type || 'blog',
    title: data.title,
    slug: slugify(data.title),
    content: data.content || '',
    excerpt: data.excerpt || null,
    cover_url: data.cover_url || null,
    status: data.status || 'draft',
    published_at: data.status === 'published' ? new Date() : null,
  };
  const post = await postsRepository.create(payload);
  if (Array.isArray(data.tags)) await postsRepository.setTags(post.id, data.tags);
  return post;
}

async function updatePost(id, artistId, data) {
  const payload = { ...data };
  if (data.tags) {
    await postsRepository.setTags(id, data.tags);
    delete payload.tags;
  }
  return postsRepository.update(id, payload, artistId);
}

async function deletePost(id, artistId) {
  const ok = await postsRepository.remove(id, artistId);
  if (!ok) throw new NotFoundError('Post not found');
  return true;
}

module.exports = { getPosts, getPostBySlug, createPost, updatePost, deletePost };

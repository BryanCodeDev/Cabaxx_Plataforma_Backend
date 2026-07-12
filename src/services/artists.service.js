const artistsRepository = require('../repositories/artists.repository');
const cloudinaryHelper = require('../helpers/cloudinaryHelper');
const { slugify } = require('../utils/slug');
const { NotFoundError, ConflictError } = require('../exceptions');

async function getArtists(filters = {}) {
  return artistsRepository.findAll(filters);
}

async function getArtistBySlug(slug) {
  const artist = await artistsRepository.findBySlug(slug);
  if (!artist) throw new NotFoundError('Artist not found');
  const socialLinks = await dbSocialLinks(artist.id);
  const theme = await dbTheme(artist.id);
  const seo = await dbSeo(artist.id);
  return { ...artist, social_links: socialLinks, theme, seo };
}

async function createArtist(data, adminUserId) {
  const existing = await artistsRepository.findBySlug(slugify(data.name));
  if (existing) throw new ConflictError('Artist slug already exists');
  const payload = {
    slug: slugify(data.name),
    name: data.name,
    real_name: data.real_name || null,
    bio: data.bio || null,
    short_bio: data.short_bio || null,
    genre: data.genre || null,
    country: data.country || null,
    city: data.city || null,
    status: data.status || 'active',
    avatar_url: data.avatar_url || null,
    banner_url: data.banner_url || null,
  };
  const artist = await artistsRepository.create(payload);
  if (adminUserId) {
    await linkAdmin(adminUserId, artist.id);
  }
  return artist;
}

async function updateArtist(id, data, files = {}) {
  const artist = await artistsRepository.findById(id);
  if (!artist) throw new NotFoundError('Artist not found');

  if (files.avatar) {
    data.avatar_url = await cloudinaryHelper.uploadBuffer(files.avatar.buffer, {
      folder: 'map/artists',
      resourceType: 'image',
      publicName: `avatar-${id}`,
    });
  }
  if (files.banner) {
    data.banner_url = await cloudinaryHelper.uploadBuffer(files.banner.buffer, {
      folder: 'map/artists',
      resourceType: 'image',
      publicName: `banner-${id}`,
    });
  }
  const cleaned = {};
  ['name', 'real_name', 'bio', 'short_bio', 'genre', 'country', 'city', 'status', 'avatar_url', 'banner_url'].forEach((k) => {
    if (data[k] !== undefined) cleaned[k] = data[k];
  });
  return artistsRepository.update(id, cleaned);
}

async function getArtistStats(artistId) {
  const artist = await artistsRepository.findById(artistId);
  if (!artist) throw new NotFoundError('Artist not found');
  return artistsRepository.getStats(artistId);
}

// helpers de tablas relacionadas
const db = require('../config/database');
async function dbSocialLinks(artistId) {
  const rows = await db.query('SELECT platform, url, followers_count FROM artist_social_links WHERE artist_id = ?', [artistId]);
  return rows;
}
async function dbTheme(artistId) {
  const [row] = await db.query('SELECT * FROM artist_themes WHERE artist_id = ?', [artistId]);
  return row || null;
}
async function dbSeo(artistId) {
  const [row] = await db.query('SELECT * FROM artist_seo WHERE artist_id = ?', [artistId]);
  return row || null;
}
async function linkAdmin(userId, artistId) {
  await db.query('INSERT INTO user_roles (user_id, role_id, artist_id) VALUES (?, (SELECT id FROM roles WHERE slug = ?), ?)', [userId, 'artist_admin', artistId]);
}

module.exports = { getArtists, getArtistBySlug, createArtist, updateArtist, getArtistStats };

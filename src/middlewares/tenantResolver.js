const artistsRepository = require('../repositories/artists.repository');

const CACHE_TTL_MS = 30 * 1000;
const cache = new Map();

function getCached(key) {
  const hit = cache.get(key);
  if (!hit) return null;
  if (Date.now() > hit.expiresAt) {
    cache.delete(key);
    return null;
  }
  return hit.value;
}

function setCache(key, value) {
  cache.set(key, { value, expiresAt: Date.now() + CACHE_TTL_MS });
}

async function resolveArtist(req, res, next) {
  try {
    if (req.artist) return next();

    const headerSlug = req.headers['x-artist-slug'];
    const queryArtist = req.query.artist;
    let slug = headerSlug || queryArtist;

    if (!slug) {
      const host = req.hostname || req.headers.host || '';
      const parts = host.split('.');
      if (parts.length >= 3) {
        slug = parts[0];
      }
    }

    if (!slug) return next();

    const cacheKey = `artist:${String(slug).toLowerCase()}`;
    let artist = getCached(cacheKey);

    if (!artist) {
      artist = await artistsRepository.findBySlug(String(slug).toLowerCase());
      if (artist) setCache(cacheKey, artist);
    }

    if (!artist) return next();

    req.artist = artist;
    req.artistId = artist.id;
    next();
  } catch (err) {
    next(err);
  }
}

module.exports = { resolveArtist };

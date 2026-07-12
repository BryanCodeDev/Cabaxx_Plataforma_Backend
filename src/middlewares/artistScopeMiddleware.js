const { ForbiddenError, NotFoundError } = require('../exceptions');
const artistRepository = require('../repositories/artists.repository');

async function artistScopeMiddleware(req, res, next) {
  try {
    if (req.artist) return next();

    const slugOrId = req.params.artist_slug || req.params.artist_id || req.params.slug || req.params.id;
    if (!slugOrId) return next();

    const artist = /^\d+$/.test(String(slugOrId))
      ? await artistRepository.findById(slugOrId)
      : await artistRepository.findBySlug(slugOrId);

    if (!artist) return next(new NotFoundError('Artist not found'));
    req.artist = artist;
    req.artistId = artist.id;
    next();
  } catch (err) {
    next(err);
  }
}

function requireArtistAdmin(req, res, next) {
  const role = req.user && req.user.role;
  if (role === 'superadmin') return next();
  if (role === 'artist_admin' && Number(req.user.artistId) === Number(req.artistId)) return next();
  return next(new ForbiddenError('artist_admin or superadmin required'));
}

module.exports = { artistScopeMiddleware, requireArtistAdmin };

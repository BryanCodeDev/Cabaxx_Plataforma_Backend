const { ForbiddenError, NotFoundError } = require('../exceptions');
const artistRepository = require('../repositories/artists.repository');

const SINGLE_ARTIST_SLUG = 'cabaxx';

async function artistScopeMiddleware(req, res, next) {
  try {
    if (req.artist) return next();

    const artist = await artistRepository.findBySlug(SINGLE_ARTIST_SLUG);
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
  if (role === 'artist_admin') return next();
  return next(new ForbiddenError('artist_admin or superadmin required'));
}

module.exports = { artistScopeMiddleware, requireArtistAdmin };

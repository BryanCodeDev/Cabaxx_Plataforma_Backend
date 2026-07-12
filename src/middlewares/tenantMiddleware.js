const { ForbiddenError } = require('../exceptions');

function tenantMiddleware(req, res, next) {
  const artistId = req.user && req.user.artistId;
  if (!artistId) {
    if (req.user && req.user.role === 'superadmin' && req.artistId) {
      return next();
    }
    return next(new ForbiddenError('No artist context available'));
  }
  req.artistId = artistId;
  next();
}

module.exports = tenantMiddleware;

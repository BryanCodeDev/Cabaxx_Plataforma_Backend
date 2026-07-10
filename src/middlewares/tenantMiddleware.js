const { ForbiddenError } = require('../exceptions');

function tenantMiddleware(req, res, next) {
  const artistId = req.user && req.user.artistId;
  if (!artistId) {
    return next(new ForbiddenError('No artist context available'));
  }
  req.artistId = artistId;
  next();
}

module.exports = tenantMiddleware;

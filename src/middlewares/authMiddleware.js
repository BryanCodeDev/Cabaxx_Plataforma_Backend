const { verifyAccessToken } = require('../utils/jwt');
const { UnauthorizedError } = require('../exceptions');

function authMiddleware(req, res, next) {
  try {
    const header = req.headers.authorization || '';
    const [scheme, token] = header.split(' ');
    if (scheme !== 'Bearer' || !token) {
      throw new UnauthorizedError('Missing or invalid Authorization header');
    }
    const payload = verifyAccessToken(token);
    req.user = { id: payload.id, role: payload.role, artistId: payload.artistId };
    next();
  } catch (error) {
    next(new UnauthorizedError('Invalid or expired token'));
  }
}

module.exports = authMiddleware;

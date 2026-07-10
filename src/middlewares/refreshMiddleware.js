const { verifyRefreshToken } = require('../utils/jwt');
const { UnauthorizedError } = require('../exceptions');

function refreshMiddleware(req, res, next) {
  try {
    const token = req.cookies.refreshToken || req.body.refreshToken;
    if (!token) throw new UnauthorizedError('Missing refresh token');
    const payload = verifyRefreshToken(token);
    req.user = { id: payload.id };
    next();
  } catch (error) {
    next(new UnauthorizedError('Invalid refresh token'));
  }
}

module.exports = refreshMiddleware;

const { ForbiddenError } = require('../exceptions');

function roleMiddleware(...allowedRoles) {
  return (req, res, next) => {
    const role = req.user && req.user.role;
    if (!role || !allowedRoles.includes(role)) {
      return next(new ForbiddenError(`Role '${role}' not allowed`));
    }
    return next();
  };
}

module.exports = roleMiddleware;

const authService = require('../services/authService');
const { ok, created, badRequest } = require('./controllerHelper');

async function register(req, res, next) {
  try {
    const user = await authService.register(req.body);
    return created(res, { user });
  } catch (err) {
    next(err);
  }
}

async function login(req, res, next) {
  try {
    const result = await authService.login(req.body);
    return ok(res, result);
  } catch (err) {
    next(err);
  }
}

async function refresh(req, res, next) {
  try {
    const refreshToken = req.body && typeof req.body.refreshToken === 'string' ? req.body.refreshToken : null;
    if (!refreshToken) return badRequest(res, 'refreshToken requerido');
    const result = await authService.refresh(refreshToken);
    return ok(res, result);
  } catch (err) {
    next(err);
  }
}

async function logout(req, res, next) {
  try {
    const refreshToken = req.body && typeof req.body.refreshToken === 'string' ? req.body.refreshToken : null;
    await authService.logout(refreshToken, req.user && req.user.id);
    return ok(res, null, 'Sesión cerrada');
  } catch (err) {
    next(err);
  }
}

async function me(req, res, next) {
  try {
    const result = await authService.me(req.user.id);
    return ok(res, { user: result });
  } catch (err) {
    next(err);
  }
}

async function forgotPassword(req, res, next) {
  try {
    await authService.forgotPassword(req.body.email);
    return ok(res, null, 'Si el email está registrado, recibirás un enlace para restablecer tu contraseña');
  } catch (err) {
    next(err);
  }
}

async function resetPassword(req, res, next) {
  try {
    await authService.resetPassword(req.body.token, req.body.password);
    return ok(res, null, 'Contraseña actualizada');
  } catch (err) {
    next(err);
  }
}

module.exports = { register, login, refresh, logout, me, forgotPassword, resetPassword };

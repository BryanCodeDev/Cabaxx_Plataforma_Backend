const authService = require('../services/authService');
const { ok, created } = require('./controllerHelper');

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
    const result = await authService.refresh(req.body.refreshToken);
    return ok(res, result);
  } catch (err) {
    next(err);
  }
}

async function logout(req, res, next) {
  try {
    await authService.logout(req.body.refreshToken);
    return ok(res, null, 'Logged out');
  } catch (err) {
    next(err);
  }
}

async function me(req, res, next) {
  try {
    return ok(res, { user: req.user });
  } catch (err) {
    next(err);
  }
}

async function forgotPassword(req, res, next) {
  try {
    await authService.forgotPassword(req.body.email);
    return ok(res, null, 'Reset link sent');
  } catch (err) {
    next(err);
  }
}

async function resetPassword(req, res, next) {
  try {
    await authService.resetPassword(req.body.token, req.body.password);
    return ok(res, null, 'Password updated');
  } catch (err) {
    next(err);
  }
}

module.exports = { register, login, refresh, logout, me, forgotPassword, resetPassword };

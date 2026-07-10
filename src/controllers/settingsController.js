const settingsService = require('../services/settingsService');
const { ok } = require('./controllerHelper');

async function getSettings(req, res, next) {
  try {
    const settings = await settingsService.get(req.artistId);
    return ok(res, { settings });
  } catch (err) {
    next(err);
  }
}

async function updateSettings(req, res, next) {
  try {
    const settings = await settingsService.update(req.artistId, req.body);
    return ok(res, { settings });
  } catch (err) {
    next(err);
  }
}

module.exports = { getSettings, updateSettings };

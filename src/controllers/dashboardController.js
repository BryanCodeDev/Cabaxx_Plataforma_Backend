const dashboardService = require('../services/dashboardService');
const { ok } = require('./controllerHelper');

async function overview(req, res, next) {
  try {
    const summary = await dashboardService.summary(req.artistId);
    return ok(res, { overview: summary });
  } catch (err) {
    next(err);
  }
}

module.exports = { overview };

const newsletterService = require('../services/newsletter.service');
const { ok, paginated, created } = require('./controllerHelper');

async function subscribe(req, res, next) {
  try {
    const subscriber = await newsletterService.subscribe(req.artistId, req.body);
    return created(res, { subscriber });
  } catch (err) {
    next(err);
  }
}

async function unsubscribe(req, res, next) {
  try {
    const { email, token } = req.query;
    const artistId = req.query.artist || (req.artist && req.artist.id);
    await newsletterService.unsubscribe(artistId, email, token);
    return ok(res, null, 'unsubscribed');
  } catch (err) {
    next(err);
  }
}

async function listSubscribers(req, res, next) {
  try {
    const { rows, total } = await newsletterService.listSubscribers(req.artistId, req.query);
    return paginated(res, rows, total, req.query.page, req.query.limit);
  } catch (err) {
    next(err);
  }
}

async function listCampaigns(req, res, next) {
  try {
    const campaigns = await newsletterService.listCampaigns(req.artistId);
    return ok(res, { campaigns });
  } catch (err) {
    next(err);
  }
}

async function createCampaign(req, res, next) {
  try {
    const campaign = await newsletterService.createCampaign(req.artistId, req.body);
    return created(res, { campaign });
  } catch (err) {
    next(err);
  }
}

async function sendCampaign(req, res, next) {
  try {
    const campaign = await newsletterService.sendCampaign(req.artistId, req.params.id);
    return ok(res, { campaign });
  } catch (err) {
    next(err);
  }
}

module.exports = { subscribe, unsubscribe, listSubscribers, listCampaigns, createCampaign, sendCampaign };

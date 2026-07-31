const seoService = require('../services/seo.service');

function resolveSlug(req) {
  return req.artist?.slug || req.params.artist_slug;
}

async function getSitemap(req, res, next) {
  try {
    const xml = await seoService.getSitemap(resolveSlug(req));
    res.set('Content-Type', 'application/xml');
    return res.send(xml);
  } catch (err) {
    next(err);
  }
}

async function getRobotsTxt(req, res, next) {
  try {
    const text = await seoService.getRobotsTxt(resolveSlug(req));
    res.set('Content-Type', 'text/plain');
    return res.send(text);
  } catch (err) {
    next(err);
  }
}

async function getSeo(req, res, next) {
  try {
    const seo = await seoService.getArtistSeo(resolveSlug(req));
    return res.json({ success: true, data: seo });
  } catch (err) {
    next(err);
  }
}

module.exports = { getSitemap, getRobotsTxt, getSeo };

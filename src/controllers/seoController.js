const seoService = require('../services/seo.service');

async function getSitemap(req, res, next) {
  try {
    const xml = await seoService.getSitemap(req.params.artist_slug);
    res.set('Content-Type', 'application/xml');
    return res.send(xml);
  } catch (err) {
    next(err);
  }
}

async function getRobotsTxt(req, res, next) {
  try {
    const text = await seoService.getRobotsTxt(req.params.artist_slug);
    res.set('Content-Type', 'text/plain');
    return res.send(text);
  } catch (err) {
    next(err);
  }
}

async function getSeo(req, res, next) {
  try {
    const seo = await seoService.getArtistSeo(req.params.artist_slug);
    return res.json({ success: true, data: seo });
  } catch (err) {
    next(err);
  }
}

module.exports = { getSitemap, getRobotsTxt, getSeo };

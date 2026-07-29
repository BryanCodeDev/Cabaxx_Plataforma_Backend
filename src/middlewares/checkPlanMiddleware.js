const db = require('../config/database');
const { ForbiddenError } = require('../exceptions');

const PLAN_FEATURES = {
  free: ['songs', 'events', 'blog'],
  pro: ['songs', 'events', 'blog', 'store', 'analytics'],
  enterprise: ['songs', 'events', 'blog', 'store', 'analytics', 'newsletter', 'videos'],
};

async function getArtistPlan(artistId) {
  const [row] = await db.query('SELECT value FROM artist_settings WHERE artist_id = ? AND `key` = ?', [artistId, 'plan']);
  return row ? row.value : 'free';
}

function checkPlan(feature) {
  return async (req, res, next) => {
    try {
      const artistId = req.artist && req.artist.id ? req.artist.id : (req.user && req.user.artistId);
      if (!artistId) return next();

      const plan = await getArtistPlan(artistId);
      const allowed = PLAN_FEATURES[plan] || PLAN_FEATURES.free;

      if (!allowed.includes(feature)) {
        return next(new ForbiddenError(`Actualiza tu plan para acceder a ${feature}`));
      }

      next();
    } catch (err) {
      next(err);
    }
  };
}

module.exports = checkPlan;

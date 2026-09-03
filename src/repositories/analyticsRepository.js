const db = require('../config/database');

async function overview(artistId) {
  if (!artistId) {
    return { tracks: 0, albums: 0, events: 0, orders: 0, revenue: 0, subscribers: 0 };
  }
  const [tracks] = await db.query('SELECT COUNT(*) AS c FROM songs WHERE artist_id = ? AND deleted_at IS NULL', [artistId]);
  const [albums] = await db.query('SELECT COUNT(*) AS c FROM albums WHERE artist_id = ? AND deleted_at IS NULL', [artistId]);
  const [events] = await db.query('SELECT COUNT(*) AS c FROM events WHERE artist_id = ? AND deleted_at IS NULL', [artistId]);
  const [orders] = await db.query(
    "SELECT COUNT(*) AS c, COALESCE(SUM(total),0) AS revenue FROM orders WHERE artist_id = ? AND deleted_at IS NULL AND status IN ('paid','processing','shipped','delivered')",
    [artistId],
  );
  const [subs] = await db.query(
    'SELECT COUNT(*) AS c FROM newsletter_subscribers WHERE artist_id = ? AND is_active = ?',
    [artistId, true],
  );
  return {
    tracks: tracks.c,
    albums: albums.c,
    events: events.c,
    orders: orders.c,
    revenue: Number(orders.revenue),
    subscribers: subs.c,
  };
}

async function topTracks(artistId, limit = 5) {
  if (!artistId) return [];
  const safeLimit = Math.min(parseInt(limit, 10) || 5, 50);
  const rows = await db.query(
    `SELECT id, title, slug, play_count FROM songs WHERE artist_id = ? AND deleted_at IS NULL ORDER BY play_count DESC LIMIT ${safeLimit}`,
    [artistId],
  );
  return rows;
}

async function salesByMonth(artistId, months = 6) {
  if (!artistId) return [];
  const safeMonths = Math.min(parseInt(months, 10) || 6, 24);
  const rows = await db.query(
    `SELECT DATE_FORMAT(created_at,'%Y-%m') AS month, COALESCE(SUM(total),0) AS total
     FROM orders WHERE artist_id = ? AND created_at >= DATE_SUB(NOW(), INTERVAL ? MONTH) AND deleted_at IS NULL
     GROUP BY month ORDER BY month`,
    [artistId, safeMonths],
  );
  return rows;
}

module.exports = { overview, topTracks, salesByMonth };

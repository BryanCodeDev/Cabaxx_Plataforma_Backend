const db = require('../config/database');

async function overview(artistId) {
  const [tracks] = await db.query('SELECT COUNT(*) AS c FROM tracks WHERE artist_id = ?', [artistId]);
  const [albums] = await db.query('SELECT COUNT(*) AS c FROM albums WHERE artist_id = ?', [artistId]);
  const [events] = await db.query('SELECT COUNT(*) AS c FROM events WHERE artist_id = ?', [artistId]);
  const [orders] = await db.query('SELECT COUNT(*) AS c, COALESCE(SUM(total),0) AS revenue FROM orders WHERE artist_id = ?', [artistId]);
  const [subs] = await db.query('SELECT COUNT(*) AS c FROM subscribers WHERE artist_id = ? AND is_active = ?', [artistId, true]);
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
  const rows = await db.query(
    `SELECT id, title, slug, plays FROM tracks WHERE artist_id = ? ORDER BY plays DESC LIMIT ?`,
    [artistId, limit],
  );
  return rows;
}

async function salesByMonth(artistId, months = 6) {
  const rows = await db.query(
    `SELECT DATE_FORMAT(created_at,'%Y-%m') AS month, COALESCE(SUM(total),0) AS total
     FROM orders WHERE artist_id = ? AND created_at >= DATE_SUB(NOW(), INTERVAL ? MONTH)
     GROUP BY month ORDER BY month`,
    [artistId, months],
  );
  return rows;
}

module.exports = { overview, topTracks, salesByMonth };

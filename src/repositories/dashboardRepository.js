const db = require('../config/database');

async function summary(artistId) {
  if (!artistId) {
    return { artist: null, pendingOrders: 0, unreadNotifications: 0, subscribers: 0 };
  }
  const [artist] = await db.query('SELECT name, slug, logo_url FROM artists WHERE id = ?', [artistId]);
  const [pendingOrders] = await db.query(
    "SELECT COUNT(*) AS c FROM orders WHERE artist_id = ? AND status = 'pending' AND deleted_at IS NULL",
    [artistId],
  );
  const [unread] = await db.query(
    'SELECT COUNT(*) AS c FROM notifications WHERE artist_id = ? AND read_at IS NULL',
    [artistId],
  );
  const [subs] = await db.query(
    'SELECT COUNT(*) AS c FROM newsletter_subscribers WHERE artist_id = ? AND is_active = ?',
    [artistId, true],
  );
  return {
    artist,
    pendingOrders: pendingOrders.c,
    unreadNotifications: unread.c,
    subscribers: subs.c,
  };
}

module.exports = { summary };

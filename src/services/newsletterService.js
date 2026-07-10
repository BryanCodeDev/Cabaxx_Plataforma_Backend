const newsletterRepository = require('../repositories/newsletterRepository');

async function subscribe(artistId, email) {
  return newsletterRepository.subscribe({ artistId, email });
}

async function list(artistId, { page, limit } = {}) {
  return newsletterRepository.findByArtist(artistId, { page, limit });
}

async function unsubscribe(token) {
  return newsletterRepository.unsubscribe(token);
}

async function sendBroadcast(artistId, subject, body) {
  const { rows } = await newsletterRepository.findByArtist(artistId, { limit: 100000 });
  return { sent: rows.filter((r) => r.is_active).length };
}

module.exports = { subscribe, list, unsubscribe, sendBroadcast };

const notificationRepository = require('../repositories/notificationRepository');

async function list(userId, artistId) {
  return notificationRepository.findByUser(userId, artistId);
}

async function markRead(id, userId) {
  return notificationRepository.markRead(id, userId);
}

async function markAllRead(userId, artistId) {
  return notificationRepository.markAllRead(userId, artistId);
}

module.exports = { list, markRead, markAllRead };

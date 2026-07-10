const likeRepository = require('../repositories/likeRepository');
const { ConflictError, NotFoundError } = require('../exceptions');

async function toggleLike(artistId, userId, referenceType, referenceId) {
  const existing = await likeRepository.findByUserAndRef(userId, referenceType, referenceId);
  if (existing) {
    await likeRepository.remove(userId, referenceType, referenceId);
    return { liked: false, count: await likeRepository.countByReference(artistId, referenceType, referenceId) };
  }
  await likeRepository.create({ userId, artistId, referenceType, referenceId });
  return { liked: true, count: await likeRepository.countByReference(artistId, referenceType, referenceId) };
}

async function getCount(artistId, referenceType, referenceId) {
  return likeRepository.countByReference(artistId, referenceType, referenceId);
}

async function getUserLikes(userId, artistId, referenceIds, referenceType) {
  return likeRepository.findUserLikes(userId, artistId, referenceIds, referenceType);
}

module.exports = { toggleLike, getCount, getUserLikes };

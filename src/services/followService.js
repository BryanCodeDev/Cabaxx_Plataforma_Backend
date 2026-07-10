const followRepository = require('../repositories/followRepository');
const { ConflictError, NotFoundError } = require('../exceptions');

async function toggleFollow(userId, artistId) {
  const existing = await followRepository.findByUserAndArtist(userId, artistId);
  if (existing) {
    await followRepository.remove(userId, artistId);
    return { following: false, count: await followRepository.countByArtist(artistId) };
  }
  await followRepository.create({ userId, artistId });
  return { following: true, count: await followRepository.countByArtist(artistId) };
}

async function getCount(artistId) {
  return followRepository.countByArtist(artistId);
}

async function checkFollow(userId, artistId) {
  return followRepository.isFollowing(userId, artistId);
}

module.exports = { toggleFollow, getCount, checkFollow };

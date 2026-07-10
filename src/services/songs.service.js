const songsRepository = require('../repositories/songs.repository');
const cloudinaryHelper = require('../helpers/cloudinaryHelper');
const { slugify } = require('../utils/slug');
const { NotFoundError } = require('../exceptions');

async function getSongs(artistId, filters = {}) {
  return songsRepository.findByArtist(artistId, filters);
}

async function getSongBySlug(artistId, slug) {
  const song = await songsRepository.findBySlug(artistId, slug);
  if (!song) throw new NotFoundError('Song not found');
  song.streaming_links = await songsRepository.findStreamingLinks(song.id);
  return song;
}

async function createSong(artistId, data, files = {}) {
  if (files.cover) {
    data.cover_url = await cloudinaryHelper.uploadBuffer(files.cover.buffer, { folder: 'map/songs', resourceType: 'image', publicName: `cover-${Date.now()}` });
  }
  if (files.audio) {
    data.audio_url = await cloudinaryHelper.uploadBuffer(files.audio.buffer, { folder: 'map/songs', resourceType: 'video', publicName: `audio-${Date.now()}` });
  }
  const payload = { ...data, artist_id: artistId, slug: slugify(data.title), plays_count: 0, likes_count: 0 };
  return songsRepository.create(payload);
}

async function updateSong(id, artistId, data, files = {}) {
  if (files.cover) {
    data.cover_url = await cloudinaryHelper.uploadBuffer(files.cover.buffer, { folder: 'map/songs', resourceType: 'image', publicName: `cover-${id}` });
  }
  if (files.audio) {
    data.audio_url = await cloudinaryHelper.uploadBuffer(files.audio.buffer, { folder: 'map/songs', resourceType: 'video', publicName: `audio-${id}` });
  }
  return songsRepository.update(id, data, artistId);
}

async function deleteSong(id, artistId) {
  const ok = await songsRepository.remove(id, artistId);
  if (!ok) throw new NotFoundError('Song not found');
  return true;
}

async function registerPlay(songId, userId, data = {}) {
  await songsRepository.incrementPlays(songId, userId, data);
  return true;
}

module.exports = { getSongs, getSongBySlug, createSong, updateSong, deleteSong, registerPlay };

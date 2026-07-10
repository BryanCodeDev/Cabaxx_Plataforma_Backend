const albumsRepository = require('../repositories/albums.repository');
const { slugify } = require('../utils/slug');
const { NotFoundError } = require('../exceptions');

async function getAlbums(artistId, filters = {}) {
  return albumsRepository.findByArtist(artistId, filters);
}

async function getAlbumBySlug(artistId, slug) {
  const album = await albumsRepository.findBySlug(artistId, slug);
  if (!album) throw new NotFoundError('Album not found');
  return album;
}

async function createAlbum(artistId, data) {
  const payload = { ...data, artist_id: artistId, slug: slugify(data.title) };
  const album = await albumsRepository.create(payload);
  if (Array.isArray(data.songs)) {
    for (let i = 0; i < data.songs.length; i++) {
      await albumsRepository.addSong(album.id, data.songs[i], i + 1);
    }
  }
  return album;
}

async function updateAlbum(id, artistId, data) {
  return albumsRepository.update(id, data, artistId);
}

async function deleteAlbum(id, artistId) {
  const ok = await albumsRepository.remove(id, artistId);
  if (!ok) throw new NotFoundError('Album not found');
  return true;
}

async function addSong(albumId, songId, trackNumber) {
  return albumsRepository.addSong(albumId, songId, trackNumber);
}

async function removeSong(albumId, songId) {
  return albumsRepository.removeSong(albumId, songId);
}

async function reorderSongs(albumId, songsOrder) {
  return albumsRepository.reorderSongs(albumId, songsOrder);
}

module.exports = { getAlbums, getAlbumBySlug, createAlbum, updateAlbum, deleteAlbum, addSong, removeSong, reorderSongs };

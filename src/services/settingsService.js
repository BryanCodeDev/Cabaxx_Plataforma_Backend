const settingsRepository = require('../repositories/settingsRepository');

async function get(artistId) {
  return settingsRepository.getByArtist(artistId);
}

async function update(artistId, settings) {
  return settingsRepository.setMany(artistId, settings);
}

module.exports = { get, update };

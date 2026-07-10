const BaseRepository = require('./baseRepository');
const TrackModel = require('../models/Track.model');

class TrackRepository extends BaseRepository {
  constructor() {
    super(TrackModel);
  }

  async findByAlbum(albumId, artistId) {
    const { rows } = await this.findAll({ artistId, where: { album_id: albumId } });
    return rows;
  }
}

module.exports = new TrackRepository();

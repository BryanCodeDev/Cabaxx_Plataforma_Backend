const BaseRepository = require('./baseRepository');
const AlbumModel = require('../models/Album.model');

class AlbumRepository extends BaseRepository {
  constructor() {
    super(AlbumModel);
  }
}

module.exports = new AlbumRepository();

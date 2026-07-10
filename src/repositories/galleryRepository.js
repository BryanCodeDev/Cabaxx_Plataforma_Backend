const BaseRepository = require('./baseRepository');
const GalleryModel = require('../models/GalleryImage.model');

class GalleryRepository extends BaseRepository {
  constructor() {
    super(GalleryModel);
  }
}

module.exports = new GalleryRepository();

const BaseRepository = require('./baseRepository');
const NewsModel = require('../models/News.model');

class NewsRepository extends BaseRepository {
  constructor() {
    super(NewsModel);
  }
}

module.exports = new NewsRepository();

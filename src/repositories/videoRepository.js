const db = require('../config/database');
const BaseRepository = require('./baseRepository');
const VideoModel = require('../models/Video.model');

class VideoRepository extends BaseRepository {
  constructor() {
    super(VideoModel);
  }

  async findBySlug(slug, artistId) {
    const [row] = await db.query('SELECT * FROM videos WHERE slug = ? AND artist_id = ?', [slug, artistId]);
    return row || null;
  }
}

module.exports = new VideoRepository();

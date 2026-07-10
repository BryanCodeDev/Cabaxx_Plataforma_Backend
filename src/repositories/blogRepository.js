const BaseRepository = require('./baseRepository');
const PostModel = require('../models/Post.model');

class BlogRepository extends BaseRepository {
  constructor() {
    super(PostModel);
  }

  async findBySlug(slug, artistId) {
    const [row] = await require('../config/database').query(
      `SELECT * FROM ${PostModel.tableName} WHERE slug = ? AND artist_id = ?`,
      [slug, artistId],
    );
    return row || null;
  }
}

module.exports = new BlogRepository();

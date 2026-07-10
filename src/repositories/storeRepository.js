const BaseRepository = require('./baseRepository');
const ProductModel = require('../models/Product.model');

class StoreRepository extends BaseRepository {
  constructor() {
    super(ProductModel);
  }
}

module.exports = new StoreRepository();

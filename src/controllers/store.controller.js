const storeService = require('../services/store.service');
const { ok, paginated, created } = require('./controllerHelper');

async function listProducts(req, res, next) {
  try {
    const { rows, total } = await storeService.getProducts(req.artistId, req.query);
    return paginated(res, rows, total, req.query.page, req.query.limit);
  } catch (err) {
    next(err);
  }
}

async function getProduct(req, res, next) {
  try {
    const product = await storeService.getProductBySlug(req.artistId, req.params.slug);
    return ok(res, { product });
  } catch (err) {
    next(err);
  }
}

async function createProduct(req, res, next) {
  try {
    const product = await storeService.createProduct(req.artistId, req.body, req.files);
    return created(res, { product });
  } catch (err) {
    next(err);
  }
}

async function updateProduct(req, res, next) {
  try {
    const product = await storeService.updateProduct(req.params.id, req.artistId, req.body, req.files);
    return ok(res, { product });
  } catch (err) {
    next(err);
  }
}

async function listCategories(req, res, next) {
  try {
    const categories = await storeService.getCategories(req.artistId);
    return ok(res, { categories });
  } catch (err) {
    next(err);
  }
}

async function createCategory(req, res, next) {
  try {
    const category = await storeService.createCategory(req.artistId, req.body);
    return created(res, { category });
  } catch (err) {
    next(err);
  }
}

async function validateCoupon(req, res, next) {
  try {
    const { code, subtotal } = req.query;
    const result = await storeService.validateCoupon(req.artistId, code, Number(subtotal) || 0);
    return ok(res, result);
  } catch (err) {
    next(err);
  }
}

module.exports = { listProducts, getProduct, createProduct, updateProduct, listCategories, createCategory, validateCoupon };

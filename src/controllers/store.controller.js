const storeService = require('../services/store.service');
const { ok, paginatedAs, created, noContent, badRequest } = require('./controllerHelper');

async function listProducts(req, res, next) {
  try {
    const { rows, total } = await storeService.getProducts(req.artistId, req.query);
    return paginatedAs(res, 'products', rows, total, req.query.page, req.query.limit);
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
    if (!code) return badRequest(res, 'code requerido');
    const result = await storeService.validateCoupon(req.artistId, code, Number(subtotal) || 0);
    return ok(res, result);
  } catch (err) {
    next(err);
  }
}

async function deleteProduct(req, res, next) {
  try {
    await storeService.deleteProduct(req.params.id, req.artistId);
    return noContent(res);
  } catch (err) {
    next(err);
  }
}

async function updateCategory(req, res, next) {
  try {
    const category = await storeService.updateCategory(req.params.id, req.artistId, req.body);
    return ok(res, { category });
  } catch (err) {
    next(err);
  }
}

async function deleteCategory(req, res, next) {
  try {
    await storeService.deleteCategory(req.params.id, req.artistId);
    return noContent(res);
  } catch (err) {
    next(err);
  }
}

async function listCoupons(req, res, next) {
  try {
    const { rows, total } = await storeService.listCoupons(req.artistId, req.query);
    return paginatedAs(res, 'coupons', rows, total, req.query.page, req.query.limit);
  } catch (err) {
    next(err);
  }
}

async function createCoupon(req, res, next) {
  try {
    const coupon = await storeService.createCoupon(req.artistId, req.body);
    return created(res, { coupon });
  } catch (err) {
    next(err);
  }
}

async function updateCoupon(req, res, next) {
  try {
    const coupon = await storeService.updateCoupon(req.params.id, req.artistId, req.body);
    return ok(res, { coupon });
  } catch (err) {
    next(err);
  }
}

async function deleteCoupon(req, res, next) {
  try {
    await storeService.deleteCoupon(req.params.id, req.artistId);
    return noContent(res);
  } catch (err) {
    next(err);
  }
}

module.exports = {
  listProducts,
  getProduct,
  createProduct,
  updateProduct,
  deleteProduct,
  listCategories,
  createCategory,
  updateCategory,
  deleteCategory,
  listCoupons,
  createCoupon,
  updateCoupon,
  deleteCoupon,
  validateCoupon,
};

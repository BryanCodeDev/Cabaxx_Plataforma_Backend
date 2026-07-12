const storeRepository = require('../repositories/store.repository');
const cloudinaryHelper = require('../helpers/cloudinaryHelper');
const { slugify } = require('../utils/slug');
const { NotFoundError, ValidationError } = require('../exceptions');

async function getProducts(artistId, filters = {}) {
  return storeRepository.findAll(artistId, filters);
}

async function getProductBySlug(artistId, slug) {
  const product = await storeRepository.findBySlug(artistId, slug);
  if (!product) throw new NotFoundError('Product not found');
  return product;
}

async function createProduct(artistId, data, files = {}) {
  const coverUrl = await manageCoverUpload(files, null);
  const payload = {
    artist_id: artistId,
    category_id: data.category_id || null,
    name: data.name,
    slug: slugify(data.name),
    description: data.description || null,
    price: data.price,
    compare_at_price: data.compare_at_price || null,
    currency: data.currency || 'USD',
    sku: data.sku || null,
    stock_quantity: data.stock_quantity || 0,
    type: data.type || 'physical',
    cover_url: coverUrl,
    status: data.status || 'active',
    weight_grams: data.weight_grams || null,
  };
  const product = await storeRepository.create(payload);
  if (Array.isArray(data.images)) {
    for (let i = 0; i < data.images.length; i++) {
      await dbImage(product.id, data.images[i], i);
    }
  }
  return product;
}

async function updateProduct(id, artistId, data, files = {}) {
  const coverUrl = await manageCoverUpload(files, data.existing_cover_url);
  const payload = { ...data };
  delete payload.existing_cover_url;
  if (coverUrl !== undefined) payload.cover_url = coverUrl;
  return storeRepository.update(id, payload, artistId);
}

// Sube la portada a Cloudinary (o la elimina si se solicitó)
async function manageCoverUpload(files, existingUrl) {
  if (files && files.cover) {
    if (existingUrl) await cloudinaryHelper.destroy(existingUrl, 'image');
    return cloudinaryHelper.uploadBuffer(files.cover.buffer, { folder: 'map/products', resourceType: 'image', publicName: `cover-${Date.now()}` });
  }
  if (files && files.remove_cover && existingUrl) {
    await cloudinaryHelper.destroy(existingUrl, 'image');
    return null;
  }
  return existingUrl;
}

async function getCategories(artistId) {
  return storeRepository.getCategories(artistId);
}

async function createCategory(artistId, data) {
  return storeRepository.createCategory({
    artist_id: artistId,
    name: data.name,
    slug: slugify(data.name),
    description: data.description || null,
    image_url: data.image_url || null,
    parent_id: data.parent_id || null,
    sort_order: data.sort_order || 0,
  });
}

async function validateCoupon(artistId, code, subtotal) {
  const coupon = await storeRepository.findCouponByCode(artistId, code);
  if (!coupon) throw new NotFoundError('Cupón no válido');
  if (coupon.status !== 'active') throw new ValidationError('Cupón inactivo');
  if (coupon.expires_at && new Date(coupon.expires_at) < new Date()) throw new ValidationError('Cupón expirado');
  if (coupon.max_uses && coupon.uses_count >= coupon.max_uses) throw new ValidationError('Cupón agotado');
  if (coupon.min_purchase && subtotal < coupon.min_purchase) {
    throw new ValidationError(`El mínimo de compra es ${coupon.min_purchase}`);
  }
  const discount = coupon.type === 'percent'
    ? Number((subtotal * (coupon.value / 100)).toFixed(2))
    : Number(coupon.value);
  return { couponId: coupon.id, discount, code: coupon.code };
}

async function deleteProduct(id, artistId) {
  const ok = await storeRepository.softDelete(id, artistId);
  if (!ok) throw new NotFoundError('Product not found');
  return true;
}

async function updateCategory(id, artistId, data) {
  return storeRepository.updateCategory(id, {
    name: data.name,
    slug: data.slug ? slugify(data.slug) : slugify(data.name),
    description: data.description || null,
    image_url: data.image_url || null,
    parent_id: data.parent_id || null,
    sort_order: data.sort_order || 0,
  }, artistId);
}

async function deleteCategory(id, artistId) {
  const ok = await storeRepository.deleteCategory(id, artistId);
  if (!ok) throw new NotFoundError('Category not found');
  return true;
}

async function listCoupons(artistId, filters = {}) {
  return storeRepository.listCoupons(artistId, filters);
}

async function createCoupon(artistId, data) {
  return storeRepository.createCoupon({
    artist_id: artistId,
    code: String(data.code || '').toUpperCase(),
    type: data.type || 'percent',
    value: data.value || 0,
    min_purchase: data.min_purchase || 0,
    max_uses: data.max_uses || null,
    expires_at: data.expires_at || null,
    status: data.status || 'active',
  });
}

async function updateCoupon(id, artistId, data) {
  const payload = {};
  if (data.code !== undefined) payload.code = String(data.code).toUpperCase();
  if (data.type !== undefined) payload.type = data.type;
  if (data.value !== undefined) payload.value = data.value;
  if (data.min_purchase !== undefined) payload.min_purchase = data.min_purchase;
  if (data.max_uses !== undefined) payload.max_uses = data.max_uses;
  if (data.expires_at !== undefined) payload.expires_at = data.expires_at;
  if (data.status !== undefined) payload.status = data.status;
  return storeRepository.updateCoupon(id, payload, artistId);
}

async function deleteCoupon(id, artistId) {
  const ok = await storeRepository.deleteCoupon(id, artistId);
  if (!ok) throw new NotFoundError('Coupon not found');
  return true;
}

// helpers
const db = require('../config/database');
async function dbImage(productId, url, sortOrder) {
  await db.query('INSERT INTO product_images (product_id, url, sort_order) VALUES (?, ?, ?)', [productId, url, sortOrder]);
}

module.exports = {
  getProducts,
  getProductBySlug,
  createProduct,
  updateProduct,
  deleteProduct,
  getCategories,
  createCategory,
  updateCategory,
  deleteCategory,
  listCoupons,
  createCoupon,
  updateCoupon,
  deleteCoupon,
  validateCoupon,
};

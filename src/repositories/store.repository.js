const db = require('../config/database');
const ProductModel = require('../models/Product.model');
const CategoryModel = require('../models/ProductCategory.model');
const CouponModel = require('../models/Coupon.model');

function buildWhere(artistId, { categoryId, type, status, search, minPrice, maxPrice } = {}) {
  const clauses = ['artist_id = ?', 'deleted_at IS NULL'];
  const params = [artistId];
  if (categoryId) {
    clauses.push('category_id = ?');
    params.push(categoryId);
  }
  if (type) {
    clauses.push('type = ?');
    params.push(type);
  }
  if (status) {
    clauses.push('status = ?');
    params.push(status);
  }
  if (search) {
    clauses.push('(name LIKE ? OR sku LIKE ?)');
    params.push(`%${search}%`, `%${search}%`);
  }
  if (minPrice !== undefined) {
    clauses.push('price >= ?');
    params.push(minPrice);
  }
  if (maxPrice !== undefined) {
    clauses.push('price <= ?');
    params.push(maxPrice);
  }
  return { clause: `WHERE ${clauses.join(' AND ')}`, params };
}

async function findAll(artistId, { page = 1, limit = 20, categoryId, type, status, search, minPrice, maxPrice, sort } = {}) {
  const { clause, params } = buildWhere(artistId, { categoryId, type, status, search, minPrice, maxPrice });
  const [{ total }] = await db.query(`SELECT COUNT(*) AS total FROM ${ProductModel.tableName} ${clause}`, params);
  const offset = (parseInt(page, 10) - 1) * parseInt(limit, 10);
  const allowedSort = {
    price_asc: 'price ASC',
    price_desc: 'price DESC',
    newest: 'created_at DESC',
    name: 'name ASC',
  };
  const orderBy = allowedSort[sort] || 'created_at DESC';
  const rows = await db.query(`SELECT * FROM ${ProductModel.tableName} ${clause} ORDER BY ${orderBy} LIMIT ? OFFSET ?`, [...params, parseInt(limit, 10), offset]);
  return { rows, total };
}

async function findBySlug(artistId, slug) {
  const [product] = await db.query(`SELECT * FROM ${ProductModel.tableName} WHERE artist_id = ? AND slug = ? AND deleted_at IS NULL`, [artistId, slug]);
  if (!product) return null;
  product.images = await db.query('SELECT id, url, alt_text, sort_order FROM product_images WHERE product_id = ? ORDER BY sort_order', [product.id]);
  product.variants = await db.query('SELECT id, name, options_json, price, sku, stock_quantity FROM product_variants WHERE product_id = ?', [product.id]);
  return product;
}

async function findById(id, artistId) {
  let sql = `SELECT * FROM ${ProductModel.tableName} WHERE id = ?`;
  const params = [id];
  if (artistId) {
    sql += ' AND artist_id = ?';
    params.push(artistId);
  }
  sql += ' AND deleted_at IS NULL';
  const [row] = await db.query(sql, params);
  return row || null;
}

async function create(data) {
  const keys = Object.keys(data);
  const placeholders = keys.map(() => '?').join(', ');
  const [result] = await db.query(`INSERT INTO ${ProductModel.tableName} (${keys.join(', ')}) VALUES (${placeholders})`, keys.map((k) => data[k]));
  return findById(result.insertId);
}

async function update(id, data, artistId) {
  const keys = Object.keys(data).filter((k) => k !== 'id');
  if (!keys.length) return findById(id, artistId);
  const assignments = keys.map((k) => `${k} = ?`).join(', ');
  let sql = `UPDATE ${ProductModel.tableName} SET ${assignments} WHERE id = ?`;
  const params = keys.map((k) => data[k]);
  params.push(id);
  if (artistId) {
    sql += ' AND artist_id = ?';
    params.push(artistId);
  }
  await db.query(sql, params);
  return findById(id, artistId);
}

// Operación atómica de stock sobre una conexión de transacción
async function updateStockConn(conn, productId, quantity, operation) {
  if (operation === 'subtract') {
    const [result] = await conn.query(
      `UPDATE ${ProductModel.tableName} SET stock_quantity = stock_quantity - ? WHERE id = ? AND stock_quantity >= ?`,
      [quantity, productId, quantity],
    );
    if (result.affectedRows === 0) {
      const [row] = await conn.query(`SELECT name, stock_quantity FROM ${ProductModel.tableName} WHERE id = ?`, [productId]);
      const { ValidationError } = require('../exceptions');
      throw new ValidationError(`Solo quedan ${row ? row.stock_quantity : 0} unidades de ${row ? row.name : 'este producto'}`);
    }
  } else {
    await conn.query(`UPDATE ${ProductModel.tableName} SET stock_quantity = stock_quantity + ? WHERE id = ?`, [quantity, productId]);
  }
  const [row] = await conn.query(`SELECT stock_quantity FROM ${ProductModel.tableName} WHERE id = ?`, [productId]);
  return row.stock_quantity;
}

async function getCategories(artistId) {
  return db.query(`SELECT * FROM ${CategoryModel.tableName} WHERE artist_id = ? ORDER BY sort_order, name`, [artistId]);
}

async function createCategory(data) {
  const keys = Object.keys(data);
  const placeholders = keys.map(() => '?').join(', ');
  const [result] = await db.query(`INSERT INTO ${CategoryModel.tableName} (${keys.join(', ')}) VALUES (${placeholders})`, keys.map((k) => data[k]));
  const [row] = await db.query(`SELECT * FROM ${CategoryModel.tableName} WHERE id = ?`, [result.insertId]);
  return row;
}

async function findCouponByCode(artistId, code) {
  const [row] = await db.query(`SELECT * FROM ${CouponModel.tableName} WHERE artist_id = ? AND code = ?`, [artistId, code]);
  return row || null;
}

async function incrementCouponUses(conn, couponId) {
  const [result] = await conn.query(
    `UPDATE ${CouponModel.tableName}
     SET uses_count = uses_count + 1
     WHERE id = ? AND status = 'active' AND (max_uses IS NULL OR uses_count < max_uses)`,
    [couponId],
  );
  return result.affectedRows > 0;
}

async function softDelete(id, artistId) {
  const [result] = await db.query(
    `UPDATE ${ProductModel.tableName} SET deleted_at = NOW() WHERE id = ? AND artist_id = ? AND deleted_at IS NULL`,
    [id, artistId],
  );
  return result.affectedRows > 0;
}

async function updateCategory(id, data, artistId) {
  const keys = Object.keys(data).filter((k) => k !== 'id');
  if (!keys.length) return db.query(`SELECT * FROM ${CategoryModel.tableName} WHERE id = ?`, [id]).then(([r]) => r);
  const assignments = keys.map((k) => `${k} = ?`).join(', ');
  await db.query(`UPDATE ${CategoryModel.tableName} SET ${assignments} WHERE id = ? AND artist_id = ?`, [...keys.map((k) => data[k]), id, artistId]);
  const [row] = await db.query(`SELECT * FROM ${CategoryModel.tableName} WHERE id = ?`, [id]);
  return row;
}

async function deleteCategory(id, artistId) {
  const [result] = await db.query(`DELETE FROM ${CategoryModel.tableName} WHERE id = ? AND artist_id = ?`, [id, artistId]);
  return result.affectedRows > 0;
}

async function listCoupons(artistId, { status, search } = {}) {
  const clauses = ['artist_id = ?'];
  const params = [artistId];
  if (status) {
    clauses.push('status = ?');
    params.push(status);
  }
  if (search) {
    clauses.push('code LIKE ?');
    params.push(`%${search}%`);
  }
  const rows = await db.query(
    `SELECT * FROM ${CouponModel.tableName} WHERE ${clauses.join(' AND ')} ORDER BY created_at DESC`,
    params,
  );
  return { rows, total: rows.length };
}

async function createCoupon(data) {
  const keys = Object.keys(data);
  const placeholders = keys.map(() => '?').join(', ');
  const [result] = await db.query(`INSERT INTO ${CouponModel.tableName} (${keys.join(', ')}) VALUES (${placeholders})`, keys.map((k) => data[k]));
  const [row] = await db.query(`SELECT * FROM ${CouponModel.tableName} WHERE id = ?`, [result.insertId]);
  return row;
}

async function updateCoupon(id, data, artistId) {
  const keys = Object.keys(data).filter((k) => k !== 'id');
  if (!keys.length) return db.query(`SELECT * FROM ${CouponModel.tableName} WHERE id = ?`, [id]).then(([r]) => r);
  const assignments = keys.map((k) => `${k} = ?`).join(', ');
  await db.query(`UPDATE ${CouponModel.tableName} SET ${assignments} WHERE id = ? AND artist_id = ?`, [...keys.map((k) => data[k]), id, artistId]);
  const [row] = await db.query(`SELECT * FROM ${CouponModel.tableName} WHERE id = ?`, [id]);
  return row;
}

async function deleteCoupon(id, artistId) {
  const [result] = await db.query(`DELETE FROM ${CouponModel.tableName} WHERE id = ? AND artist_id = ?`, [id, artistId]);
  return result.affectedRows > 0;
}

module.exports = {
  findAll,
  findBySlug,
  findById,
  create,
  update,
  updateStockConn,
  getCategories,
  createCategory,
  findCouponByCode,
  incrementCouponUses,
  softDelete,
  updateCategory,
  deleteCategory,
  listCoupons,
  createCoupon,
  updateCoupon,
  deleteCoupon,
};

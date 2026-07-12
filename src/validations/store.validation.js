const { body, param, query } = require('express-validator');

const listProducts = [
  query('page').optional().isInt({ min: 1 }),
  query('limit').optional().isInt({ min: 1, max: 100 }),
  query('type').optional().isIn(['physical', 'digital', 'ticket']),
  query('status').optional().isString(),
  query('sort').optional().isIn(['price_asc', 'price_desc', 'newest', 'name']),
  query('min_price').optional().isFloat(),
  query('max_price').optional().isFloat(),
];

const getProduct = [param('slug').notEmpty()];

const createProduct = [
  body('name').notEmpty().withMessage('Name required'),
  body('price').isFloat({ min: 0 }).withMessage('Price must be >= 0'),
  body('currency').optional().isLength({ min: 3, max: 3 }),
  body('stock_quantity').optional().isInt({ min: 0 }),
  body('type').optional().isIn(['physical', 'digital', 'ticket']),
];

const updateProduct = [
  param('id').isInt(),
  body('name').optional().isString(),
  body('price').optional().isFloat({ min: 0 }),
];

const createCategory = [
  body('name').notEmpty().withMessage('Name required'),
];

const validateCoupon = [
  query('code').notEmpty().withMessage('code required'),
  query('subtotal').optional().isFloat(),
];

const createCoupon = [
  body('code').notEmpty().withMessage('Code required'),
  body('type').optional().isIn(['percent', 'fixed']),
  body('value').isFloat({ min: 0 }).withMessage('Value required'),
  body('min_purchase').optional().isFloat({ min: 0 }),
  body('max_uses').optional().isInt({ min: 1 }),
  body('expires_at').optional().isString(),
  body('status').optional().isIn(['active', 'inactive', 'expired']),
];

const updateCoupon = [
  param('id').isInt(),
  body('code').optional().isString(),
  body('type').optional().isIn(['percent', 'fixed']),
  body('value').optional().isFloat({ min: 0 }),
  body('min_purchase').optional().isFloat({ min: 0 }),
  body('max_uses').optional().isInt({ min: 1 }),
  body('expires_at').optional().isString(),
  body('status').optional().isIn(['active', 'inactive', 'expired']),
];

module.exports = { listProducts, getProduct, createProduct, updateProduct, createCategory, createCoupon, updateCoupon, validateCoupon };

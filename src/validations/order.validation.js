const { body, param } = require('express-validator');

const checkout = [
  body('artist_id').isInt().withMessage('artist_id required'),
  body('items').isArray({ min: 1 }).withMessage('items required'),
  body('items.*.productId').isInt().withMessage('productId required'),
  body('items.*.quantity').isInt({ min: 1 }).withMessage('quantity >= 1'),
  body('coupon_code').optional().isString(),
  body('shipping_address').optional().isObject(),
];

const updateStatus = [
  param('id').isInt(),
  body('status').isIn(['pending', 'paid', 'processing', 'shipped', 'delivered', 'cancelled', 'refunded']),
];

const subscribe = [
  body('tier_id').isInt().withMessage('tier_id required'),
];

module.exports = { checkout, updateStatus, subscribe };

module.exports = {
  tableName: 'orders',
  columns: {
    id: 'id',
    userId: 'user_id',
    artistId: 'artist_id',
    status: 'status',
    subtotal: 'subtotal',
    discount: 'discount',
    shipping: 'shipping',
    tax: 'tax',
    total: 'total',
    currency: 'currency',
    couponId: 'coupon_id',
    notes: 'notes',
    shippingAddressJson: 'shipping_address_json',
    deletedAt: 'deleted_at',
  },
};

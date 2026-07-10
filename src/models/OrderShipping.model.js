module.exports = {
  tableName: 'order_shipping',
  columns: {
    id: 'id',
    orderId: 'order_id',
    carrier: 'carrier',
    trackingNumber: 'tracking_number',
    status: 'status',
    shippedAt: 'shipped_at',
    deliveredAt: 'delivered_at',
    addressJson: 'address_json',
  },
};

module.exports = {
  tableName: 'order_items',
  columns: {
    id: 'id',
    orderId: 'order_id',
    productId: 'product_id',
    variantId: 'variant_id',
    quantity: 'quantity',
    unitPrice: 'unit_price',
    totalPrice: 'total_price',
    snapshotJson: 'snapshot_json',
  },
};

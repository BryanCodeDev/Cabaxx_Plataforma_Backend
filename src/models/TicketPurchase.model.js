module.exports = {
  tableName: 'ticket_purchases',
  columns: {
    id: 'id',
    userId: 'user_id',
    ticketId: 'ticket_id',
    quantity: 'quantity',
    totalPrice: 'total_price',
    status: 'status',
    qrCode: 'qr_code',
    usedAt: 'used_at',
  },
};

module.exports = {
  tableName: 'payments',
  columns: {
    id: 'id',
    orderId: 'order_id',
    userId: 'user_id',
    artistId: 'artist_id',
    provider: 'provider',
    providerTxId: 'provider_tx_id',
    amount: 'amount',
    currency: 'currency',
    status: 'status',
    responseJson: 'response_json',
    paidAt: 'paid_at',
  },
};

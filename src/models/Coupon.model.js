module.exports = {
  tableName: 'coupons',
  columns: {
    id: 'id',
    artistId: 'artist_id',
    code: 'code',
    type: 'type',
    value: 'value',
    minPurchase: 'min_purchase',
    maxUses: 'max_uses',
    usesCount: 'uses_count',
    expiresAt: 'expires_at',
    status: 'status',
  },
};

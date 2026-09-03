module.exports = {
  tableName: 'notifications',
  columns: {
    id: 'id',
    artistId: 'artist_id',
    userId: 'user_id',
    type: 'type',
    title: 'title',
    body: 'body',
    data: 'data_json',
    readAt: 'read_at',
    sentAt: 'sent_at',
    createdAt: 'created_at',
  },
};

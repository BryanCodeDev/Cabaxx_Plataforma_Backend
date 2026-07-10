module.exports = {
  tableName: 'artist_social_links',
  columns: {
    id: 'id',
    artistId: 'artist_id',
    platform: 'platform',
    url: 'url',
    followersCount: 'followers_count',
    lastSyncedAt: 'last_synced_at',
  },
};

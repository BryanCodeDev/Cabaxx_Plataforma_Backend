module.exports = {
  tableName: 'song_plays',
  columns: {
    id: 'id',
    songId: 'song_id',
    artistId: 'artist_id',
    userId: 'user_id',
    source: 'source',
    durationPlayedSeconds: 'duration_played_seconds',
    completed: 'completed',
  },
};

function resolveArtistId(req) {
  if (req.user && req.user.artistId) return req.user.artistId;
  if (req.params && req.params.artistId) return req.params.artistId;
  if (req.query && req.query.artist) return req.query.artist;
  return null;
}

function enforceTenantFilter(query, artistId) {
  if (!artistId) return query;
  return { ...query, artist_id: artistId };
}

module.exports = { resolveArtistId, enforceTenantFilter };

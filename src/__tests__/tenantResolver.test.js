const { resolveArtist } = require('../middlewares/tenantResolver');

describe('tenantResolver', () => {
  it('does nothing when no artist slug is provided', async () => {
    const req = { headers: {}, query: {}, hostname: 'localhost' };
    const next = jest.fn();
    await resolveArtist(req, null, next);
    expect(req.artist).toBeUndefined();
    expect(req.artistId).toBeUndefined();
    expect(next).toHaveBeenCalled();
  });

  it('resolves from X-Artist-Slug header', async () => {
    const req = { headers: { 'x-artist-slug': 'cabaxx' }, query: {}, hostname: 'localhost' };
    const next = jest.fn();
    await resolveArtist(req, null, next);
    expect(req.artist).toBeDefined();
    expect(req.artist.slug).toBe('cabaxx');
    expect(req.artistId).toBe(req.artist.id);
    expect(next).toHaveBeenCalled();
  });
});

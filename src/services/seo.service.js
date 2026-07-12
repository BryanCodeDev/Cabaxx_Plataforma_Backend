const db = require('../config/database');
const { NotFoundError } = require('../exceptions');

const PUBLIC_ROUTES = [
  { loc: '/', changefreq: 'daily', priority: '1.0' },
  { loc: '/canciones', changefreq: 'daily', priority: '0.9' },
  { loc: '/eventos', changefreq: 'daily', priority: '0.9' },
  { loc: '/blog', changefreq: 'weekly', priority: '0.8' },
  { loc: '/noticias', changefreq: 'weekly', priority: '0.8' },
  { loc: '/tienda', changefreq: 'weekly', priority: '0.8' },
  { loc: '/galeria', changefreq: 'weekly', priority: '0.7' },
];

function escapeXml(str) {
  return String(str)
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&apos;');
}

async function getSitemap(artistSlug) {
  const [artist] = await db.query('SELECT slug, updated_at FROM artists WHERE slug = ? AND status = ?', [artistSlug, 'active']);
  if (!artist) throw new NotFoundError('Artist not found');

  const origin = 'https://cabaxx.com';
  const baseUrl = `${origin}/${artistSlug}`;
  const now = new Date().toISOString();

  let xml = '<?xml version="1.0" encoding="UTF-8"?>\n';
  xml += '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">\n';

  for (const route of PUBLIC_ROUTES) {
    xml += '  <url>\n';
    xml += `    <loc>${escapeXml(baseUrl + route.loc)}</loc>\n`;
    xml += `    <lastmod>${artist.updated_at || now}</lastmod>\n`;
    xml += `    <changefreq>${route.changefreq}</changefreq>\n`;
    xml += `    <priority>${route.priority}</priority>\n`;
    xml += '  </url>\n';
  }

  const songs = await db.query('SELECT slug, updated_at FROM songs WHERE artist_id = ? AND status = ?', [artist.id, 'published']);
  for (const song of songs) {
    xml += '  <url>\n';
    xml += `    <loc>${escapeXml(baseUrl + '/canciones/' + song.slug)}</loc>\n`;
    xml += `    <lastmod>${song.updated_at || now}</lastmod>\n`;
    xml += '    <changefreq>monthly</changefreq>\n';
    xml += '    <priority>0.7</priority>\n';
    xml += '  </url>\n';
  }

  const events = await db.query('SELECT slug, updated_at FROM events WHERE artist_id = ? AND status = ?', [artist.id, 'published']);
  for (const ev of events) {
    xml += '  <url>\n';
    xml += `    <loc>${escapeXml(baseUrl + '/eventos/' + ev.slug)}</loc>\n`;
    xml += `    <lastmod>${ev.updated_at || now}</lastmod>\n`;
    xml += '    <changefreq>weekly</changefreq>\n';
    xml += '    <priority>0.8</priority>\n';
    xml += '  </url>\n';
  }

  const posts = await db.query('SELECT slug, type, updated_at FROM posts WHERE artist_id = ? AND status = ?', [artist.id, 'published']);
  for (const post of posts) {
    const prefix = post.type === 'news' ? '/noticias' : '/blog';
    xml += '  <url>\n';
    xml += `    <loc>${escapeXml(baseUrl + prefix + '/' + post.slug)}</loc>\n`;
    xml += `    <lastmod>${post.updated_at || now}</lastmod>\n`;
    xml += '    <changefreq>weekly</changefreq>\n';
    xml += '    <priority>0.7</priority>\n';
    xml += '  </url>\n';
  }

  const products = await db.query('SELECT slug, updated_at FROM products WHERE artist_id = ? AND status = ?', [artist.id, 'active']);
  for (const prod of products) {
    xml += '  <url>\n';
    xml += `    <loc>${escapeXml(baseUrl + '/tienda/' + prod.slug)}</loc>\n`;
    xml += `    <lastmod>${prod.updated_at || now}</lastmod>\n`;
    xml += '    <changefreq>weekly</changefreq>\n';
    xml += '    <priority>0.6</priority>\n';
    xml += '  </url>\n';
  }

  xml += '</urlset>';
  return xml;
}

async function getRobotsTxt(artistSlug) {
  const [artist] = await db.query('SELECT slug FROM artists WHERE slug = ? AND status = ?', [artistSlug, 'active']);
  if (!artist) throw new NotFoundError('Artist not found');

  const baseUrl = `https://cabaxx.com/${artistSlug}`;
  return `User-agent: *\nAllow: /\n\nSitemap: ${baseUrl}/sitemap.xml\n`;
}

async function getArtistSeo(artistSlug) {
  const [artist] = await db.query('SELECT id FROM artists WHERE slug = ? AND status = ?', [artistSlug, 'active']);
  if (!artist) throw new NotFoundError('Artist not found');

  const [seo] = await db.query('SELECT * FROM artist_seo WHERE artist_id = ?', [artist.id]);
  if (!seo) {
    return {
      meta_title: null,
      meta_description: null,
      keywords: null,
      og_image_url: null,
      schema_json: null,
      robots: 'index,follow',
    };
  }
  return seo;
}

function buildJsonLd(artist, type, data) {
  const base = {
    '@context': 'https://schema.org',
    '@type': 'MusicGroup',
    name: artist.stage_name || artist.name,
    url: `https://cabaxx.com/${artist.slug}`,
  };

  if (type === 'MusicRecording' && data) {
    return {
      ...base,
      '@type': 'MusicRecording',
      name: data.title,
      duration: data.duration_seconds ? `PT${Math.floor(data.duration_seconds / 60)}M${data.duration_seconds % 60}S` : undefined,
      image: data.cover_url,
      ...(data.release_date ? { datePublished: data.release_date } : {}),
    };
  }

  if (type === 'Event' && data) {
    return {
      ...base,
      '@type': 'MusicEvent',
      name: data.title,
      description: data.description,
      location: {
        '@type': 'Place',
        name: data.venue_name || data.city,
        address: data.venue_address || data.city,
      },
      ...(data.start_datetime ? { startDate: data.start_datetime } : {}),
      ...(data.end_datetime ? { endDate: data.end_datetime } : {}),
    };
  }

  if (type === 'Article' && data) {
    return {
      ...base,
      '@type': 'Article',
      headline: data.title,
      description: data.excerpt || data.content?.slice(0, 200),
      ...(data.published_at ? { datePublished: data.published_at } : {}),
      image: data.cover_url,
    };
  }

  if (type === 'Product' && data) {
    return {
      ...base,
      '@type': 'Product',
      name: data.name,
      description: data.description,
      image: data.cover_url,
      offers: {
        '@type': 'Offer',
        price: data.price,
        priceCurrency: data.currency || 'COP',
        availability: data.stock_quantity > 0 ? 'https://schema.org/InStock' : 'https://schema.org/OutOfStock',
      },
    };
  }

  return base;
}

module.exports = {
  getSitemap,
  getRobotsTxt,
  getArtistSeo,
  buildJsonLd,
  escapeXml,
};

const db = require('./src/config/database');
const seoService = require('./src/services/seo.service');

async function main() {
  try {
    const artist = await db.query("SELECT * FROM artists WHERE slug = 'cabaxx'");
    console.log('Artist found:', JSON.stringify(artist, null, 2));
  } catch(e) {
    console.error('Artist query error:', e.message);
  }

  try {
    const sitemap = await seoService.getSitemap('cabaxx');
    console.log('Sitemap generated:', sitemap.substring(0, 100));
  } catch(e) {
    console.error('Sitemap error:', e.message, e.stack);
  }

  try {
    const robots = await seoService.getRobotsTxt('cabaxx');
    console.log('Robots:', robots);
  } catch(e) {
    console.error('Robots error:', e.message);
  }

  process.exit(0);
}
main();

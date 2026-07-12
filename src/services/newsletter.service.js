const newsletterRepository = require('../repositories/newsletter.repository');
const emailService = require('./emailService');
const { ConflictError, NotFoundError } = require('../exceptions');

async function subscribe(artistId, data) {
  const subscriber = await newsletterRepository.subscribe({
    artistId,
    email: data.email,
    name: data.name,
    source: data.source || 'website',
  });
  await emailService.send({
    to: subscriber.email,
    subject: '¡Bienvenido a la newsletter!',
    html: `<p>Hola ${subscriber.name || ''}, gracias por suscribirte.</p>`,
  });
  return subscriber;
}

async function unsubscribe(artistId, email, token) {
  const ok = await newsletterRepository.unsubscribe(artistId, email, token);
  if (!ok) throw new NotFoundError('Subscription not found');
  return true;
}

async function listSubscribers(artistId, filters = {}) {
  return newsletterRepository.findAll(artistId, filters);
}

async function deleteSubscriber(id, artistId) {
  const ok = await newsletterRepository.removeSubscriber(id, artistId);
  if (!ok) throw new NotFoundError('Subscriber not found');
  return true;
}

async function sendCampaign(artistId, campaignId) {
  const [campaignRow] = await dbCampaign(campaignId);
  if (!campaignRow) throw new NotFoundError('Campaign not found');

  let sent = 0;
  let offset = 0;
  const batchSize = 50;
  // eslint-disable-next-line no-constant-condition
  while (true) {
    const batch = await newsletterRepository.getActiveBatch(artistId, batchSize, offset);
    if (!batch.length) break;
    for (const sub of batch) {
      await emailService.send({ to: sub.email, subject: campaignRow.subject, html: campaignRow.content_html });
      sent++;
    }
    offset += batch.length;
  }
  return newsletterRepository.updateCampaignStats(campaignId, { totalSent: sent });
}

async function createCampaign(artistId, data) {
  return newsletterRepository.saveCampaign({
    artist_id: artistId,
    subject: data.subject,
    content_html: data.content_html,
    total_sent: 0,
    total_opened: 0,
    total_clicked: 0,
  });
}

async function listCampaigns(artistId) {
  const rows = await dbCampaigns(artistId);
  return rows;
}

// helpers
const db = require('../config/database');
async function dbCampaign(id) {
  return db.query('SELECT * FROM newsletter_campaigns WHERE id = ?', [id]);
}
async function dbCampaigns(artistId) {
  return db.query('SELECT * FROM newsletter_campaigns WHERE artist_id = ? ORDER BY created_at DESC', [artistId]);
}

module.exports = { subscribe, unsubscribe, listSubscribers, deleteSubscriber, sendCampaign, createCampaign, listCampaigns };

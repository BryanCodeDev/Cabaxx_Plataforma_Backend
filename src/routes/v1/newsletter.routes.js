const express = require('express');
const router = express.Router();

const newsletterController = require('../../controllers/newsletter.controller');
const newsletterValidation = require('../../validations/newsletter.validation');
const newsletterService = require('../../services/newsletter.service');
const artistRepository = require('../../repositories/artists.repository');
const { NotFoundError } = require('../../exceptions');
const authMiddleware = require('../../middlewares/authMiddleware');
const validateMiddleware = require('../../middlewares/validateMiddleware');
const { artistScopeMiddleware, requireArtistAdmin } = require('../../middlewares/artistScopeMiddleware');

// Subscribe público global (footer, homepage)
router.post('/subscribe', newsletterValidation.subscribe, validateMiddleware, async (req, res, next) => {
  try {
    const artist = await artistRepository.findBySlug('cabaxx');
    if (!artist) return next(new NotFoundError('Artist not found'));
    const subscriber = await newsletterService.subscribe(artist.id, req.body);
    return res.status(201).json({ success: true, message: 'Subscrito', data: { subscriber } });
  } catch (err) {
    next(err);
  }
});

// Subscribe público por artista
const artistNewsletter = express.Router();
artistNewsletter.use(artistScopeMiddleware);
artistNewsletter.post('/subscribe', newsletterValidation.subscribe, validateMiddleware, newsletterController.subscribe);
artistNewsletter.get('/subscribers', authMiddleware, requireArtistAdmin, newsletterController.listSubscribers);
artistNewsletter.delete('/subscribers/:id', authMiddleware, requireArtistAdmin, newsletterController.deleteSubscriber);
artistNewsletter.get('/campaigns', authMiddleware, requireArtistAdmin, newsletterController.listCampaigns);
artistNewsletter.post('/campaigns', authMiddleware, requireArtistAdmin, newsletterValidation.createCampaign, validateMiddleware, newsletterController.createCampaign);
artistNewsletter.post('/campaigns/:id/send', authMiddleware, requireArtistAdmin, newsletterController.sendCampaign);

// Unsubscribe público global (token en query)
router.get('/unsubscribe', newsletterValidation.unsubscribe, validateMiddleware, newsletterController.unsubscribe);

module.exports = { artistNewsletter, router };

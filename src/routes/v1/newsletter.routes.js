const express = require('express');
const router = express.Router();

const newsletterController = require('../../controllers/newsletter.controller');
const newsletterValidation = require('../../validations/newsletter.validation');
const authMiddleware = require('../../middlewares/authMiddleware');
const validateMiddleware = require('../../middlewares/validateMiddleware');
const { artistScopeMiddleware, requireArtistAdmin } = require('../../middlewares/artistScopeMiddleware');

// Subscribe público por artista
const artistNewsletter = express.Router();
artistNewsletter.use(artistScopeMiddleware);
artistNewsletter.post('/subscribe', newsletterValidation.subscribe, validateMiddleware, newsletterController.subscribe);
artistNewsletter.get('/subscribers', authMiddleware, requireArtistAdmin, newsletterController.listSubscribers);
artistNewsletter.get('/campaigns', authMiddleware, requireArtistAdmin, newsletterController.listCampaigns);
artistNewsletter.post('/campaigns', authMiddleware, requireArtistAdmin, newsletterValidation.createCampaign, validateMiddleware, newsletterController.createCampaign);
artistNewsletter.post('/campaigns/:id/send', authMiddleware, requireArtistAdmin, newsletterController.sendCampaign);

// Unsubscribe público global (token en query)
router.get('/unsubscribe', newsletterValidation.unsubscribe, validateMiddleware, newsletterController.unsubscribe);

module.exports = { artistNewsletter, router };


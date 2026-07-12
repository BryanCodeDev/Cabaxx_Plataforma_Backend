const express = require('express');
const router = express.Router();

const eventsController = require('../../controllers/events.controller');
const eventsValidation = require('../../validations/events.validation');
const authMiddleware = require('../../middlewares/authMiddleware');
const validateMiddleware = require('../../middlewares/validateMiddleware');
const { artistScopeMiddleware, requireArtistAdmin } = require('../../middlewares/artistScopeMiddleware');

// Rutas de eventos por artista
const artistEvents = express.Router();
artistEvents.use(artistScopeMiddleware);
artistEvents.get('/', eventsValidation.list, validateMiddleware, eventsController.list);
artistEvents.get('/upcoming', eventsController.upcoming);
artistEvents.get('/:slug', eventsValidation.getBySlug, validateMiddleware, eventsController.getBySlug);
artistEvents.post('/', authMiddleware, requireArtistAdmin, eventsValidation.create, validateMiddleware, eventsController.create);
artistEvents.put('/:id', authMiddleware, requireArtistAdmin, eventsValidation.create, validateMiddleware, eventsController.update);
artistEvents.delete('/:id', authMiddleware, requireArtistAdmin, eventsController.remove);

// Tickets
const tickets = express.Router();
tickets.post('/:id/purchase', authMiddleware, eventsValidation.purchase, validateMiddleware, eventsController.purchase);
tickets.get('/verify/:qr_code', eventsValidation.verify, validateMiddleware, eventsController.verify);

module.exports = { artistEvents, tickets };


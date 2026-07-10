const express = require('express');

const orderController = require('../../controllers/order.controller');
const orderValidation = require('../../validations/order.validation');
const authMiddleware = require('../../middlewares/authMiddleware');
const validateMiddleware = require('../../middlewares/validateMiddleware');
const tenantMiddleware = require('../../middlewares/tenantMiddleware');
const { artistScopeMiddleware, requireArtistAdmin } = require('../../middlewares/artistScopeMiddleware');

const router = express.Router();
router.post('/', authMiddleware, tenantMiddleware, orderValidation.checkout, validateMiddleware, orderController.checkout);

const myOrdersRouter = express.Router();
myOrdersRouter.use(authMiddleware);
myOrdersRouter.get('/', orderController.myOrders);

const artistOrders = express.Router();
artistOrders.use(artistScopeMiddleware);
artistOrders.get('/orders', authMiddleware, requireArtistAdmin, orderController.artistOrders);
artistOrders.put('/orders/:id/status', authMiddleware, requireArtistAdmin, orderValidation.updateStatus, validateMiddleware, orderController.updateStatus);

module.exports = { router, myOrdersRouter, artistOrders };


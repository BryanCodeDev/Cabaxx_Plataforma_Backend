const express = require('express');
const router = express.Router();

const storeController = require('../../controllers/store.controller');
const storeValidation = require('../../validations/store.validation');
const authMiddleware = require('../../middlewares/authMiddleware');
const validateMiddleware = require('../../middlewares/validateMiddleware');
const upload = require('../../middlewares/uploadMiddleware');
const { artistScopeMiddleware, requireArtistAdmin } = require('../../middlewares/artistScopeMiddleware');
const checkPlan = require('../../middlewares/checkPlan.middleware');

router.use(artistScopeMiddleware);

router.get('/products', storeValidation.listProducts, validateMiddleware, storeController.listProducts);
router.get('/products/:slug', storeValidation.getProduct, validateMiddleware, storeController.getProduct);
router.get('/product-categories', storeController.listCategories);
router.get('/coupons/validate', storeController.validateCoupon);

router.use(checkPlan('store'));

router.post('/products', authMiddleware, requireArtistAdmin, upload.single('cover'), storeValidation.createProduct, validateMiddleware, storeController.createProduct);
router.put('/products/:id', authMiddleware, requireArtistAdmin, upload.single('cover'), storeValidation.updateProduct, validateMiddleware, storeController.updateProduct);
router.post('/product-categories', authMiddleware, requireArtistAdmin, storeValidation.createCategory, validateMiddleware, storeController.createCategory);

module.exports = router;


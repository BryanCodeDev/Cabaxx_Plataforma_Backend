const express = require('express');
const router = express.Router();

const storeController = require('../../controllers/store.controller');
const storeValidation = require('../../validations/store.validation');
const authMiddleware = require('../../middlewares/authMiddleware');
const validateMiddleware = require('../../middlewares/validateMiddleware');
const upload = require('../../middlewares/uploadMiddleware');
const { artistScopeMiddleware, requireArtistAdmin } = require('../../middlewares/artistScopeMiddleware');
const checkPlan = require('../../middlewares/checkPlanMiddleware');

router.use(artistScopeMiddleware);

router.get('/products', storeValidation.listProducts, validateMiddleware, storeController.listProducts);
router.get('/products/:slug', storeValidation.getProduct, validateMiddleware, storeController.getProduct);
router.get('/product-categories', storeController.listCategories);
router.get('/coupons', authMiddleware, requireArtistAdmin, storeController.listCoupons);
router.get('/coupons/validate', storeController.validateCoupon);

router.use(checkPlan('store'));

router.post('/products', authMiddleware, requireArtistAdmin, upload.single('cover'), storeValidation.createProduct, validateMiddleware, storeController.createProduct);
router.put('/products/:id', authMiddleware, requireArtistAdmin, upload.single('cover'), storeValidation.updateProduct, validateMiddleware, storeController.updateProduct);
router.delete('/products/:id', authMiddleware, requireArtistAdmin, storeController.deleteProduct);
router.post('/product-categories', authMiddleware, requireArtistAdmin, storeValidation.createCategory, validateMiddleware, storeController.createCategory);
router.put('/product-categories/:id', authMiddleware, requireArtistAdmin, storeValidation.createCategory, validateMiddleware, storeController.updateCategory);
router.delete('/product-categories/:id', authMiddleware, requireArtistAdmin, storeController.deleteCategory);
router.post('/coupons', authMiddleware, requireArtistAdmin, storeValidation.createCoupon, validateMiddleware, storeController.createCoupon);
router.put('/coupons/:id', authMiddleware, requireArtistAdmin, storeValidation.updateCoupon, validateMiddleware, storeController.updateCoupon);
router.delete('/coupons/:id', authMiddleware, requireArtistAdmin, storeController.deleteCoupon);

module.exports = router;



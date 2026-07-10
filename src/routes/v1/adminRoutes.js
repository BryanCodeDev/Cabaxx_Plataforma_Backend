const express = require('express');
const router = express.Router();

const adminController = require('../../controllers/adminController');
const authMiddleware = require('../../middlewares/authMiddleware');
const roleMiddleware = require('../../middlewares/roleMiddleware');

router.use(authMiddleware, roleMiddleware('superadmin'));
router.get('/artists', adminController.listArtists);
router.get('/users', adminController.listUsers);
router.get('/subscriptions', adminController.listSubscriptions);

module.exports = router;

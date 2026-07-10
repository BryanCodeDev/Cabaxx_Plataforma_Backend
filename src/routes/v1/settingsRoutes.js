const express = require('express');
const router = express.Router();

const settingsController = require('../../controllers/settingsController');
const authMiddleware = require('../../middlewares/authMiddleware');
const tenantMiddleware = require('../../middlewares/tenantMiddleware');

router.use(authMiddleware, tenantMiddleware);
router.get('/', settingsController.getSettings);
router.put('/', settingsController.updateSettings);

module.exports = router;

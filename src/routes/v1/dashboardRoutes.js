const express = require('express');
const router = express.Router();

const dashboardController = require('../../controllers/dashboardController');
const authMiddleware = require('../../middlewares/authMiddleware');
const tenantMiddleware = require('../../middlewares/tenantMiddleware');
const checkPlan = require('../../middlewares/checkPlan.middleware');

router.use(authMiddleware, tenantMiddleware, checkPlan('analytics'));
router.get('/overview', dashboardController.overview);

module.exports = router;

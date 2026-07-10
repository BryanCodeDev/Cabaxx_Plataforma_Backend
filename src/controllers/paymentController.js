const paymentService = require('../services/paymentService');
const { ok, created, noContent } = require('./controllerHelper');

async function checkout(req, res, next) {
  try {
    const { order_id, amount, currency, provider = 'stripe' } = req.body;
    if (!order_id) return res.status(422).json({ success: false, message: 'order_id es requerido' });
    const result = await paymentService.checkout({ orderId: order_id, amount, currency, provider, artistId: req.artistId });
    return created(res, result);
  } catch (err) {
    next(err);
  }
}

async function webhook(req, res, next) {
  try {
    const result = await paymentService.handleWebhook(req.body);
    return ok(res, result);
  } catch (err) {
    next(err);
  }
}

async function success(req, res, next) {
  try {
    const { order_id } = req.query;
    if (!order_id) return res.status(422).json({ success: false, message: 'order_id requerido' });
    const payment = await paymentService.getPaymentByOrder(order_id);
    return ok(res, { status: 'success', payment });
  } catch (err) {
    next(err);
  }
}

async function failure(req, res, next) {
  try {
    const { order_id } = req.query;
    const payment = order_id ? await paymentService.getPaymentByOrder(order_id) : null;
    return ok(res, { status: 'failure', payment });
  } catch (err) {
    next(err);
  }
}

async function pending(req, res, next) {
  try {
    const { order_id } = req.query;
    const payment = order_id ? await paymentService.getPaymentByOrder(order_id) : null;
    return ok(res, { status: 'pending', payment });
  } catch (err) {
    next(err);
  }
}

async function status(req, res, next) {
  try {
    const { order_id } = req.query;
    const payment = order_id ? await paymentService.getPaymentByOrder(order_id) : null;
    const currentStatus = payment ? payment.status : 'pending';
    return ok(res, { status: currentStatus, payment });
  } catch (err) {
    next(err);
  }
}

module.exports = { checkout, webhook, success, failure, pending, status };

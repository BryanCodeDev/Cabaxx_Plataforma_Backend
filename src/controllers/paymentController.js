const paymentService = require('../services/paymentService');
const { ok, created, badRequest } = require('./controllerHelper');

async function checkout(req, res, next) {
  try {
    const { order_id, provider = 'stripe' } = req.body;
    if (!order_id) return badRequest(res, 'order_id es requerido');
    const result = await paymentService.checkout({
      orderId: order_id,
      provider,
      userId: req.user && req.user.id,
      artistId: req.artistId,
    });
    return created(res, result);
  } catch (err) {
    next(err);
  }
}

async function webhook(req, res, next) {
  try {
    let payload = req.body;
    if (Buffer.isBuffer(req.body)) {
      try {
        payload = JSON.parse(req.body.toString('utf8'));
      } catch (_) {
        payload = {};
      }
    }
    const signature = req.get('x-signature') || req.get('stripe-signature') || req.get('x-mp-signature');
    const result = await paymentService.handleWebhook(payload, signature);
    return ok(res, result);
  } catch (err) {
    next(err);
  }
}

async function success(req, res, next) {
  try {
    const { order_id } = req.query;
    if (!order_id) return badRequest(res, 'order_id requerido');
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

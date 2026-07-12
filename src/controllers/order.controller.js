const orderService = require('../services/order.service');
const { ok, paginated, created } = require('./controllerHelper');

async function checkout(req, res, next) {
  try {
    const order = await orderService.checkout(req.user.id, req.artistId, {
      items: req.body.items,
      couponCode: req.body.coupon_code,
      shippingAddress: req.body.shipping_address,
    });
    return created(res, { order });
  } catch (err) {
    next(err);
  }
}

async function myOrders(req, res, next) {
  try {
    const { rows, total } = await orderService.getMyOrders(req.user.id, req.query);
    return paginated(res, rows, total, req.query.page, req.query.limit);
  } catch (err) {
    next(err);
  }
}

async function artistOrders(req, res, next) {
  try {
    const { rows, total } = await orderService.getArtistOrders(req.artistId, req.query);
    return paginated(res, rows, total, req.query.page, req.query.limit);
  } catch (err) {
    next(err);
  }
}

async function updateStatus(req, res, next) {
  try {
    const order = await orderService.updateOrderStatus(req.params.id, req.body.status, req.artistId);
    return ok(res, { order });
  } catch (err) {
    next(err);
  }
}

async function remove(req, res, next) {
  try {
    await orderService.deleteOrder(req.params.id, req.artistId);
    return noContent(res);
  } catch (err) {
    next(err);
  }
}

module.exports = { checkout, myOrders, artistOrders, updateStatus, remove };

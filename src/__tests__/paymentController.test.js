const { ok, created } = require('../controllers/controllerHelper');

describe('paymentController', () => {
  it('checkout requires order_id', async () => {
    const req = { body: {}, artistId: 1 };
    let statusCode = undefined;
    let payload = undefined;
    const res = {
      status: (code) => { statusCode = code; return res; },
      json: (data) => { payload = data; return res; },
    };
    const next = (err) => { res.error = err; };

    const { checkout } = require('../controllers/paymentController');
    await checkout(req, res, next);

    expect(statusCode).toBe(422);
    expect(payload.success).toBe(false);
    expect(payload.message).toBe('order_id es requerido');
  });
});

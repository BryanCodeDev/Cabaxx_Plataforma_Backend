const db = require('../config/database');
const orderRepository = require('../repositories/order.repository');
const storeRepository = require('../repositories/store.repository');
const emailService = require('../services/emailService');
const { NotFoundError, ValidationError } = require('../exceptions');

async function checkout(userId, artistId, { items = [], couponCode, shippingAddress } = {}) {
  if (!items.length) throw new ValidationError('El carrito está vacío');

  // Transacción atómica: validar stock, crear orden y descontar stock
  return db.transaction(async (conn) => {
    let subtotal = 0;
    const resolvedItems = [];

    for (const item of items) {
      const product = await storeRepository.findById(item.productId, artistId);
      if (!product) throw new NotFoundError(`Producto ${item.productId} no encontrado`);
      if (product.stock_quantity < item.quantity) {
        throw new ValidationError(`Solo quedan ${product.stock_quantity} unidades de ${product.name}`, [
          { field: 'stock', message: `Solo quedan ${product.stock_quantity} unidades de ${product.name}` },
        ]);
      }
      const unitPrice = Number(product.price);
      const totalPrice = unitPrice * item.quantity;
      subtotal += totalPrice;
      resolvedItems.push({
        productId: product.id,
        variantId: item.variantId || null,
        quantity: item.quantity,
        unitPrice,
        totalPrice,
        snapshot: { name: product.name, sku: product.sku, cover_url: product.cover_url },
      });
    }

    let discount = 0;
    let couponId = null;
    if (couponCode) {
      const coupon = await storeRepository.findCouponByCode(artistId, couponCode);
      if (!coupon) throw new NotFoundError('Cupón no válido');
      if (coupon.status !== 'active') throw new ValidationError('Cupón inactivo');
      if (coupon.expires_at && new Date(coupon.expires_at) < new Date()) throw new ValidationError('Cupón expirado');
      if (coupon.min_purchase && subtotal < coupon.min_purchase) throw new ValidationError('Subtotal insuficiente para el cupón');
      discount = coupon.type === 'percent' ? Number((subtotal * (coupon.value / 100)).toFixed(2)) : Number(coupon.value);
      couponId = coupon.id;
    }

    const shipping = 0;
    const tax = 0;
    const total = Number((subtotal - discount + shipping + tax).toFixed(2));

    const orderId = await orderRepository.createOrder(conn, {
      userId,
      artistId,
      subtotal: Number(subtotal.toFixed(2)),
      discount,
      shipping,
      tax,
      total,
      currency: resolvedItems[0]?.snapshot ? 'USD' : 'USD',
      couponId,
      notes: null,
      shippingAddress,
      items: resolvedItems,
    });

    // Descontar stock (si falla, la transacción hace rollback)
    for (const item of resolvedItems) {
      await storeRepository.updateStockConn(conn, item.productId, item.quantity, 'subtract');
    }
    if (couponId) await storeRepository.incrementCouponUses(conn, couponId);

    const order = await orderRepository.findById(orderId);
    await emailService.send({
      to: shippingAddress?.email || 'fan@example.com',
      subject: 'Confirmación de pedido',
      html: `<p>Tu pedido #${order.id} por ${total} ha sido recibido.</p>`,
    });
    return order;
  });
}

async function getMyOrders(userId, filters = {}) {
  return orderRepository.findOrdersByUser(userId, filters);
}

async function getArtistOrders(artistId, filters = {}) {
  return orderRepository.findOrdersByArtist(artistId, filters);
}

async function updateOrderStatus(id, status, artistId = null) {
  const order = await orderRepository.updateStatus(id, status, artistId);
  if (!order) throw new NotFoundError('Order not found');
  return order;
}

async function deleteOrder(id, artistId = null) {
  const ok = await orderRepository.softDelete(id, artistId);
  if (!ok) throw new NotFoundError('Order not found');
  return true;
}

module.exports = { checkout, getMyOrders, getArtistOrders, updateOrderStatus, deleteOrder };

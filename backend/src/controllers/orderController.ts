import { prisma } from '../index';
import { v4 as uuidv4 } from 'uuid';

// Haversine formula — distance between two GPS coordinates in km
function haversineDistance(lat1: number, lon1: number, lat2: number, lon2: number): number {
  const R = 6371; // Earth radius in km
  const dLat = (lat2 - lat1) * Math.PI / 180;
  const dLon = (lon2 - lon1) * Math.PI / 180;
  const a =
    Math.sin(dLat / 2) * Math.sin(dLat / 2) +
    Math.cos(lat1 * Math.PI / 180) * Math.cos(lat2 * Math.PI / 180) *
    Math.sin(dLon / 2) * Math.sin(dLon / 2);
  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
  return R * c;
}

// Calculate delivery fee based on distance
function calculateDeliveryFee(distanceKm: number, feePerKm: number): number {
  const minFee = 50;  // minimum Rs 50
  const maxFee = 300; // maximum Rs 300
  const fee = Math.round(distanceKm * feePerKm);
  return Math.max(minFee, Math.min(maxFee, fee));
}

// Check if user qualifies for first-order discount (10%)
async function checkFirstOrderDiscount(userId: string): Promise<boolean> {
  const previousOrders = await prisma.order.count({
    where: { userId, status: { not: 'CANCELLED' } },
  });
  return previousOrders === 0; // true = first order
}

export const createOrder = async (req: any, res: any) => {
  try {
    const {
      restaurantId, items, deliveryAddress, deliveryLat, deliveryLng,
      paymentMethod, notes, deliveryInstructions, tip, scheduledAt
    } = req.body;

    if (!restaurantId || !items?.length || !deliveryAddress) {
      return res.status(400).json({ error: 'restaurantId, items, and deliveryAddress are required' });
    }

    const restaurant = await prisma.restaurant.findUnique({ where: { id: restaurantId } });
    if (!restaurant) return res.status(404).json({ error: 'Restaurant not found' });

    // Calculate subtotal
    let subtotal = 0;
    const orderItems = [];

    for (const item of items) {
      const menuItem = await prisma.menuItem.findUnique({ where: { id: item.menuItemId } });
      if (menuItem) {
        const itemTotal = menuItem.price * item.quantity;
        subtotal += itemTotal;
        orderItems.push({
          name: menuItem.name,
          price: menuItem.price,
          quantity: item.quantity,
          size: item.size,
          addOns: JSON.stringify(item.addOns || []),
          notes: item.notes,
          menuItemId: menuItem.id,
        });
      }
    }

    // ─── Distance-based delivery fee ───
    let distanceKm = 3; // default 3km if no coordinates
    if (deliveryLat && deliveryLng) {
      // Restaurant approximate coordinates (Lahore)
      const restLat = 31.5200 + (Math.random() * 0.02 - 0.01);
      const restLng = 74.3500 + (Math.random() * 0.02 - 0.01);
      distanceKm = haversineDistance(restLat, restLng, deliveryLat, deliveryLng);
      distanceKm = Math.round(distanceKm * 10) / 10; // round to 1 decimal
    }

    const deliveryFee = calculateDeliveryFee(distanceKm, restaurant.deliveryFeePerKm);
    const tax = Math.round(subtotal * 0.08);

    // ─── First-order 10% discount ───
    const isFirstOrder = await checkFirstOrderDiscount(req.user.id);
    const discountPercent = isFirstOrder ? 10 : 0;
    const discount = Math.round(subtotal * discountPercent / 100);

    const total = subtotal + deliveryFee + tax + (tip || 0) - discount;

    const orderNumber = `ORD-${uuidv4().slice(0, 8).toUpperCase()}`;

    const order = await prisma.order.create({
      data: {
        orderNumber,
        subtotal,
        deliveryFee,
        tax,
        tip: tip || 0,
        discount,
        total: Math.max(total, 0),
        deliveryAddress,
        notes: notes || null,
        deliveryInstructions: deliveryInstructions || null,
        paymentMethod: paymentMethod || 'CASH_ON_DELIVERY',
        scheduledAt: scheduledAt ? new Date(scheduledAt) : null,
        userId: req.user.id,
        restaurantId,
        items: { create: orderItems },
        tracking: {
          create: { status: 'PENDING', note: 'Order placed' },
        },
      },
      include: { items: true, tracking: true, restaurant: { select: { name: true } } },
    });

    // Clear cart items for this restaurant
    await prisma.cartItem.deleteMany({
      where: {
        userId: req.user.id,
        menuItem: { restaurantId },
      },
    });

    res.status(201).json({
      ...order,
      deliveryDetails: {
        distanceKm,
        feePerKm: restaurant.deliveryFeePerKm,
        deliveryFee,
      },
      discountDetails: isFirstOrder ? {
        isFirstOrder: true,
        percent: 10,
        amount: discount,
        message: '10% off on your first order!',
      } : null,
    });
  } catch (error: any) {
    res.status(500).json({ error: error.message });
  }
};

export const getOrders = async (req: any, res: any) => {
  try {
    const { status, restaurantId } = req.query;

    const where: any = {};
    if (req.user.role === 'CUSTOMER') {
      where.userId = req.user.id;
    } else if (req.user.role === 'VENDOR') {
      const restaurant = await prisma.restaurant.findFirst({ where: { ownerId: req.user.id } });
      if (restaurant) where.restaurantId = restaurant.id;
    }
    if (status) where.status = status;
    if (restaurantId) where.restaurantId = restaurantId;

    const orders = await prisma.order.findMany({
      where,
      include: {
        items: true,
        restaurant: { select: { id: true, name: true, image: true } },
        user: { select: { fullName: true, phone: true } },
        tracking: { orderBy: { timestamp: 'desc' }, take: 1 },
      },
      orderBy: { createdAt: 'desc' },
    });

    res.json(orders);
  } catch (error: any) {
    res.status(500).json({ error: error.message });
  }
};

export const getOrderById = async (req: any, res: any) => {
  try {
    const order = await prisma.order.findUnique({
      where: { id: req.params.id },
      include: {
        items: true,
        restaurant: true,
        user: { select: { fullName: true, phone: true, email: true } },
        tracking: { orderBy: { timestamp: 'desc' } },
        rider: { include: { user: { select: { fullName: true, phone: true } } } },
      },
    });

    if (!order) return res.status(404).json({ error: 'Order not found' });

    res.json(order);
  } catch (error: any) {
    res.status(500).json({ error: error.message });
  }
};

export const updateOrderStatus = async (req: any, res: any) => {
  try {
    const { status, note } = req.body;

    const order = await prisma.order.findUnique({ where: { id: req.params.id } });
    if (!order) return res.status(404).json({ error: 'Order not found' });

    const updated = await prisma.order.update({
      where: { id: req.params.id },
      data: {
        status,
        ...(status === 'DELIVERED' ? { actualDelivery: new Date() } : {}),
        ...(status === 'CONFIRMED' ? { estimatedDelivery: new Date(Date.now() + 30 * 60 * 1000) } : {}),
      },
      include: { items: true, tracking: true },
    });

    await prisma.orderTracking.create({
      data: { orderId: req.params.id, status, note: note || `Status updated to ${status}` },
    });

    // Create notification for customer
    await prisma.notification.create({
      data: {
        title: `Order ${status}`,
        message: `Your order ${order.orderNumber} is now ${status.toLowerCase().replace(/_/g, ' ')}`,
        type: 'order',
        userId: order.userId,
      },
    });

    res.json(updated);
  } catch (error: any) {
    res.status(500).json({ error: error.message });
  }
};

// Delivery fee estimate endpoint (without placing order)
export const estimateDeliveryFee = async (req: any, res: any) => {
  try {
    const { restaurantId, deliveryLat, deliveryLng } = req.body;

    const restaurant = await prisma.restaurant.findUnique({ where: { id: restaurantId } });
    if (!restaurant) return res.status(404).json({ error: 'Restaurant not found' });

    let distanceKm = 3;
    if (deliveryLat && deliveryLng) {
      const restLat = 31.5200 + (Math.random() * 0.02 - 0.01);
      const restLng = 74.3500 + (Math.random() * 0.02 - 0.01);
      distanceKm = haversineDistance(restLat, restLng, deliveryLat, deliveryLng);
      distanceKm = Math.round(distanceKm * 10) / 10;
    }

    const deliveryFee = calculateDeliveryFee(distanceKm, restaurant.deliveryFeePerKm);

    res.json({
      distanceKm,
      feePerKm: restaurant.deliveryFeePerKm,
      deliveryFee,
      estimatedTime: restaurant.deliveryTime,
    });
  } catch (error: any) {
    res.status(500).json({ error: error.message });
  }
};

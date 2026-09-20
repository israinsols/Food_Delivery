import { prisma } from '../index';

export const getCart = async (req: any, res: any) => {
  try {
    const items = await prisma.cartItem.findMany({
      where: { userId: req.user.id },
      include: {
        menuItem: {
          include: { restaurant: { select: { id: true, name: true, deliveryFee: true, deliveryTime: true } } },
        },
      },
      orderBy: { createdAt: 'desc' },
    });

    res.json(items);
  } catch (error: any) {
    res.status(500).json({ error: error.message });
  }
};

export const addToCart = async (req: any, res: any) => {
  try {
    const { menuItemId, quantity, size, spiceLevel, addOns, notes } = req.body;

    if (!menuItemId) return res.status(400).json({ error: 'menuItemId is required' });

    const menuItem = await prisma.menuItem.findUnique({ where: { id: menuItemId } });
    if (!menuItem) return res.status(404).json({ error: 'Menu item not found' });

    const existing = await prisma.cartItem.findFirst({
      where: { userId: req.user.id, menuItemId },
    });

    if (existing) {
      const updated = await prisma.cartItem.update({
        where: { id: existing.id },
        data: { quantity: existing.quantity + (quantity || 1) },
        include: { menuItem: true },
      });
      return res.json(updated);
    }

    const item = await prisma.cartItem.create({
      data: {
        quantity: quantity || 1,
        size: size || null,
        spiceLevel: spiceLevel || null,
        addOns: addOns || [],
        notes: notes || null,
        userId: req.user.id,
        menuItemId,
      },
      include: { menuItem: true },
    });

    res.status(201).json(item);
  } catch (error: any) {
    res.status(500).json({ error: error.message });
  }
};

export const updateCartItem = async (req: any, res: any) => {
  try {
    const { quantity } = req.body;

    if (quantity <= 0) {
      await prisma.cartItem.delete({ where: { id: req.params.id } });
      return res.json({ message: 'Item removed from cart' });
    }

    const item = await prisma.cartItem.update({
      where: { id: req.params.id },
      data: { quantity },
      include: { menuItem: true },
    });

    res.json(item);
  } catch (error: any) {
    res.status(500).json({ error: error.message });
  }
};

export const removeFromCart = async (req: any, res: any) => {
  try {
    await prisma.cartItem.delete({ where: { id: req.params.id } });
    res.json({ message: 'Item removed from cart' });
  } catch (error: any) {
    res.status(500).json({ error: error.message });
  }
};

export const clearCart = async (req: any, res: any) => {
  try {
    await prisma.cartItem.deleteMany({ where: { userId: req.user.id } });
    res.json({ message: 'Cart cleared' });
  } catch (error: any) {
    res.status(500).json({ error: error.message });
  }
};

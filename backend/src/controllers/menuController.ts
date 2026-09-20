import { prisma } from '../index';

export const getMenuItems = async (req: any, res: any) => {
  try {
    const { restaurantId, category, search } = req.query;

    const where: any = { isAvailable: true };
    if (restaurantId) where.restaurantId = restaurantId;
    if (category) where.category = category;
    if (search) {
      where.OR = [
        { name: { contains: search as string, mode: 'insensitive' } },
        { category: { contains: search as string, mode: 'insensitive' } },
      ];
    }

    const items = await prisma.menuItem.findMany({
      where,
      include: { restaurant: { select: { id: true, name: true, slug: true, image: true } } },
      orderBy: { orders: 'desc' },
    });

    res.json(items);
  } catch (error: any) {
    res.status(500).json({ error: error.message });
  }
};

export const getMenuItemById = async (req: any, res: any) => {
  try {
    const item = await prisma.menuItem.findUnique({
      where: { id: req.params.id },
      include: { restaurant: true },
    });

    if (!item) return res.status(404).json({ error: 'Menu item not found' });

    res.json(item);
  } catch (error: any) {
    res.status(500).json({ error: error.message });
  }
};

export const getMenuItemByName = async (req: any, res: any) => {
  try {
    const name = decodeURIComponent(req.params.name);
    const items = await prisma.menuItem.findMany({
      where: { name, isAvailable: true },
      include: { restaurant: { select: { id: true, name: true, slug: true, image: true, deliveryTime: true, rating: true, deliveryFee: true } } },
    });

    res.json(items);
  } catch (error: any) {
    res.status(500).json({ error: error.message });
  }
};

export const createMenuItem = async (req: any, res: any) => {
  try {
    const { restaurantId, name, description, price, image, category, isBestseller, isVegetarian } = req.body;

    if (!restaurantId || !name || !price || !category) {
      return res.status(400).json({ error: 'restaurantId, name, price, and category are required' });
    }

    const restaurant = await prisma.restaurant.findUnique({ where: { id: restaurantId } });
    if (!restaurant) return res.status(404).json({ error: 'Restaurant not found' });

    if (restaurant.ownerId !== req.user.id && req.user.role !== 'ADMIN') {
      return res.status(403).json({ error: 'Not authorized' });
    }

    const item = await prisma.menuItem.create({
      data: {
        name,
        description: description || null,
        price,
        image: image || 'assets/images/biryani.jpg',
        category,
        isBestseller: isBestseller || false,
        isVegetarian: isVegetarian || false,
        restaurantId,
      },
    });

    res.status(201).json(item);
  } catch (error: any) {
    res.status(500).json({ error: error.message });
  }
};

export const updateMenuItem = async (req: any, res: any) => {
  try {
    const item = await prisma.menuItem.findUnique({
      where: { id: req.params.id },
      include: { restaurant: true },
    });

    if (!item) return res.status(404).json({ error: 'Menu item not found' });

    if (item.restaurant.ownerId !== req.user.id && req.user.role !== 'ADMIN') {
      return res.status(403).json({ error: 'Not authorized' });
    }

    const updated = await prisma.menuItem.update({
      where: { id: req.params.id },
      data: req.body,
    });

    res.json(updated);
  } catch (error: any) {
    res.status(500).json({ error: error.message });
  }
};

export const deleteMenuItem = async (req: any, res: any) => {
  try {
    const item = await prisma.menuItem.findUnique({
      where: { id: req.params.id },
      include: { restaurant: true },
    });

    if (!item) return res.status(404).json({ error: 'Menu item not found' });

    if (item.restaurant.ownerId !== req.user.id && req.user.role !== 'ADMIN') {
      return res.status(403).json({ error: 'Not authorized' });
    }

    await prisma.menuItem.delete({ where: { id: req.params.id } });
    res.json({ message: 'Menu item deleted' });
  } catch (error: any) {
    res.status(500).json({ error: error.message });
  }
};

export const toggleAvailability = async (req: any, res: any) => {
  try {
    const item = await prisma.menuItem.findUnique({ where: { id: req.params.id } });
    if (!item) return res.status(404).json({ error: 'Menu item not found' });

    const updated = await prisma.menuItem.update({
      where: { id: req.params.id },
      data: { isAvailable: !item.isAvailable },
    });

    res.json(updated);
  } catch (error: any) {
    res.status(500).json({ error: error.message });
  }
};

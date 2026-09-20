import { prisma } from '../index';

export const getAllRestaurants = async (req: any, res: any) => {
  try {
    const { cuisine, search, isOpen, isFeatured } = req.query;

    const where: any = {};
    if (cuisine) where.cuisine = cuisine;
    if (isOpen !== undefined) where.isOpen = isOpen === 'true';
    if (isFeatured !== undefined) where.isFeatured = isFeatured === 'true';
    if (search) {
      where.OR = [
        { name: { contains: search as string, mode: 'insensitive' } },
        { cuisine: { contains: search as string, mode: 'insensitive' } },
      ];
    }

    const restaurants = await prisma.restaurant.findMany({
      where,
      include: {
        _count: { select: { menuItems: true, orders: true } },
      },
      orderBy: { rating: 'desc' },
    });

    res.json(restaurants);
  } catch (error: any) {
    res.status(500).json({ error: error.message });
  }
};

export const getRestaurantById = async (req: any, res: any) => {
  try {
    const restaurant = await prisma.restaurant.findUnique({
      where: { id: req.params.id },
      include: {
        menuItems: { where: { isAvailable: true }, orderBy: { orders: 'desc' } },
        _count: { select: { orders: true, menuItems: true } },
      },
    });

    if (!restaurant) return res.status(404).json({ error: 'Restaurant not found' });

    res.json(restaurant);
  } catch (error: any) {
    res.status(500).json({ error: error.message });
  }
};

export const createRestaurant = async (req: any, res: any) => {
  try {
    const { name, cuisine, description, image, deliveryTime, deliveryFee } = req.body;

    const slug = name.toLowerCase().replace(/[^a-z0-9]+/g, '-').replace(/(^-|-$)/g, '');

    const restaurant = await prisma.restaurant.create({
      data: {
        name,
        slug,
        cuisine,
        description: description || null,
        image: image || 'assets/images/biryani.jpg',
        deliveryTime: deliveryTime || '25-35 min',
        deliveryFee: deliveryFee || 'Rs 100',
        ownerId: req.user.id,
      },
    });

    res.status(201).json(restaurant);
  } catch (error: any) {
    res.status(500).json({ error: error.message });
  }
};

export const updateRestaurant = async (req: any, res: any) => {
  try {
    const restaurant = await prisma.restaurant.findUnique({ where: { id: req.params.id } });
    if (!restaurant) return res.status(404).json({ error: 'Restaurant not found' });

    if (restaurant.ownerId !== req.user.id && req.user.role !== 'ADMIN') {
      return res.status(403).json({ error: 'Not authorized' });
    }

    const updated = await prisma.restaurant.update({
      where: { id: req.params.id },
      data: req.body,
    });

    res.json(updated);
  } catch (error: any) {
    res.status(500).json({ error: error.message });
  }
};

export const deleteRestaurant = async (req: any, res: any) => {
  try {
    const restaurant = await prisma.restaurant.findUnique({ where: { id: req.params.id } });
    if (!restaurant) return res.status(404).json({ error: 'Restaurant not found' });

    if (restaurant.ownerId !== req.user.id && req.user.role !== 'ADMIN') {
      return res.status(403).json({ error: 'Not authorized' });
    }

    await prisma.restaurant.delete({ where: { id: req.params.id } });
    res.json({ message: 'Restaurant deleted' });
  } catch (error: any) {
    res.status(500).json({ error: error.message });
  }
};

export const toggleRestaurantOpen = async (req: any, res: any) => {
  try {
    const restaurant = await prisma.restaurant.findUnique({ where: { id: req.params.id } });
    if (!restaurant) return res.status(404).json({ error: 'Restaurant not found' });

    const updated = await prisma.restaurant.update({
      where: { id: req.params.id },
      data: { isOpen: !restaurant.isOpen },
    });

    res.json(updated);
  } catch (error: any) {
    res.status(500).json({ error: error.message });
  }
};

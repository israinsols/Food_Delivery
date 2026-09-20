import { prisma } from '../index';

export const getDashboardStats = async (req: any, res: any) => {
  try {
    const [
      totalUsers,
      totalRestaurants,
      totalOrders,
      totalRevenue,
      pendingOrders,
      todayOrders,
    ] = await Promise.all([
      prisma.user.count(),
      prisma.restaurant.count(),
      prisma.order.count(),
      prisma.order.aggregate({ _sum: { total: true }, where: { status: 'DELIVERED' } }),
      prisma.order.count({ where: { status: 'PENDING' } }),
      prisma.order.count({
        where: { createdAt: { gte: new Date(new Date().setHours(0, 0, 0, 0)) } },
      }),
    ]);

    const recentOrders = await prisma.order.findMany({
      take: 10,
      include: {
        restaurant: { select: { name: true } },
        user: { select: { fullName: true } },
      },
      orderBy: { createdAt: 'desc' },
    });

    const topRestaurants = await prisma.restaurant.findMany({
      take: 5,
      include: { _count: { select: { orders: true } } },
      orderBy: { rating: 'desc' },
    });

    res.json({
      totalUsers,
      totalRestaurants,
      totalOrders,
      totalRevenue: totalRevenue._sum.total || 0,
      commission: Math.round((totalRevenue._sum.total || 0) * 0.15),
      pendingOrders,
      todayOrders,
      recentOrders,
      topRestaurants,
    });
  } catch (error: any) {
    res.status(500).json({ error: error.message });
  }
};

export const getAllUsers = async (req: any, res: any) => {
  try {
    const users = await prisma.user.findMany({
      select: { id: true, email: true, fullName: true, phone: true, role: true, isActive: true, createdAt: true },
      orderBy: { createdAt: 'desc' },
    });
    res.json(users);
  } catch (error: any) {
    res.status(500).json({ error: error.message });
  }
};

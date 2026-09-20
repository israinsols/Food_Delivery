import { prisma } from '../index';

export const getVendorDashboard = async (req: any, res: any) => {
  try {
    const restaurant = await prisma.restaurant.findFirst({ where: { ownerId: req.user.id } });
    if (!restaurant) return res.status(404).json({ error: 'No restaurant found' });

    const [totalOrders, revenue, pendingOrders, avgOrder] = await Promise.all([
      prisma.order.count({ where: { restaurantId: restaurant.id } }),
      prisma.order.aggregate({ _sum: { total: true }, where: { restaurantId: restaurant.id, status: 'DELIVERED' } }),
      prisma.order.count({ where: { restaurantId: restaurant.id, status: 'PENDING' } }),
      prisma.order.aggregate({ _avg: { total: true }, where: { restaurantId: restaurant.id, status: 'DELIVERED' } }),
    ]);

    const topItems = await prisma.orderItem.groupBy({
      by: ['name'],
      where: { order: { restaurantId: restaurant.id } },
      _count: { name: true },
      orderBy: { _count: { name: 'desc' } },
      take: 5,
    });

    res.json({
      restaurant: { id: restaurant.id, name: restaurant.name },
      stats: {
        totalRevenue: revenue._sum.total || 0,
        totalOrders,
        avgOrderValue: Math.round(avgOrder._avg.total || 0),
        pendingOrders,
      },
      topItems: topItems.map(i => ({ name: i.name, count: i._count.name })),
    });
  } catch (error: any) {
    res.status(500).json({ error: error.message });
  }
};

import { prisma } from '../index';

export const getNotifications = async (req: any, res: any) => {
  try {
    const notifications = await prisma.notification.findMany({
      where: { userId: req.user.id },
      orderBy: { createdAt: 'desc' },
      take: 50,
    });
    res.json(notifications);
  } catch (error: any) {
    res.status(500).json({ error: error.message });
  }
};

export const markAsRead = async (req: any, res: any) => {
  try {
    await prisma.notification.update({
      where: { id: req.params.id },
      data: { isRead: true },
    });
    res.json({ message: 'Marked as read' });
  } catch (error: any) {
    res.status(500).json({ error: error.message });
  }
};

export const markAllAsRead = async (req: any, res: any) => {
  try {
    await prisma.notification.updateMany({
      where: { userId: req.user.id, isRead: false },
      data: { isRead: true },
    });
    res.json({ message: 'All marked as read' });
  } catch (error: any) {
    res.status(500).json({ error: error.message });
  }
};

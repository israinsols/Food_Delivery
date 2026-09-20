import { prisma } from '../index';

export const getRiders = async (req: any, res: any) => {
  try {
    const riders = await prisma.riderProfile.findMany({
      include: { user: { select: { id: true, fullName: true, email: true, phone: true } } },
    });
    res.json(riders);
  } catch (error: any) {
    res.status(500).json({ error: error.message });
  }
};

export const createRiderProfile = async (req: any, res: any) => {
  try {
    const { vehicleType, vehicleNumber } = req.body;

    const existing = await prisma.riderProfile.findUnique({ where: { userId: req.user.id } });
    if (existing) return res.status(409).json({ error: 'Rider profile already exists' });

    const profile = await prisma.riderProfile.create({
      data: {
        vehicleType: vehicleType || 'Bike',
        vehicleNumber: vehicleNumber || null,
        userId: req.user.id,
      },
      include: { user: { select: { fullName: true, phone: true } } },
    });

    res.status(201).json(profile);
  } catch (error: any) {
    res.status(500).json({ error: error.message });
  }
};

export const updateRiderLocation = async (req: any, res: any) => {
  try {
    const { latitude, longitude } = req.body;

    const updated = await prisma.riderProfile.update({
      where: { userId: req.user.id },
      data: { currentLat: latitude, currentLng: longitude },
    });

    res.json(updated);
  } catch (error: any) {
    res.status(500).json({ error: error.message });
  }
};

export const toggleRiderAvailability = async (req: any, res: any) => {
  try {
    const profile = await prisma.riderProfile.findUnique({ where: { userId: req.user.id } });
    if (!profile) return res.status(404).json({ error: 'Rider profile not found' });

    const updated = await prisma.riderProfile.update({
      where: { userId: req.user.id },
      data: { isAvailable: !profile.isAvailable },
    });

    res.json(updated);
  } catch (error: any) {
    res.status(500).json({ error: error.message });
  }
};

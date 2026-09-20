import { prisma } from '../index';

export const getAddresses = async (req: any, res: any) => {
  try {
    const addresses = await prisma.address.findMany({
      where: { userId: req.user.id },
      orderBy: { isDefault: 'desc' },
    });
    res.json(addresses);
  } catch (error: any) {
    res.status(500).json({ error: error.message });
  }
};

export const createAddress = async (req: any, res: any) => {
  try {
    const { label, address, latitude, longitude, isDefault } = req.body;

    if (isDefault) {
      await prisma.address.updateMany({ where: { userId: req.user.id }, data: { isDefault: false } });
    }

    const newAddress = await prisma.address.create({
      data: {
        label,
        address,
        latitude: latitude || null,
        longitude: longitude || null,
        isDefault: isDefault || false,
        userId: req.user.id,
      },
    });

    res.status(201).json(newAddress);
  } catch (error: any) {
    res.status(500).json({ error: error.message });
  }
};

export const deleteAddress = async (req: any, res: any) => {
  try {
    await prisma.address.delete({ where: { id: req.params.id } });
    res.json({ message: 'Address deleted' });
  } catch (error: any) {
    res.status(500).json({ error: error.message });
  }
};

import { prisma } from '../index';

export const getPromoCodes = async (req: any, res: any) => {
  try {
    const promos = await prisma.promoCode.findMany({
      where: { isActive: true },
      orderBy: { createdAt: 'desc' },
    });
    res.json(promos);
  } catch (error: any) {
    res.status(500).json({ error: error.message });
  }
};

export const validatePromoCode = async (req: any, res: any) => {
  try {
    const { code, orderTotal } = req.body;

    const promo = await prisma.promoCode.findUnique({ where: { code: code.toUpperCase() } });
    if (!promo || !promo.isActive) {
      return res.status(404).json({ error: 'Invalid promo code' });
    }

    if (promo.expiresAt && new Date(promo.expiresAt) < new Date()) {
      return res.status(400).json({ error: 'Promo code expired' });
    }

    if (promo.maxUses && promo.usedCount >= promo.maxUses) {
      return res.status(400).json({ error: 'Promo code usage limit reached' });
    }

    if (orderTotal && promo.minOrder > 0 && orderTotal < promo.minOrder) {
      return res.status(400).json({ error: `Minimum order of Rs ${promo.minOrder} required` });
    }

    let discount = 0;
    if (promo.discountType === 'percentage') {
      discount = Math.round((orderTotal || 0) * promo.discountValue / 100);
    } else if (promo.discountType === 'fixed') {
      discount = promo.discountValue;
    } else if (promo.discountType === 'free_delivery') {
      discount = 100; // delivery fee
    }

    res.json({ promo, discount });
  } catch (error: any) {
    res.status(500).json({ error: error.message });
  }
};

export const createPromoCode = async (req: any, res: any) => {
  try {
    const { code, description, discountType, discountValue, minOrder, maxUses, restaurantId, expiresAt } = req.body;

    const promo = await prisma.promoCode.create({
      data: {
        code: code.toUpperCase(),
        description,
        discountType,
        discountValue,
        minOrder: minOrder || 0,
        maxUses: maxUses || null,
        restaurantId: restaurantId || null,
        expiresAt: expiresAt ? new Date(expiresAt) : null,
      },
    });

    res.status(201).json(promo);
  } catch (error: any) {
    res.status(500).json({ error: error.message });
  }
};

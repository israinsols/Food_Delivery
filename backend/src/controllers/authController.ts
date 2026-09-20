import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';
import { prisma } from '../index';

const JWT_SECRET = process.env.JWT_SECRET || 'fallback-secret';
const JWT_EXPIRES_IN = process.env.JWT_EXPIRES_IN || '7d';

function generateToken(user: { id: string; email: string; role: string }) {
  return jwt.sign(user, JWT_SECRET, { expiresIn: JWT_EXPIRES_IN } as any);
}

export const register = async (req: any, res: any) => {
  try {
    const { email, password, fullName, phone, role, accountType } = req.body;

    if (!email || !password || !fullName) {
      return res.status(400).json({ error: 'Email, password, and fullName are required' });
    }

    if (password.length < 6) {
      return res.status(400).json({ error: 'Password must be at least 6 characters' });
    }

    const existing = await prisma.user.findUnique({ where: { email } });
    if (existing) {
      return res.status(409).json({ error: 'Email already registered' });
    }

    const hashedPassword = await bcrypt.hash(password, 10);

    const resolvedAccountType = accountType || 'customer';
    let resolvedRole = 'CUSTOMER';
    if (resolvedAccountType === 'vendor') resolvedRole = 'VENDOR';
    else if (resolvedAccountType === 'super_admin') resolvedRole = 'ADMIN';

    const user = await prisma.user.create({
      data: {
        email,
        password: hashedPassword,
        fullName,
        phone: phone || null,
        role: role || resolvedRole,
        accountType: resolvedAccountType,
      },
    });

    const token = generateToken({ id: user.id, email: user.email, role: user.role });

    res.status(201).json({
      token,
      user: {
        id: user.id,
        email: user.email,
        fullName: user.fullName,
        phone: user.phone,
        role: user.role,
        accountType: user.accountType,
      },
    });
  } catch (error: any) {
    res.status(500).json({ error: error.message });
  }
};

export const login = async (req: any, res: any) => {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      return res.status(400).json({ error: 'Email and password are required' });
    }

    const user = await prisma.user.findUnique({ where: { email } });
    if (!user) {
      return res.status(401).json({ error: 'Invalid credentials' });
    }

    const valid = await bcrypt.compare(password, user.password);
    if (!valid) {
      return res.status(401).json({ error: 'Invalid credentials' });
    }

    const token = generateToken({ id: user.id, email: user.email, role: user.role });

    res.json({
      token,
      user: {
        id: user.id,
        email: user.email,
        fullName: user.fullName,
        phone: user.phone,
        role: user.role,
        accountType: user.accountType,
      },
    });
  } catch (error: any) {
    res.status(500).json({ error: error.message });
  }
};

export const getProfile = async (req: any, res: any) => {
  try {
    const user = await prisma.user.findUnique({
      where: { id: req.user.id },
      select: {
        id: true,
        email: true,
        fullName: true,
        phone: true,
        role: true,
        accountType: true,
        avatar: true,
        createdAt: true,
        restaurant: { select: { id: true, name: true, slug: true } },
      },
    });

    if (!user) return res.status(404).json({ error: 'User not found' });

    res.json(user);
  } catch (error: any) {
    res.status(500).json({ error: error.message });
  }
};

export const updateProfile = async (req: any, res: any) => {
  try {
    const { fullName, phone, avatar } = req.body;

    const user = await prisma.user.update({
      where: { id: req.user.id },
      data: { ...(fullName && { fullName }), ...(phone && { phone }), ...(avatar && { avatar }) },
      select: { id: true, email: true, fullName: true, phone: true, role: true, accountType: true, avatar: true },
    });

    res.json(user);
  } catch (error: any) {
    res.status(500).json({ error: error.message });
  }
};

export const becomeVendor = async (req: any, res: any) => {
  try {
    const user = await prisma.user.update({
      where: { id: req.user.id },
      data: { accountType: 'vendor', role: 'VENDOR' },
      select: { id: true, email: true, fullName: true, phone: true, role: true, accountType: true, avatar: true },
    });

    res.json(user);
  } catch (error: any) {
    res.status(500).json({ error: error.message });
  }
};

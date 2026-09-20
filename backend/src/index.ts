import dotenv from 'dotenv';
dotenv.config();

import express from 'express';
import cors from 'cors';
import { PrismaClient } from '@prisma/client';

import authRoutes from './routes/auth';
import restaurantRoutes from './routes/restaurants';
import menuRoutes from './routes/menu';
import orderRoutes from './routes/orders';
import cartRoutes from './routes/cart';
import promoRoutes from './routes/promos';
import riderRoutes from './routes/riders';
import adminRoutes from './routes/admin';
import vendorRoutes from './routes/vendor';
import userRoutes from './routes/users';
import notificationRoutes from './routes/notifications';

export const prisma = new PrismaClient();

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors({
  origin: '*',
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization', 'X-Business-Id', 'X-Branch-Id'],
}));
app.use(express.json());

// Health check
app.get('/api/health', (_req, res) => {
  res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

// Routes
app.use('/api/auth', authRoutes);
app.use('/api/restaurants', restaurantRoutes);
app.use('/api/menu', menuRoutes);
app.use('/api/orders', orderRoutes);
app.use('/api/cart', cartRoutes);
app.use('/api/promos', promoRoutes);
app.use('/api/riders', riderRoutes);
app.use('/api/admin', adminRoutes);
app.use('/api/vendor', vendorRoutes);
app.use('/api/users', userRoutes);
app.use('/api/notifications', notificationRoutes);

app.listen(PORT, () => {
  console.log(`FoodOS API running on http://localhost:${PORT}`);
});

process.on('SIGINT', async () => {
  await prisma.$disconnect();
  process.exit(0);
});

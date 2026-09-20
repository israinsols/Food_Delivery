import { PrismaClient } from '@prisma/client';
import bcrypt from 'bcryptjs';

const prisma = new PrismaClient();

async function main() {
  console.log('Seeding database...');

  // Clean existing data
  await prisma.orderTracking.deleteMany();
  await prisma.orderItem.deleteMany();
  await prisma.order.deleteMany();
  await prisma.cartItem.deleteMany();
  await prisma.review.deleteMany();
  await prisma.notification.deleteMany();
  await prisma.vendorAnalytics.deleteMany();
  await prisma.riderProfile.deleteMany();
  await prisma.promoCode.deleteMany();
  await prisma.menuItem.deleteMany();
  await prisma.category.deleteMany();
  await prisma.restaurant.deleteMany();
  await prisma.address.deleteMany();
  await prisma.user.deleteMany();

  const password = await bcrypt.hash('password123', 10);

  // ─── Users ───
  const admin = await prisma.user.create({
    data: { email: 'admin@foodos.com', password, fullName: 'Admin User', role: 'ADMIN', accountType: 'super_admin', phone: '+92 300 1234567' },
  });

  const vendor1 = await prisma.user.create({
    data: { email: 'ahmed@foodos.com', password, fullName: 'Ahmed Khan', role: 'VENDOR', accountType: 'vendor', phone: '+92 301 2345678' },
  });

  const vendor2 = await prisma.user.create({
    data: { email: 'sara@foodos.com', password, fullName: 'Sara Ali', role: 'VENDOR', accountType: 'vendor', phone: '+92 302 3456789' },
  });

  const customer1 = await prisma.user.create({
    data: { email: 'customer@foodos.com', password, fullName: 'Hamza Malik', role: 'CUSTOMER', accountType: 'customer', phone: '+92 303 4567890' },
  });

  const rider1 = await prisma.user.create({
    data: { email: 'rider@foodos.com', password, fullName: 'Bilal Ahmed', role: 'RIDER', accountType: 'customer', phone: '+92 304 5678901' },
  });

  // ─── Categories ───
  const categories = [
    { name: 'Biryani', emoji: '🍛' },
    { name: 'BBQ & Grilled', emoji: '🥩' },
    { name: 'Fast Food', emoji: '🍔' },
    { name: 'Pakistani', emoji: '🥘' },
    { name: 'Chinese', emoji: '🥡' },
    { name: 'Pizza', emoji: '🍕' },
    { name: 'Drinks', emoji: '🥤' },
    { name: 'Desserts', emoji: '🍮' },
    { name: 'Snacks', emoji: '🍿' },
    { name: 'Breakfast', emoji: '🍳' },
  ];

  for (const cat of categories) {
    await prisma.category.create({ data: cat });
  }

  // ─── Restaurants ───
  const foodOSKitchen = await prisma.restaurant.create({
    data: {
      name: 'FoodOS Kitchen',
      slug: 'foodos-kitchen',
      description: 'Authentic Pakistani cuisine with a modern twist',
      cuisine: 'Pakistani',
      image: 'assets/images/biryani.jpg',
      rating: 4.8,
      reviewCount: 342,
      deliveryTime: '25-35 min',
      deliveryFee: 'Rs 100',
      deliveryFeePerKm: 30,
      isOpen: true,
      isFeatured: true,
      ownerId: vendor1.id,
    },
  });

  const spiceHub = await prisma.restaurant.create({
    data: {
      name: 'Spice Hub',
      slug: 'spice-hub',
      description: 'Flavors that tell a story',
      cuisine: 'BBQ & Chinese',
      image: 'assets/images/kabab.jpg',
      rating: 4.6,
      reviewCount: 218,
      deliveryTime: '30-40 min',
      deliveryFee: 'Free',
      deliveryFeePerKm: 25,
      isOpen: true,
      isFeatured: true,
      ownerId: vendor1.id,
    },
  });

  const burgerHouse = await prisma.restaurant.create({
    data: {
      name: 'Burger House',
      slug: 'burger-house',
      description: 'Best smash burgers in town',
      cuisine: 'Fast Food',
      image: 'assets/images/pakora.jpg',
      rating: 4.7,
      reviewCount: 189,
      deliveryTime: '20-30 min',
      deliveryFee: 'Rs 80',
      deliveryFeePerKm: 20,
      isOpen: true,
      isFeatured: false,
      ownerId: vendor2.id,
    },
  });

  const sweetCorner = await prisma.restaurant.create({
    data: {
      name: 'Sweet Corner',
      slug: 'sweet-corner',
      description: 'Traditional desserts & mithai',
      cuisine: 'Desserts',
      image: 'assets/images/gulab_jamun.jpg',
      rating: 4.9,
      reviewCount: 156,
      deliveryTime: '15-25 min',
      deliveryFee: 'Free',
      deliveryFeePerKm: 20,
      isOpen: true,
      isFeatured: true,
      ownerId: vendor2.id,
    },
  });

  const pizzaCorner = await prisma.restaurant.create({
    data: {
      name: 'Pizza Corner',
      slug: 'pizza-corner',
      description: 'Wood-fired authentic Italian pizzas',
      cuisine: 'Pizza',
      image: 'assets/images/samosa.jpg',
      rating: 4.5,
      reviewCount: 203,
      deliveryTime: '30-45 min',
      deliveryFee: 'Rs 120',
      deliveryFeePerKm: 35,
      isOpen: true,
      isFeatured: false,
      ownerId: vendor2.id,
    },
  });

  const chaiWala = await prisma.restaurant.create({
    data: {
      name: 'Chai Wala',
      slug: 'chai-wala',
      description: 'Best karak chai & snacks',
      cuisine: 'Pakistani',
      image: 'assets/images/lassi.jpg',
      rating: 4.4,
      reviewCount: 278,
      deliveryTime: '10-20 min',
      deliveryFee: 'Free',
      deliveryFeePerKm: 15,
      isOpen: true,
      isFeatured: false,
      ownerId: vendor1.id,
    },
  });

  // ─── Menu Items ───
  const menuItems = [
    // FoodOS Kitchen
    { name: 'Chicken Biryani', price: 300, image: 'assets/images/biryani.jpg', category: 'Biryani', rating: 4.8, orders: 456, isBestseller: true, restaurantId: foodOSKitchen.id, description: 'Aromatic basmati rice layered with tender chicken, saffron, and traditional spices. Served with raita and salan.' },
    { name: 'Naan', price: 50, image: 'assets/images/naan.jpg', category: 'Pakistani', rating: 4.5, orders: 312, isBestseller: false, restaurantId: foodOSKitchen.id, description: 'Freshly baked tandoori naan bread, soft and fluffy.' },
    { name: 'Samosa (4 pcs)', price: 80, image: 'assets/images/samosa.jpg', category: 'Snacks', rating: 4.7, orders: 234, isBestseller: false, restaurantId: foodOSKitchen.id, description: 'Crispy golden pastry filled with spiced potato and peas.' },
    { name: 'Lassi', price: 100, image: 'assets/images/lassi.jpg', category: 'Drinks', rating: 4.6, orders: 189, isBestseller: false, restaurantId: foodOSKitchen.id, description: 'Refreshing traditional yogurt drink.' },

    // Spice Hub
    { name: 'Seekh Kabab', price: 200, image: 'assets/images/kabab.jpg', category: 'BBQ & Grilled', rating: 4.6, orders: 387, isBestseller: true, restaurantId: spiceHub.id, description: 'Juicy grilled minced meat kababs marinated in secret spices.' },
    { name: 'Chicken Manchurian', price: 350, image: 'assets/images/kabab.jpg', category: 'Chinese', rating: 4.5, orders: 198, isBestseller: false, restaurantId: spiceHub.id, description: 'Indo-Chinese style chicken in tangy manchurian sauce.' },
    { name: 'Cold Drink', price: 60, image: 'assets/images/cold_drink.jpg', category: 'Drinks', rating: 4.3, orders: 445, isBestseller: false, restaurantId: spiceHub.id, description: 'Refreshing cold beverage.' },

    // Burger House
    { name: 'Smash Burger', price: 550, image: 'assets/images/pakora.jpg', category: 'Fast Food', rating: 4.8, orders: 321, isBestseller: true, restaurantId: burgerHouse.id, description: 'Double smashed beef patty with cheese, pickles, and special sauce.' },

    // Sweet Corner
    { name: 'Gulab Jamun', price: 180, image: 'assets/images/gulab_jamun.jpg', category: 'Desserts', rating: 4.9, orders: 267, isBestseller: true, restaurantId: sweetCorner.id, description: 'Soft, spongy milk-solid dumplings soaked in rose-flavored sugar syrup.' },

    // Pizza Corner
    { name: 'Pepperoni Pizza', price: 800, image: 'assets/images/samosa.jpg', category: 'Pizza', rating: 4.7, orders: 156, isBestseller: true, restaurantId: pizzaCorner.id, description: 'Classic pepperoni pizza with premium mozzarella cheese.' },

    // Chai Wala
    { name: 'Karak Chai', price: 80, image: 'assets/images/lassi.jpg', category: 'Drinks', rating: 4.6, orders: 512, isBestseller: true, restaurantId: chaiWala.id, description: 'Strong Pakistani-style tea brewed with cardamom and fresh milk.' },
    { name: 'Pakora (6 pcs)', price: 80, image: 'assets/images/pakora.jpg', category: 'Snacks', rating: 4.7, orders: 345, isBestseller: false, restaurantId: chaiWala.id, description: 'Crispy vegetable fritters made with gram flour and fresh spices.' },
  ];

  for (const item of menuItems) {
    await prisma.menuItem.create({ data: item });
  }

  // ─── Promo Codes ───
  await prisma.promoCode.createMany({
    data: [
      { code: 'FIRST20', description: '20% off on first order', discountType: 'percentage', discountValue: 20, minOrder: 500, maxUses: 1, isActive: true, expiresAt: new Date('2026-12-31') },
      { code: 'FREEDEL', description: 'Free delivery on all orders', discountType: 'free_delivery', discountValue: 100, minOrder: 300, maxUses: 100, isActive: true, expiresAt: new Date('2026-12-31') },
      { code: 'WEEKEND50', description: 'Rs 50 off on weekend orders', discountType: 'fixed', discountValue: 50, minOrder: 400, maxUses: 50, isActive: true, expiresAt: new Date('2026-12-31') },
      { code: 'REFER100', description: 'Rs 100 off when you refer a friend', discountType: 'fixed', discountValue: 100, minOrder: 600, maxUses: 200, isActive: true },
    ],
  });

  // ─── Addresses ───
  await prisma.address.createMany({
    data: [
      { label: 'Home', address: 'House 12, Street 4, DHA Phase 5, Lahore', latitude: 31.4700, longitude: 74.3500, isDefault: true, userId: customer1.id },
      { label: 'Office', address: 'Office 301, Tech Plaza, Gulberg III, Lahore', latitude: 31.5200, longitude: 74.3600, isDefault: false, userId: customer1.id },
    ],
  });

  // ─── Rider Profile ───
  await prisma.riderProfile.create({
    data: { vehicleType: 'Bike', vehicleNumber: 'LEA-1234', isAvailable: true, userId: rider1.id },
  });

  console.log('Database seeded successfully!');
  console.log('---');
  console.log('Test accounts:');
  console.log('Admin:    admin@foodos.com / password123');
  console.log('Vendor:   ahmed@foodos.com / password123');
  console.log('Customer: customer@foodos.com / password123');
  console.log('Rider:    rider@foodos.com / password123');
}

main()
  .catch(console.error)
  .finally(() => prisma.$disconnect());

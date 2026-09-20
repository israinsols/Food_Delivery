import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodos/core/network/api/restaurant_api.dart';
import 'package:foodos/core/network/api/menu_api.dart';
import '../models/restaurant_model.dart';

// Food Categories
final foodCategoriesProvider = Provider<List<FoodCategory>>((ref) {
  return const [
    FoodCategory(id: '1', name: 'All', emoji: '🍽️', restaurantCount: 8),
    FoodCategory(id: '2', name: 'Biryani', emoji: '🍛', restaurantCount: 5),
    FoodCategory(id: '3', name: 'Fast Food', emoji: '🍔', restaurantCount: 4),
    FoodCategory(id: '4', name: 'Pizza', emoji: '🍕', restaurantCount: 3),
    FoodCategory(id: '5', name: 'BBQ & Grilled', emoji: '🥩', restaurantCount: 4),
    FoodCategory(id: '6', name: 'Chinese', emoji: '🥡', restaurantCount: 3),
    FoodCategory(id: '7', name: 'Continental', emoji: '🥩', restaurantCount: 2),
    FoodCategory(id: '8', name: 'Desserts', emoji: '🍰', restaurantCount: 4),
    FoodCategory(id: '9', name: 'Drinks', emoji: '☕', restaurantCount: 6),
    FoodCategory(id: '10', name: 'Pakistani', emoji: '🥙', restaurantCount: 5),
  ];
});

// Mutable restaurant list via StateNotifier
class RestaurantListNotifier extends StateNotifier<List<Restaurant>> {
  final RestaurantApi _restaurantApi;
  final MenuApi _menuApi;

  RestaurantListNotifier(this._restaurantApi, this._menuApi) : super(_initialRestaurants) {
    loadFromApi();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> loadFromApi() async {
    if (_isLoading) return;
    _isLoading = true;
    try {
      final restaurantsData = await _restaurantApi.getAll();
      if (restaurantsData.isNotEmpty) {
        final restaurants = restaurantsData.map((r) => Restaurant.fromJson(r as Map<String, dynamic>)).toList();
        // Fetch menu items for each restaurant
        for (var i = 0; i < restaurants.length; i++) {
          try {
            final menuData = await _menuApi.getAll(restaurantId: restaurants[i].id);
            final menuItems = menuData.map((m) => MenuItem.fromJson(m as Map<String, dynamic>)).toList();
            restaurants[i] = restaurants[i].copyWith(menuItems: menuItems);
          } catch (_) {}
        }
        state = restaurants;
      }
    } catch (_) {
      // Keep mock data on error
    } finally {
      _isLoading = false;
    }
  }

  void addRestaurant(Restaurant restaurant) {
    state = [...state, restaurant];
  }

  void updateRestaurant(String id, Restaurant updated) {
    state = [
      for (final r in state)
        if (r.id == id) updated else r,
    ];
  }

  void addMenuItem(String restaurantId, MenuItem item) {
    state = [
      for (final r in state)
        if (r.id == restaurantId)
          r.copyWith(menuItems: [...r.menuItems, item])
        else
          r,
    ];
  }

  void updateMenuItem(String restaurantId, String itemId, MenuItem updated) {
    state = [
      for (final r in state)
        if (r.id == restaurantId)
          r.copyWith(
            menuItems: [
              for (final m in r.menuItems)
                if (m.id == itemId) updated else m,
            ],
          )
        else
          r,
    ];
  }

  void removeMenuItem(String restaurantId, String itemId) {
    state = [
      for (final r in state)
        if (r.id == restaurantId)
          r.copyWith(
            menuItems: r.menuItems.where((m) => m.id != itemId).toList(),
          )
        else
          r,
    ];
  }

  void toggleItemAvailability(String restaurantId, String itemId) {
    state = [
      for (final r in state)
        if (r.id == restaurantId)
          r.copyWith(
            menuItems: [
              for (final m in r.menuItems)
                if (m.id == itemId)
                  m.copyWith(isAvailable: !m.isAvailable)
                else
                  m,
            ],
          )
        else
          r,
    ];
  }
}

final restaurantsProvider = StateNotifierProvider<RestaurantListNotifier, List<Restaurant>>((ref) {
  return RestaurantListNotifier(RestaurantApi(), MenuApi());
});

// Selected category filter
final selectedCategoryProvider = StateProvider<String>((ref) => 'All');

// Filtered restaurants by category
final filteredRestaurantsProvider = Provider<List<Restaurant>>((ref) {
  final restaurants = ref.watch(restaurantsProvider);
  final selectedCategory = ref.watch(selectedCategoryProvider);

  if (selectedCategory == 'All') return restaurants;
  return restaurants.where((r) => r.categories.contains(selectedCategory)).toList();
});

// Restaurant by ID
final restaurantByIdProvider = Provider.family<Restaurant?, String>((ref, id) {
  final restaurants = ref.watch(restaurantsProvider);
  try {
    return restaurants.firstWhere((r) => r.id == id);
  } catch (_) {
    return null;
  }
});

// All menu items across all restaurants (for "All Food" view)
final allMenuItemsProvider = Provider<List<MenuItem>>((ref) {
  final restaurants = ref.watch(restaurantsProvider);
  final items = <MenuItem>[];
  for (final r in restaurants) {
    for (final item in r.menuItems) {
      items.add(item);
    }
  }
  return items;
});

// Get restaurants that have a specific menu item name
final restaurantsForItemProvider = Provider.family<List<Map<String, dynamic>>, String>((ref, itemName) {
  final restaurants = ref.watch(restaurantsProvider);
  final results = <Map<String, dynamic>>[];
  for (final r in restaurants) {
    for (final item in r.menuItems) {
      if (item.name.toLowerCase() == itemName.toLowerCase()) {
        results.add({
          'restaurant': r,
          'item': item,
        });
      }
    }
  }
  return results;
});

// Initial mock data
final _initialRestaurants = [
  const Restaurant(
    id: 'r1',
    name: 'FoodOS Kitchen',
    image: 'assets/images/biryani.jpg',
    coverImage: 'assets/images/biryani.jpg',
    cuisine: 'Biryani, Kebabs, BBQ',
    rating: 4.8,
    reviewCount: 324,
    deliveryTime: '25-30 min',
    deliveryFee: 'Free',
    minOrder: 200,
    address: 'Main Boulevard, Gulberg III, Lahore',
    phone: '+92 300 1234567',
    isOpen: true,
    isFeatured: true,
    categories: ['Biryani', 'BBQ & Grilled', 'Pakistani'],
    menuItems: [
      MenuItem(id: 'm1', name: 'Chicken Biryani', description: 'Authentic Hyderabadi chicken biryani with tender chicken, aromatic rice, and blend of traditional spices', image: 'assets/images/biryani.jpg', price: 300, category: 'Biryani', rating: 4.8, orders: 324, isBestseller: true, addOns: ['Extra Cheese', 'Extra Chicken', 'Raita'], restaurantId: 'r1', restaurantName: 'FoodOS Kitchen'),
      MenuItem(id: 'm2', name: 'Seekh Kabab', description: 'Grilled minced chicken seekh kabab with secret spices', image: 'assets/images/kabab.jpg', price: 200, category: 'BBQ & Grilled', rating: 4.6, orders: 218, isBestseller: true, restaurantId: 'r1', restaurantName: 'FoodOS Kitchen'),
      MenuItem(id: 'm3', name: 'Naan', description: 'Fresh tandoori naan bread', image: 'assets/images/naan.jpg', price: 50, category: 'Pakistani', rating: 4.5, orders: 456, restaurantId: 'r1', restaurantName: 'FoodOS Kitchen'),
      MenuItem(id: 'm4', name: 'Samosa (4 pcs)', description: 'Crispy samosas with spiced potato filling', image: 'assets/images/samosa.jpg', price: 80, category: 'Pakistani', rating: 4.7, orders: 189, restaurantId: 'r1', restaurantName: 'FoodOS Kitchen'),
      MenuItem(id: 'm5', name: 'Gulab Jamun', description: 'Soft gulab jamun in sugar syrup', image: 'assets/images/gulab_jamun.jpg', price: 120, category: 'Desserts', rating: 4.9, orders: 156, restaurantId: 'r1', restaurantName: 'FoodOS Kitchen'),
      MenuItem(id: 'm6', name: 'Lassi', description: 'Traditional yogurt drink', image: 'assets/images/lassi.jpg', price: 100, category: 'Drinks', rating: 4.6, orders: 234, restaurantId: 'r1', restaurantName: 'FoodOS Kitchen'),
    ],
  ),
  const Restaurant(
    id: 'r2',
    name: 'Pizza Corner',
    image: 'assets/images/samosa.jpg',
    coverImage: 'assets/images/samosa.jpg',
    cuisine: 'Pizza, Pasta, Burgers',
    rating: 4.7,
    reviewCount: 256,
    deliveryTime: '30-35 min',
    deliveryFee: 'Rs 50',
    minOrder: 300,
    address: 'MM Alam Road, Gulberg III, Lahore',
    phone: '+92 301 9876543',
    isOpen: true,
    isFeatured: true,
    categories: ['Pizza', 'Fast Food'],
    menuItems: [
      MenuItem(id: 'm7', name: 'Pepperoni Pizza', description: 'Classic pepperoni pizza with mozzarella cheese', image: 'assets/images/samosa.jpg', price: 800, category: 'Pizza', rating: 4.7, orders: 189, isBestseller: true, restaurantId: 'r2', restaurantName: 'Pizza Corner'),
      MenuItem(id: 'm8', name: 'Chicken Fajita Pizza', description: 'Spicy chicken fajita with peppers and onions', image: 'assets/images/samosa.jpg', price: 750, category: 'Pizza', rating: 4.6, orders: 167, restaurantId: 'r2', restaurantName: 'Pizza Corner'),
      MenuItem(id: 'm9', name: 'Classic Burger', description: 'Beef patty with lettuce, tomato, and special sauce', image: 'assets/images/kabab.jpg', price: 450, category: 'Fast Food', rating: 4.5, orders: 234, restaurantId: 'r2', restaurantName: 'Pizza Corner'),
      MenuItem(id: 'm10', name: 'Chicken Wings (8 pcs)', description: 'Crispy fried chicken wings with buffalo sauce', image: 'assets/images/kabab.jpg', price: 600, category: 'Fast Food', rating: 4.8, orders: 198, isBestseller: true, restaurantId: 'r2', restaurantName: 'Pizza Corner'),
      MenuItem(id: 'm11', name: 'Pasta Alfredo', description: 'Creamy Alfredo pasta with grilled chicken', image: 'assets/images/naan.jpg', price: 550, category: 'Fast Food', rating: 4.4, orders: 145, restaurantId: 'r2', restaurantName: 'Pizza Corner'),
    ],
  ),
  const Restaurant(
    id: 'r3',
    name: 'Spice Hub',
    image: 'assets/images/kabab.jpg',
    coverImage: 'assets/images/kabab.jpg',
    cuisine: 'Pakistani, Chinese, BBQ',
    rating: 4.5,
    reviewCount: 189,
    deliveryTime: '20-25 min',
    deliveryFee: 'Rs 30',
    minOrder: 150,
    address: 'DHA Phase 5, Lahore',
    phone: '+92 302 4567890',
    isOpen: true,
    isFeatured: false,
    categories: ['Chinese', 'BBQ & Grilled', 'Pakistani'],
    menuItems: [
      MenuItem(id: 'm12', name: 'Chicken Manchurian', description: 'Indo-Chinese chicken manchurian with rice', image: 'assets/images/kabab.jpg', price: 350, category: 'Chinese', rating: 4.5, orders: 178, restaurantId: 'r3', restaurantName: 'Spice Hub'),
      MenuItem(id: 'm13', name: 'Seekh Kabab Platter', description: 'Mix grill platter with seekh kabab, reshmi kabab, and tikka', image: 'assets/images/kabab.jpg', price: 500, category: 'BBQ & Grilled', rating: 4.7, orders: 234, isBestseller: true, restaurantId: 'r3', restaurantName: 'Spice Hub'),
      MenuItem(id: 'm14', name: 'Chicken Fried Rice', description: 'Wok-fried rice with chicken and vegetables', image: 'assets/images/biryani.jpg', price: 280, category: 'Chinese', rating: 4.4, orders: 156, restaurantId: 'r3', restaurantName: 'Spice Hub'),
      MenuItem(id: 'm15', name: 'Daal Makhni', description: 'Creamy black lentils slow-cooked overnight', image: 'assets/images/gulab_jamun.jpg', price: 220, category: 'Pakistani', rating: 4.6, orders: 145, restaurantId: 'r3', restaurantName: 'Spice Hub'),
      MenuItem(id: 'm16', name: 'Cold Drink', description: 'Pepsi / Coke / Sprite 500ml', image: 'assets/images/cold_drink.jpg', price: 60, category: 'Drinks', rating: 4.3, orders: 345, restaurantId: 'r3', restaurantName: 'Spice Hub'),
    ],
  ),
  const Restaurant(
    id: 'r4',
    name: 'Burger House',
    image: 'assets/images/pakora.jpg',
    coverImage: 'assets/images/pakora.jpg',
    cuisine: 'Burgers, Fast Food, shakes',
    rating: 4.6,
    reviewCount: 312,
    deliveryTime: '15-20 min',
    deliveryFee: 'Free',
    minOrder: 200,
    address: 'Liberty Market, Lahore',
    phone: '+92 303 1112233',
    isOpen: true,
    isFeatured: true,
    categories: ['Fast Food'],
    menuItems: [
      MenuItem(id: 'm17', name: 'Smash Burger', description: 'Double smashed beef patty with cheese and pickles', image: 'assets/images/pakora.jpg', price: 550, category: 'Fast Food', rating: 4.8, orders: 456, isBestseller: true, restaurantId: 'r4', restaurantName: 'Burger House'),
      MenuItem(id: 'm18', name: 'Zinger Burger', description: 'Crispy chicken zinger with mayo and lettuce', image: 'assets/images/pakora.jpg', price: 480, category: 'Fast Food', rating: 4.7, orders: 389, restaurantId: 'r4', restaurantName: 'Burger House'),
      MenuItem(id: 'm19', name: 'Loaded Fries', description: 'Fries topped with cheese, jalapenos, and BBQ sauce', image: 'assets/images/samosa.jpg', price: 350, category: 'Fast Food', rating: 4.6, orders: 267, restaurantId: 'r4', restaurantName: 'Burger House'),
      MenuItem(id: 'm20', name: 'Chocolate Shake', description: 'Thick chocolate milkshake with whipped cream', image: 'assets/images/lassi.jpg', price: 250, category: 'Drinks', rating: 4.5, orders: 198, restaurantId: 'r4', restaurantName: 'Burger House'),
    ],
  ),
  const Restaurant(
    id: 'r5',
    name: 'Sweet Corner',
    image: 'assets/images/gulab_jamun.jpg',
    coverImage: 'assets/images/gulab_jamun.jpg',
    cuisine: 'Desserts, Mithai, Ice Cream',
    rating: 4.9,
    reviewCount: 445,
    deliveryTime: '20-25 min',
    deliveryFee: 'Rs 40',
    minOrder: 100,
    address: 'Anarkali Bazaar, Lahore',
    phone: '+92 304 5556677',
    isOpen: true,
    isFeatured: false,
    categories: ['Desserts'],
    menuItems: [
      MenuItem(id: 'm21', name: 'Gulab Jamun (6 pcs)', description: 'Soft gulab jamun in rose-flavored sugar syrup', image: 'assets/images/gulab_jamun.jpg', price: 180, category: 'Desserts', rating: 4.9, orders: 567, isBestseller: true, restaurantId: 'r5', restaurantName: 'Sweet Corner'),
      MenuItem(id: 'm22', name: 'Jalebi (8 pcs)', description: 'Crispy hot jalebi with saffron syrup', image: 'assets/images/gulab_jamun.jpg', price: 150, category: 'Desserts', rating: 4.8, orders: 445, restaurantId: 'r5', restaurantName: 'Sweet Corner'),
      MenuItem(id: 'm23', name: 'Ras Malai (2 pcs)', description: 'Soft paneer balls in saffron milk', image: 'assets/images/gulab_jamun.jpg', price: 200, category: 'Desserts', rating: 4.7, orders: 334, restaurantId: 'r5', restaurantName: 'Sweet Corner'),
      MenuItem(id: 'm24', name: 'Kulfi', description: 'Traditional Pakistani ice cream', image: 'assets/images/lassi.jpg', price: 120, category: 'Desserts', rating: 4.6, orders: 223, restaurantId: 'r5', restaurantName: 'Sweet Corner'),
    ],
  ),
  const Restaurant(
    id: 'r6',
    name: 'Chai Wala',
    image: 'assets/images/lassi.jpg',
    coverImage: 'assets/images/lassi.jpg',
    cuisine: 'Tea, Coffee, Snacks',
    rating: 4.4,
    reviewCount: 178,
    deliveryTime: '10-15 min',
    deliveryFee: 'Rs 20',
    minOrder: 50,
    address: 'Gulberg II, Lahore',
    phone: '+92 305 8889900',
    isOpen: true,
    isFeatured: false,
    categories: ['Drinks'],
    menuItems: [
      MenuItem(id: 'm25', name: 'Karak Chai', description: 'Strong Pakistani-style tea with cardamom', image: 'assets/images/lassi.jpg', price: 80, category: 'Drinks', rating: 4.6, orders: 678, isBestseller: true, restaurantId: 'r6', restaurantName: 'Chai Wala'),
      MenuItem(id: 'm26', name: 'Lassi', description: 'Sweet or salted yogurt drink', image: 'assets/images/lassi.jpg', price: 100, category: 'Drinks', rating: 4.5, orders: 445, restaurantId: 'r6', restaurantName: 'Chai Wala'),
      MenuItem(id: 'm27', name: 'Pakora (6 pcs)', description: 'Crispy vegetable fritters with chutney', image: 'assets/images/pakora.jpg', price: 80, category: 'Drinks', rating: 4.7, orders: 334, restaurantId: 'r6', restaurantName: 'Chai Wala'),
      MenuItem(id: 'm28', name: 'Cold Coffee', description: 'Iced coffee with milk and vanilla', image: 'assets/images/cold_drink.jpg', price: 150, category: 'Drinks', rating: 4.4, orders: 223, restaurantId: 'r6', restaurantName: 'Chai Wala'),
    ],
  ),
];

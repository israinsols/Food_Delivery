class Restaurant {
  final String id;
  final String name;
  final String image;
  final String coverImage;
  final String cuisine;
  final double rating;
  final int reviewCount;
  final String deliveryTime;
  final String deliveryFee;
  final int minOrder;
  final String address;
  final String phone;
  final bool isOpen;
  final bool isFeatured;
  final List<String> categories;
  final List<MenuItem> menuItems;

  const Restaurant({
    required this.id,
    required this.name,
    this.image = 'assets/images/biryani.jpg',
    this.coverImage = 'assets/images/biryani.jpg',
    this.cuisine = 'Mixed',
    this.rating = 4.5,
    this.reviewCount = 0,
    this.deliveryTime = '25-30 min',
    this.deliveryFee = 'Free',
    this.minOrder = 100,
    this.address = '',
    this.phone = '',
    this.isOpen = true,
    this.isFeatured = false,
    this.categories = const [],
    this.menuItems = const [],
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? 'assets/images/biryani.jpg',
      coverImage: json['coverImage'] ?? json['image'] ?? 'assets/images/biryani.jpg',
      cuisine: json['cuisine'] ?? 'Mixed',
      rating: (json['rating'] as num?)?.toDouble() ?? 4.5,
      reviewCount: json['reviewCount'] ?? json['_count']?['orders'] ?? 0,
      deliveryTime: json['deliveryTime'] ?? '25-30 min',
      deliveryFee: json['deliveryFee'] ?? 'Free',
      minOrder: json['minOrder'] ?? 100,
      address: json['address'] ?? '',
      phone: json['phone'] ?? '',
      isOpen: json['isOpen'] ?? true,
      isFeatured: json['isFeatured'] ?? false,
      categories: json['cuisine']?.toString().split(',').map((e) => e.trim()).toList() ?? [],
      menuItems: (json['menuItems'] as List<dynamic>?)
              ?.map((e) => MenuItem.fromJson(e as Map<String, dynamic>))
              .toList() ?? [],
    );
  }

  Restaurant copyWith({
    String? name,
    String? cuisine,
    String? address,
    String? phone,
    List<String>? categories,
    List<MenuItem>? menuItems,
    bool? isOpen,
    bool? isFeatured,
    String? deliveryTime,
    String? deliveryFee,
    int? minOrder,
  }) {
    return Restaurant(
      id: id,
      name: name ?? this.name,
      image: image,
      coverImage: coverImage,
      cuisine: cuisine ?? this.cuisine,
      rating: rating,
      reviewCount: reviewCount,
      deliveryTime: deliveryTime ?? this.deliveryTime,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      minOrder: minOrder ?? this.minOrder,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      isOpen: isOpen ?? this.isOpen,
      isFeatured: isFeatured ?? this.isFeatured,
      categories: categories ?? this.categories,
      menuItems: menuItems ?? this.menuItems,
    );
  }
}

class MenuItem {
  final String id;
  final String name;
  final String description;
  final String image;
  final int price;
  final String category;
  final double rating;
  final int orders;
  final bool isBestseller;
  final bool isAvailable;
  final List<String> addOns;
  final String? restaurantId;
  final String? restaurantName;

  const MenuItem({
    required this.id,
    required this.name,
    this.description = '',
    this.image = 'assets/images/biryani.jpg',
    required this.price,
    required this.category,
    this.rating = 4.5,
    this.orders = 0,
    this.isBestseller = false,
    this.isAvailable = true,
    this.addOns = const [],
    this.restaurantId,
    this.restaurantName,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? 'assets/images/biryani.jpg',
      price: json['price'] ?? 0,
      category: json['category'] ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 4.5,
      orders: json['orders'] ?? 0,
      isBestseller: json['isBestseller'] ?? false,
      isAvailable: json['isAvailable'] ?? true,
      addOns: json['addOns'] != null ? List<String>.from(json['addOns']) : [],
      restaurantId: json['restaurantId'] ?? json['restaurant']?['id'],
      restaurantName: json['restaurant']?['name'],
    );
  }

  MenuItem copyWith({
    String? name,
    String? description,
    int? price,
    String? category,
    bool? isAvailable,
    List<String>? addOns,
  }) {
    return MenuItem(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      image: image,
      price: price ?? this.price,
      category: category ?? this.category,
      rating: rating,
      orders: orders,
      isBestseller: isBestseller,
      isAvailable: isAvailable ?? this.isAvailable,
      addOns: addOns ?? this.addOns,
      restaurantId: restaurantId,
      restaurantName: restaurantName,
    );
  }
}

class FoodCategory {
  final String id;
  final String name;
  final String emoji;
  final int restaurantCount;

  const FoodCategory({
    required this.id,
    required this.name,
    required this.emoji,
    this.restaurantCount = 0,
  });
}

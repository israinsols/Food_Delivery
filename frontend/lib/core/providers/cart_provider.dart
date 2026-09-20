import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartItem {
  final String id;
  final String name;
  final int price;
  final String image;
  final String restaurantId;
  final String restaurantName;
  int quantity;
  String size;
  String spiceLevel;
  List<String> addOns;
  String notes;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.restaurantId,
    required this.restaurantName,
    this.quantity = 1,
    this.size = 'Regular',
    this.spiceLevel = 'Medium',
    this.addOns = const [],
    this.notes = '',
  });

  int get total => price * quantity;
}

class DeliveryInfo {
  final String label;
  final String address;
  final double? lat;
  final double? lng;

  const DeliveryInfo({
    required this.label,
    required this.address,
    this.lat,
    this.lng,
  });
}

class CartState {
  final List<CartItem> items;
  final DeliveryInfo? deliveryAddress;
  final String paymentMethod;
  final int tip;
  final String orderNotes;

  const CartState({
    this.items = const [],
    this.deliveryAddress,
    this.paymentMethod = 'CASH_ON_DELIVERY',
    this.tip = 0,
    this.orderNotes = '',
  });

  int get subtotal => items.fold(0, (sum, i) => sum + i.total);
  int get tax => (subtotal * 0.08).round();

  int get deliveryFee {
    if (deliveryAddress == null) return 0;
    final distKm = _estimateDistance();
    return _calculateFee(distKm);
  }

  int get total => subtotal + deliveryFee + tax + tip;

  int _estimateDistance() {
    // Lahori coordinates — rough estimate
    return 3 + (deliveryAddress?.address.length ?? 0) % 5;
  }

  int _calculateFee(int km) {
    const feePerKm = 25;
    final fee = km * feePerKm;
    if (fee < 50) return 50;
    if (fee > 300) return 300;
    return fee;
  }

  int get discountPercent {
    // First order = 10% discount (check via ordersPlaced provider)
    return 10;
  }

  int get discount => (subtotal * discountPercent / 100).round();

  int get grandTotal => total - discount;

  CartState copyWith({
    List<CartItem>? items,
    DeliveryInfo? deliveryAddress,
    String? paymentMethod,
    int? tip,
    String? orderNotes,
  }) {
    return CartState(
      items: items ?? this.items,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      tip: tip ?? this.tip,
      orderNotes: orderNotes ?? this.orderNotes,
    );
  }
}

class CartNotifier extends StateNotifier<CartState> {
  CartNotifier() : super(const CartState());

  void addItem(CartItem item) {
    final existing = state.items.where((i) => i.id == item.id).toList();
    if (existing.isNotEmpty) {
      existing.first.quantity += 1;
      state = state.copyWith(items: [...state.items]);
    } else {
      state = state.copyWith(items: [...state.items, item]);
    }
  }

  void removeItem(String id) {
    state = state.copyWith(
      items: state.items.where((i) => i.id != id).toList(),
    );
  }

  void updateQuantity(String id, int qty) {
    if (qty <= 0) {
      removeItem(id);
      return;
    }
    final items = state.items.map((i) {
      if (i.id == id) i.quantity = qty;
      return i;
    }).toList();
    state = state.copyWith(items: items);
  }

  void setDeliveryAddress(DeliveryInfo addr) {
    state = state.copyWith(deliveryAddress: addr);
  }

  void setPaymentMethod(String method) {
    state = state.copyWith(paymentMethod: method);
  }

  void setTip(int amount) {
    state = state.copyWith(tip: amount);
  }

  void setOrderNotes(String notes) {
    state = state.copyWith(orderNotes: notes);
  }

  void clear() {
    state = const CartState();
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  return CartNotifier();
});

// Delivery addresses
final deliveryAddressesProvider = Provider<List<DeliveryInfo>>((ref) {
  return const [
    DeliveryInfo(label: 'Home', address: 'House 12, Street 4, DHA Phase 5, Lahore', lat: 31.4700, lng: 74.3500),
    DeliveryInfo(label: 'Office', address: 'Office 301, Tech Plaza, Gulberg III, Lahore', lat: 31.5200, lng: 74.3600),
  ];
});

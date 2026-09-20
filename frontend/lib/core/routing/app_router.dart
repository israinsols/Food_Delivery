import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';
import '../models/restaurant_model.dart';

// Auth
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/signup_screen.dart';
import '../../features/auth/presentation/screens/role_select_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/reset_password_screen.dart';
import '../../features/auth/presentation/screens/email_verification_screen.dart';
// Onboarding
import '../../features/onboarding/presentation/screens/create_business_screen.dart';
import '../../features/onboarding/presentation/screens/branch_setup_screen.dart';
import '../../features/onboarding/presentation/screens/menu_setup_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_complete_screen.dart';
// Dashboard
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
// POS
import '../../features/pos/presentation/screens/pos_screen.dart';
import '../../features/pos/presentation/screens/payment_screen.dart';
import '../../features/pos/presentation/screens/order_history_screen.dart';
import '../../features/pos/presentation/screens/order_detail_screen.dart';
// Kitchen
import '../../features/kitchen/presentation/screens/kitchen_display_screen.dart';
// Menu
import '../../features/menu/presentation/screens/menu_list_screen.dart';
import '../../features/menu/presentation/screens/add_edit_menu_item_screen.dart';
import '../../features/menu/presentation/screens/menu_category_screen.dart';
// Inventory
import '../../features/inventory/presentation/screens/inventory_list_screen.dart';
import '../../features/inventory/presentation/screens/supplier_list_screen.dart';
import '../../features/inventory/presentation/screens/stock_adjustment_screen.dart';
import '../../features/inventory/presentation/screens/purchase_order_list_screen.dart';
// Customers
import '../../features/customers/presentation/screens/customer_list_screen.dart';
import '../../features/customers/presentation/screens/customer_detail_screen.dart';
// Employees
import '../../features/employees/presentation/screens/staff_list_screen.dart';
import '../../features/employees/presentation/screens/staff_detail_screen.dart';
import '../../features/employees/presentation/screens/invite_staff_screen.dart';
// Expenses
import '../../features/expenses/presentation/screens/expense_list_screen.dart';
import '../../features/expenses/presentation/screens/expense_detail_screen.dart';
import '../../features/expenses/presentation/screens/daily_closing_screen.dart';
// Reports
import '../../features/reports/presentation/screens/reports_hub_screen.dart';
import '../../features/reports/presentation/screens/sales_report_screen.dart';
import '../../features/reports/presentation/screens/inventory_report_screen.dart';
import '../../features/reports/presentation/screens/staff_performance_report_screen.dart';
import '../../features/reports/presentation/screens/customer_analytics_screen.dart';
import '../../features/reports/presentation/screens/expense_report_screen.dart';
import '../../features/reports/presentation/screens/profit_loss_report_screen.dart';
// Other shell screens
import '../../features/tables/presentation/screens/table_layout_screen.dart';
import '../../features/notifications/presentation/screens/notification_center_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/settings/presentation/screens/profile_screen.dart';
import '../../features/settings/presentation/screens/billing_history_screen.dart';
import '../../features/settings/presentation/screens/change_password_screen.dart';
import '../../features/settings/presentation/screens/business_info_screen.dart';
import '../../features/settings/presentation/screens/branches_screen.dart';
import '../../features/settings/presentation/screens/tax_settings_screen.dart';
import '../../features/settings/presentation/screens/printer_settings_screen.dart';
import '../../features/settings/presentation/screens/help_center_screen.dart';
import '../../features/settings/presentation/screens/contact_support_screen.dart';
import '../../features/settings/presentation/screens/about_screen.dart';
import '../../features/subscription/presentation/screens/subscription_screen.dart';
// New screens
import '../../features/inventory/presentation/screens/add_supplier_screen.dart';
import '../../features/inventory/presentation/screens/create_purchase_order_screen.dart';
import '../../features/inventory/presentation/screens/add_inventory_item_screen.dart';
import '../../features/customers/presentation/screens/add_customer_screen.dart';
import '../../features/employees/presentation/screens/edit_staff_screen.dart';
// Delivery
import '../../features/delivery/presentation/screens/delivery_list_screen.dart';
import '../../features/delivery/presentation/screens/delivery_detail_screen.dart';
import '../../features/delivery/presentation/screens/rider_list_screen.dart';
import '../../features/delivery/presentation/screens/add_rider_screen.dart';
import '../../features/delivery/presentation/screens/delivery_settings_screen.dart';
// Customer App
import '../../features/customer_app/presentation/screens/customer_home_screen.dart';
import '../../features/customer_app/presentation/screens/search_screen.dart';
import '../../features/customer_app/presentation/screens/cart_screen.dart';
import '../../features/customer_app/presentation/screens/orders_screen.dart';
import '../../features/customer_app/presentation/screens/customer_profile_screen.dart';
import '../../features/customer_app/presentation/screens/food_detail_screen.dart';
import '../../features/customer_app/presentation/screens/order_tracking_screen.dart';
import '../../features/customer_app/presentation/screens/delivery_addresses_screen.dart';
import '../../features/customer_app/presentation/screens/rating_review_screen.dart';
import '../../features/customer_app/presentation/screens/favorites_screen.dart';
import '../../features/customer_app/presentation/screens/onboarding_screen.dart';
import '../../features/customer_app/presentation/screens/food_customization_screen.dart';
import '../../features/customer_app/presentation/screens/delivery_instructions_screen.dart';
import '../../features/customer_app/presentation/screens/tip_rider_screen.dart';
import '../../features/customer_app/presentation/screens/scheduled_order_screen.dart';
import '../../features/customer_app/presentation/screens/restaurant_detail_screen.dart';
import '../../features/customer_app/presentation/screens/food_item_detail_screen.dart';
import '../../features/customer_app/presentation/screens/promo_codes_screen.dart';
import '../../features/customer_app/presentation/screens/payment_methods_screen.dart';
import '../../features/customer_app/presentation/screens/notifications_screen.dart';
import '../../features/vendor/presentation/screens/vendor_analytics_screen.dart';
import '../../features/dashboard/presentation/screens/admin_dashboard_screen.dart';
// Vendor
import '../../features/vendor/presentation/screens/vendor_register_screen.dart';
import '../../features/vendor/presentation/screens/vendor_dashboard_screen.dart';
import '../../features/vendor/presentation/screens/vendor_menu_screen.dart';
import '../../features/vendor/presentation/screens/vendor_home_screen.dart';
import '../../features/vendor/presentation/screens/vendor_orders_screen.dart';
import '../../features/vendor/presentation/screens/vendor_profile_screen.dart';
// Admin
import '../../features/dashboard/presentation/screens/admin_home_screen.dart';
import '../../features/dashboard/presentation/screens/admin_restaurants_screen.dart';
import '../../features/dashboard/presentation/screens/admin_orders_screen.dart';
import '../../features/dashboard/presentation/screens/admin_users_screen.dart';
import '../../features/dashboard/presentation/screens/admin_profile_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();

final goRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    redirect: (context, state) {
      final isLoggedIn = authState.status == AuthStatus.authenticated && authState.user != null;
      final accountType = authState.user?.accountType ?? '';
      final path = state.matchedLocation;

      // Auth routes — always allowed (except splash, which redirects)
      final authRoutes = ['/login', '/signup', '/role-select', '/forgot-password', '/reset-password', '/email-verification'];
      if (authRoutes.contains(path)) return null;

      // Splash — redirect based on auth state
      if (path == '/') {
        if (isLoggedIn) {
          switch (accountType) {
            case 'vendor': return '/vendor/home';
            case 'super_admin': return '/admin/dashboard';
            default: return '/customer/home';
          }
        }
        return '/login';
      }

      // Not logged in → force login (except onboarding for vendor)
      if (!isLoggedIn) {
        if (path.startsWith('/vendor/register')) return null; // allow vendor register without login
        return '/login';
      }

      // Logged in — block cross-role access
      final isCustomerRoute = path.startsWith('/customer');
      final isVendorRoute = path.startsWith('/vendor') && !path.startsWith('/vendor/register');
      final isAdminRoute = path.startsWith('/admin');

      if (accountType == 'customer' && (isVendorRoute || isAdminRoute)) {
        return '/customer/home';
      }
      if (accountType == 'vendor' && isCustomerRoute) {
        return '/vendor/home';
      }
      if (accountType == 'super_admin' && isCustomerRoute) {
        return '/admin/dashboard';
      }

      return null;
    },
    routes: [
      // ─── Splash ───
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),

      // ─── Auth routes ───
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        name: 'signup',
        builder: (context, state) {
          final data = state.extra as Map<String, dynamic>? ?? {};
          return SignupScreen(accountType: data['accountType'] ?? 'customer');
        },
      ),
      GoRoute(
        path: '/forgot-password',
        name: 'forgotPassword',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/reset-password',
        name: 'resetPassword',
        builder: (context, state) {
          final token = state.uri.queryParameters['token'];
          return ResetPasswordScreen(token: token);
        },
      ),
      GoRoute(
        path: '/email-verification',
        name: 'emailVerification',
        builder: (context, state) => const EmailVerificationScreen(),
      ),

      // ─── Role Selection route ───
      GoRoute(
        path: '/role-select',
        name: 'roleSelect',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const RoleSelectScreen(),
      ),

      // ─── Onboarding routes ───
      GoRoute(
        path: '/onboarding/create-business',
        name: 'createBusiness',
        builder: (context, state) => const CreateBusinessScreen(),
      ),
      GoRoute(
        path: '/onboarding/branch-setup',
        name: 'branchSetup',
        builder: (context, state) => const BranchSetupScreen(),
      ),
      GoRoute(
        path: '/onboarding/menu-setup',
        name: 'menuSetup',
        builder: (context, state) => const MenuSetupScreen(),
      ),
      GoRoute(
        path: '/onboarding/complete',
        name: 'onboardingComplete',
        builder: (context, state) => const OnboardingCompleteScreen(),
      ),

      // ─── Main app shell with bottom navigation ───
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: '/dashboard',
            name: 'dashboard',
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/pos',
            name: 'pos',
            builder: (context, state) => const POSScreen(),
          ),
          GoRoute(
            path: '/kitchen',
            name: 'kitchen',
            builder: (context, state) => const KitchenDisplayScreen(),
          ),
          GoRoute(
            path: '/menu',
            name: 'menu',
            builder: (context, state) => const MenuListScreen(),
          ),
          GoRoute(
            path: '/orders',
            name: 'orders',
            builder: (context, state) => const OrderHistoryScreen(),
          ),
          GoRoute(
            path: '/tables',
            name: 'tables',
            builder: (context, state) => const TableLayoutScreen(),
          ),
          GoRoute(
            path: '/inventory',
            name: 'inventory',
            builder: (context, state) => const InventoryListScreen(),
          ),
          GoRoute(
            path: '/customers',
            name: 'customers',
            builder: (context, state) => const CustomerListScreen(),
          ),
          GoRoute(
            path: '/employees',
            name: 'employees',
            builder: (context, state) => const StaffListScreen(),
          ),
          GoRoute(
            path: '/expenses',
            name: 'expenses',
            builder: (context, state) => const ExpenseListScreen(),
          ),
          GoRoute(
            path: '/reports',
            name: 'reports',
            builder: (context, state) => const ReportsHubScreen(),
          ),
          GoRoute(
            path: '/notifications',
            name: 'notifications',
            builder: (context, state) => const NotificationCenterScreen(),
          ),
          GoRoute(
            path: '/settings',
            name: 'settings',
            builder: (context, state) => const SettingsScreen(),
          ),
          GoRoute(
            path: '/subscription',
            name: 'subscription',
            builder: (context, state) => const SubscriptionScreen(),
          ),
        ],
      ),

      // ─── Customer App routes (no shell — bottom nav is in each screen) ───
      GoRoute(
        path: '/customer/home',
        name: 'customerHome',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const CustomerHomeScreen(),
      ),
      GoRoute(
        path: '/customer/search',
        name: 'customerSearch',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SearchScreen(),
      ),
      GoRoute(
        path: '/customer/cart',
        name: 'customerCart',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const CartScreen(),
      ),
      GoRoute(
        path: '/customer/orders',
        name: 'customerOrders',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const OrdersScreen(),
      ),
      GoRoute(
        path: '/customer/profile',
        name: 'customerProfile',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const CustomerProfileScreen(),
      ),

      // ─── Vendor App (restaurant owner) ───
      GoRoute(
        path: '/vendor/home',
        name: 'vendorHome',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const VendorHomeScreen(),
      ),
      GoRoute(
        path: '/vendor/menu',
        name: 'vendorMenu',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const VendorMenuScreen(),
      ),
      GoRoute(
        path: '/vendor/orders',
        name: 'vendorOrders',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const VendorOrdersScreen(),
      ),
      GoRoute(
        path: '/vendor/analytics',
        name: 'vendorAnalytics',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const VendorAnalyticsScreen(),
      ),
      GoRoute(
        path: '/vendor/profile',
        name: 'vendorProfile',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const VendorProfileScreen(),
      ),

      // ─── Admin App ───
      GoRoute(
        path: '/admin/dashboard',
        name: 'adminDashboard',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const AdminHomeScreen(),
      ),
      GoRoute(
        path: '/admin/restaurants',
        name: 'adminRestaurants',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const AdminRestaurantsScreen(),
      ),
      GoRoute(
        path: '/admin/orders',
        name: 'adminOrders',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const AdminOrdersScreen(),
      ),
      GoRoute(
        path: '/admin/users',
        name: 'adminUsers',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const AdminUsersScreen(),
      ),
      GoRoute(
        path: '/admin/profile',
        name: 'adminProfile',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const AdminProfileScreen(),
      ),

      // ─── Customer App full-screen routes ───

      // POS
      GoRoute(
        path: '/pos/payment',
        name: 'payment',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const PaymentScreen(),
      ),
      GoRoute(
        path: '/orders/:orderId',
        name: 'orderDetail',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => OrderDetailScreen(
          orderId: state.pathParameters['orderId']!,
        ),
      ),

      // Menu
      GoRoute(
        path: '/menu/add-item',
        name: 'addMenuItem',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const AddEditMenuItemScreen(),
      ),
      GoRoute(
        path: '/menu/edit-item/:id',
        name: 'editMenuItem',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => AddEditMenuItemScreen(
          itemId: state.pathParameters['id'],
        ),
      ),
      GoRoute(
        path: '/menu/categories',
        name: 'menuCategories',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const MenuCategoryScreen(),
      ),

      // Inventory
      GoRoute(
        path: '/inventory/suppliers',
        name: 'suppliers',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SupplierListScreen(),
      ),
      GoRoute(
        path: '/inventory/add-supplier',
        name: 'addSupplier',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const AddSupplierScreen(),
      ),
      GoRoute(
        path: '/inventory/stock-adjustment',
        name: 'stockAdjustment',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const StockAdjustmentScreen(),
      ),
      GoRoute(
        path: '/inventory/purchase-orders',
        name: 'purchaseOrders',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const PurchaseOrderListScreen(),
      ),
      GoRoute(
        path: '/inventory/create-po',
        name: 'createPO',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const CreatePurchaseOrderScreen(),
      ),
      GoRoute(
        path: '/inventory/add-item',
        name: 'addInventoryItem',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const AddInventoryItemScreen(),
      ),

      // Customers
      GoRoute(
        path: '/customers/add',
        name: 'addCustomer',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const AddCustomerScreen(),
      ),
      GoRoute(
        path: '/customers/edit/:customerId',
        name: 'editCustomer',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => AddCustomerScreen(
          customerId: state.pathParameters['customerId'],
        ),
      ),
      GoRoute(
        path: '/customers/:customerId',
        name: 'customerDetail',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => CustomerDetailScreen(
          customerId: state.pathParameters['customerId']!,
        ),
      ),

      // Employees
      GoRoute(
        path: '/employees/:staffId',
        name: 'staffDetail',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => StaffDetailScreen(
          staffId: state.pathParameters['staffId']!,
        ),
      ),
      GoRoute(
        path: '/employees/edit/:staffId',
        name: 'editStaff',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => EditStaffScreen(
          staffId: state.pathParameters['staffId']!,
        ),
      ),
      GoRoute(
        path: '/employees/invite',
        name: 'inviteStaff',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const InviteStaffScreen(),
      ),

      // Expenses
      GoRoute(
        path: '/expenses/add',
        name: 'addExpense',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ExpenseDetailScreen(),
      ),
      GoRoute(
        path: '/expenses/:expenseId',
        name: 'expenseDetail',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => ExpenseDetailScreen(
          expenseId: state.pathParameters['expenseId'],
        ),
      ),
      GoRoute(
        path: '/expenses/daily-closing',
        name: 'dailyClosing',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const DailyClosingScreen(),
      ),

      // Reports
      GoRoute(
        path: '/reports/sales',
        name: 'salesReport',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SalesReportScreen(),
      ),
      GoRoute(
        path: '/reports/inventory',
        name: 'inventoryReport',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const InventoryReportScreen(),
      ),
      GoRoute(
        path: '/reports/staff-performance',
        name: 'staffPerformanceReport',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const StaffPerformanceReportScreen(),
      ),
      GoRoute(
        path: '/reports/customer-analytics',
        name: 'customerAnalyticsReport',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const CustomerAnalyticsScreen(),
      ),
      GoRoute(
        path: '/reports/expense',
        name: 'expenseReport',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ExpenseReportScreen(),
      ),
      GoRoute(
        path: '/reports/profit-loss',
        name: 'profitLossReport',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ProfitLossReportScreen(),
      ),

      // Delivery
      GoRoute(
        path: '/delivery',
        name: 'deliveries',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const DeliveryListScreen(),
      ),
      GoRoute(
        path: '/delivery/:deliveryId',
        name: 'deliveryDetail',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => DeliveryDetailScreen(
          deliveryId: state.pathParameters['deliveryId']!,
        ),
      ),
      GoRoute(
        path: '/delivery/riders',
        name: 'riders',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const RiderListScreen(),
      ),
      GoRoute(
        path: '/delivery/riders/add',
        name: 'addRider',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const AddRiderScreen(),
      ),
      GoRoute(
        path: '/delivery/settings',
        name: 'deliverySettings',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const DeliverySettingsScreen(),
      ),

      // Customer App full-screen routes
      GoRoute(
        path: '/customer/food-detail',
        name: 'customerFoodDetail',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final data = state.extra as Map<String, dynamic>? ?? {};
          return FoodDetailScreen(
            name: data['name'] ?? 'Chicken Biryani',
            restaurant: data['restaurant'] ?? 'FoodOS Kitchen',
            restaurantId: data['restaurantId'] ?? '',
            rating: data['rating'] ?? '4.8',
            price: data['price'] ?? 'Rs 300',
            image: data['image'] ?? 'assets/images/biryani.jpg',
            description: data['description'] ?? '',
            category: data['category'] ?? 'Main Course',
            addOns: List<String>.from(data['addOns'] ?? []),
          );
        },
      ),
      GoRoute(
        path: '/customer/order-tracking',
        name: 'customerOrderTracking',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const OrderTrackingScreen(),
      ),
      GoRoute(
        path: '/customer/delivery-addresses',
        name: 'customerDeliveryAddresses',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const DeliveryAddressesScreen(),
      ),
      GoRoute(
        path: '/customer/rating-review',
        name: 'customerRatingReview',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const RatingReviewScreen(),
      ),
      GoRoute(
        path: '/customer/favorites',
        name: 'customerFavorites',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const FavoritesScreen(),
      ),
      GoRoute(
        path: '/customer/onboarding',
        name: 'customerOnboarding',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/customer/food-customization',
        name: 'foodCustomization',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final data = state.extra as Map<String, dynamic>? ?? {};
          return FoodCustomizationScreen(
            name: data['name'] ?? 'Chicken Biryani',
            image: data['image'] ?? 'assets/images/biryani.jpg',
            basePrice: data['price'] ?? 'Rs 300',
          );
        },
      ),
      GoRoute(
        path: '/customer/delivery-instructions',
        name: 'deliveryInstructions',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const DeliveryInstructionsScreen(),
      ),
      GoRoute(
        path: '/customer/tip-rider',
        name: 'tipRider',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const TipRiderScreen(),
      ),
      GoRoute(
        path: '/customer/scheduled-order',
        name: 'scheduledOrder',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ScheduledOrderScreen(),
      ),
      GoRoute(
        path: '/customer/restaurant/:restaurantId',
        name: 'restaurantDetail',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => RestaurantDetailScreen(
          restaurantId: state.pathParameters['restaurantId']!,
        ),
      ),
      GoRoute(
        path: '/customer/food-item/:itemName',
        name: 'foodItemDetail',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final itemName = state.pathParameters['itemName']!;
          final item = state.extra as MenuItem?;
          return FoodItemDetailScreen(itemName: Uri.decodeComponent(itemName), item: item);
        },
      ),

      // Vendor routes
      GoRoute(
        path: '/vendor/register',
        name: 'vendorRegister',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const VendorRegisterScreen(),
      ),
      GoRoute(
        path: '/vendor/dashboard',
        name: 'vendorDashboard',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const VendorDashboardScreen(),
      ),

      // New customer features
      GoRoute(
        path: '/customer/promo-codes',
        name: 'promoCodes',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const PromoCodesScreen(),
      ),
      GoRoute(
        path: '/customer/payment-methods',
        name: 'paymentMethods',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const PaymentMethodsScreen(),
      ),
      GoRoute(
        path: '/customer/notifications',
        name: 'customerNotifications',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const NotificationsScreen(),
      ),

      // Settings
      GoRoute(
        path: '/settings/profile',
        name: 'profile',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/settings/billing',
        name: 'billingHistory',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const BillingHistoryScreen(),
      ),
      GoRoute(
        path: '/settings/change-password',
        name: 'changePassword',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ChangePasswordScreen(),
      ),
      GoRoute(
        path: '/settings/business-info',
        name: 'businessInfo',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const BusinessInfoScreen(),
      ),
      GoRoute(
        path: '/settings/branches',
        name: 'branches',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const BranchesScreen(),
      ),
      GoRoute(
        path: '/settings/tax',
        name: 'taxSettings',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const TaxSettingsScreen(),
      ),
      GoRoute(
        path: '/settings/printer',
        name: 'printerSettings',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const PrinterSettingsScreen(),
      ),
      GoRoute(
        path: '/settings/help',
        name: 'helpCenter',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const HelpCenterScreen(),
      ),
      GoRoute(
        path: '/settings/contact-support',
        name: 'contactSupport',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ContactSupportScreen(),
      ),
      GoRoute(
        path: '/settings/about',
        name: 'about',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const AboutScreen(),
      ),
    ],
  );
});

class MainShell extends StatelessWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _calculateSelectedIndex(context),
        onTap: (index) => _onItemTapped(index, context),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textHint,
        selectedLabelStyle: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.point_of_sale_outlined),
            activeIcon: Icon(Icons.point_of_sale),
            label: 'POS',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.kitchen_outlined),
            activeIcon: Icon(Icons.kitchen),
            label: 'Kitchen',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu_outlined),
            activeIcon: Icon(Icons.restaurant_menu),
            label: 'Menu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz_outlined),
            activeIcon: Icon(Icons.more_horiz),
            label: 'More',
          ),
        ],
      ),
    );
  }

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/dashboard')) return 0;
    if (location.startsWith('/pos')) return 1;
    if (location.startsWith('/kitchen')) return 2;
    if (location.startsWith('/menu')) return 3;
    return 4;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/dashboard');
      case 1:
        context.go('/pos');
      case 2:
        context.go('/kitchen');
      case 3:
        context.go('/menu');
      case 4:
        context.go('/settings');
    }
  }
}

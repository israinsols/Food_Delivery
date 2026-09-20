import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/theme_provider.dart';
import 'core/routing/app_router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: FoodOSApp()));
}

class FoodOSApp extends ConsumerWidget {
  const FoodOSApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);
    final themeState = ref.watch(themeProvider);

    // Update AppColors based on theme
    if (themeState.isDarkMode) {
      AppColors.setDarkMode();
    } else {
      AppColors.setLightMode();
    }

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          title: 'FoodOS',
          debugShowCheckedModeBanner: false,
          theme: themeState.isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme,
          routerConfig: router,
        );
      },
    );
  }
}

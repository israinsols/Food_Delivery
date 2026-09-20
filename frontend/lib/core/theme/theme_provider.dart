import 'package:flutter_riverpod/flutter_riverpod.dart';

// Theme state
class ThemeState {
  final bool isDarkMode;

  const ThemeState({this.isDarkMode = true});

  ThemeState copyWith({bool? isDarkMode}) {
    return ThemeState(isDarkMode: isDarkMode ?? this.isDarkMode);
  }
}

// Theme notifier
class ThemeNotifier extends StateNotifier<ThemeState> {
  ThemeNotifier() : super(const ThemeState());

  void toggleTheme() {
    state = state.copyWith(isDarkMode: !state.isDarkMode);
  }
}

// Provider
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeState>((ref) {
  return ThemeNotifier();
});

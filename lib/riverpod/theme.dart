import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timy_attend/preferences/preferences_theme.dart';

part 'theme.g.dart';

@riverpod
class Theme extends _$Theme {
  @override
  Future<bool> build() async {
    return await ThemePreferences.isDark;
  }

  Future<void> toggleTheme() async {
    final currentState = state.value ?? false;
    final newState = !currentState;

    state = AsyncData(newState);

    await ThemePreferences.setTheme(newState);
  }
}

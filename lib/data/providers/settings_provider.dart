import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Préférences injectées via override dans main.dart (instance déjà chargée,
// main attend SharedPreferences.getInstance avant runApp).
final sharedPrefsProvider = Provider<SharedPreferences>((ref) =>
    throw UnimplementedError('Injecté via override dans main.dart'));

class SettingsState {
  const SettingsState({
    this.themeMode = ThemeMode.light,
    this.lowData = false,
    this.online = true,
    this.onboardingSeen = false,
  });

  final ThemeMode themeMode;
  final bool lowData; // mode bas débit (FR-008.5)
  final bool online; // faux = simulation hors-ligne (démo)
  final bool onboardingSeen;

  SettingsState copyWith({
    ThemeMode? themeMode,
    bool? lowData,
    bool? online,
    bool? onboardingSeen,
  }) =>
      SettingsState(
        themeMode: themeMode ?? this.themeMode,
        lowData: lowData ?? this.lowData,
        online: online ?? this.online,
        onboardingSeen: onboardingSeen ?? this.onboardingSeen,
      );
}

class SettingsNotifier extends Notifier<SettingsState> {
  // Disponible seulement quand le conteneur fournit l'override (tests : null).
  SharedPreferences? _prefs;

  @override
  SettingsState build() {
    try {
      final prefs = ref.watch(sharedPrefsProvider);
      _prefs = prefs;
      final themeIndex = prefs.getInt('themeMode') ?? 0;
      return SettingsState(
        themeMode: (themeIndex >= 0 && themeIndex < ThemeMode.values.length)
            ? ThemeMode.values[themeIndex]
            : ThemeMode.light,
        onboardingSeen: prefs.getBool('onboardingSeen') ?? false,
      );
    } catch (_) {
      // Conteneur sans override (tests) : état par défaut, pas de persistance.
      _prefs = null;
      return const SettingsState();
    }
  }

  void _persistThemeMode(ThemeMode mode) =>
      _prefs?.setInt('themeMode', mode.index);

  void toggleDark(bool value) {
    final mode = value ? ThemeMode.dark : ThemeMode.light;
    _persistThemeMode(mode);
    state = state.copyWith(themeMode: mode);
  }

  void setThemeMode(ThemeMode mode) {
    _persistThemeMode(mode);
    state = state.copyWith(themeMode: mode);
  }

  void toggleLowData(bool value) => state = state.copyWith(lowData: value);
  void setOnline(bool value) => state = state.copyWith(online: value);

  void seenOnboarding() {
    _prefs?.setBool('onboardingSeen', true);
    state = state.copyWith(onboardingSeen: true);
  }
}

final settingsProvider =
    NotifierProvider<SettingsNotifier, SettingsState>(SettingsNotifier.new);

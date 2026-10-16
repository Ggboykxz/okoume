import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  @override
  SettingsState build() => const SettingsState();

  void toggleDark(bool value) => state = state.copyWith(
      themeMode: value ? ThemeMode.dark : ThemeMode.light);
  void setThemeMode(ThemeMode mode) => state = state.copyWith(themeMode: mode);
  void toggleLowData(bool value) => state = state.copyWith(lowData: value);
  void setOnline(bool value) => state = state.copyWith(online: value);
  void seenOnboarding() => state = state.copyWith(onboardingSeen: true);
}

final settingsProvider =
    NotifierProvider<SettingsNotifier, SettingsState>(SettingsNotifier.new);

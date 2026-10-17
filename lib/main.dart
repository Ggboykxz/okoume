import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/format.dart';
import 'data/providers/settings_provider.dart' show sharedPrefsProvider;

Future<void> main() async {
 WidgetsFlutterBinding.ensureInitialized();
 final prefs = await SharedPreferences.getInstance();
 // Premier frame sans attendre l'initialisation des formats de date
 // (formatDate a un repli interne tant que l'init n'est pas prête).
 runApp(ProviderScope(
  overrides: [sharedPrefsProvider.overrideWithValue(prefs)],
  child: const OkoumeApp(),
 ));
 unawaited(initFormats());
}
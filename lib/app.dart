import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'data/providers.dart';
import 'router.dart';

class OkoumeApp extends ConsumerWidget {
 const OkoumeApp({super.key});

 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final router = ref.watch(routerProvider);
  final settings = ref.watch(settingsProvider);
  return MaterialApp.router(
   title: 'Okoumé — Tout le Gabon, dans ma poche',
   debugShowCheckedModeBanner: false,
   theme: AppTheme.light(),
   darkTheme: AppTheme.dark(),
   themeMode: settings.themeMode,
   routerConfig: router,
   locale: const Locale('fr'),
   supportedLocales: const [Locale('fr'), Locale('en')],
   localizationsDelegates: const [
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
   ],
  );
 }
}

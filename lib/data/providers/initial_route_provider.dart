import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Surchargé dans les tests pour démarrer directement sur une route donnée.
final initialRouteProvider = Provider<String>((ref) => '/splash');

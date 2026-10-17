import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models.dart';
import 'settings_provider.dart' show sharedPrefsProvider;

class AuthNotifier extends Notifier<AppUser?> {
  // Disponible seulement quand le conteneur fournit l'override (tests : null).
  SharedPreferences? _prefs;

  /// Construction de l'utilisateur démo, déterministe en (téléphone, rôle).
  /// La restauration se sert de la même fonction que [login] (pas de liste
  /// d'utilisateurs dans Mock).
  static AppUser _create(String phone, UserRole role) {
    return switch (role) {
      UserRole.acheteur => AppUser(
          name: 'Kévin Mbadinga',
          phone: phone,
          role: role,
          emoji: '',
          points: 320,
          balance: 12500,
          kycVerified: true,
          referralCode: 'OKOUME-KEVIN241',
        ),
      UserRole.vendeur => AppUser(
          name: 'TechLibre 241',
          phone: phone,
          role: role,
          emoji: '',
          kycVerified: true,
          referralCode: 'OKOUME-TECH241',
        ),
      UserRole.livreur => AppUser(
          name: 'Marc Ondo',
          phone: phone,
          role: role,
          emoji: '',
          kycVerified: true,
          referralCode: 'OKOUME-MARC241',
        ),
    };
  }

  @override
  AppUser? build() {
    try {
      final prefs = ref.watch(sharedPrefsProvider);
      _prefs = prefs;
      final saved = prefs.getString('authUserId');
      if (saved == null) return null;
      final sep = saved.indexOf('|');
      if (sep <= 0) return null;
      final roleIndex = int.tryParse(saved.substring(0, sep));
      final phone = saved.substring(sep + 1);
      if (roleIndex == null ||
          roleIndex < 0 ||
          roleIndex >= UserRole.values.length ||
          phone.isEmpty) {
        return null;
      }
      return _create(phone, UserRole.values[roleIndex]);
    } catch (_) {
      // Conteneur sans override (tests) : pas de restauraison possible.
      _prefs = null;
      return null;
    }
  }

  // Seuls téléphone + rôle sont persistés (profil démo reconstruit tel quel ;
  // les mises à jour de nom/e-mail/solde restent volatiles par session).
  void _persist() {
    final user = state;
    if (user == null) {
      _prefs?.remove('authUserId');
      return;
    }
    _prefs?.setString('authUserId', '${user.role.index}|${user.phone}');
  }

  void login(String phone, UserRole role) {
    state = _create(phone, role);
    _persist();
  }

  void logout() {
    state = null;
    _persist();
  }

  void switchRole(UserRole role) {
    final user = state;
    if (user == null) return;
    login(user.phone, role);
  }

  void credit(int amount) {
    final user = state;
    if (user == null) return;
    state = user.copyWith(balance: user.balance + amount);
  }

  /// Met à jour le profil (C-09 création / C-17 modification).
  void updateProfile({String? name, String? email, String? city}) {
    final user = state;
    if (user == null) return;
    state = user.copyWith(name: name, email: email, city: city);
  }
}

final authProvider = NotifierProvider<AuthNotifier, AppUser?>(AuthNotifier.new);

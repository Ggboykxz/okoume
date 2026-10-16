import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models.dart';

class AuthNotifier extends Notifier<AppUser?> {
  @override
  AppUser? build() => null;

  void login(String phone, UserRole role) {
    state = switch (role) {
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

  void logout() => state = null;

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

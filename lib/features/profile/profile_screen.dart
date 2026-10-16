import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/art.dart';
import '../../core/format.dart';
import '../../core/theme/app_colors.dart';
import '../../core/ui/common.dart';
import '../../data/models.dart';
import '../../data/providers.dart';
import '../shell/main_shell.dart';
import '../../core/ui/app_icons.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final user = ref.watch(authProvider);
    final settings = ref.watch(settingsProvider);
    final role = user?.role ?? UserRole.acheteur;

    final orders = ref.watch(ordersProvider);
    final wishlistCount = ref.watch(wishlistProvider).length;
    final sellerState = ref.watch(sellerProvider);
    final stats = ref.watch(sellerStatsProvider);
    final livreurState = ref.watch(livreurProvider);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
          children: [
            // ------------------------------------------------------- En-tête
            Row(
              children: [
                Container(
                  width: 74,
                  height: 74,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: ArtPalette.pair(role.index + 2),
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    user?.emoji ?? '🙂',
                    style: const TextStyle(fontSize: 34),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.name ?? 'Invité',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        maskPhone(user?.phone ?? '+241'),
                        style: TextStyle(
                            fontSize: 12.5, color: cs.onSurfaceVariant),
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          Pill(
                            text: '${role.emoji} ${role.label}',
                            color: cs.primary,
                            dense: true,
                          ),
                          if (user?.kycVerified == true)
                            const Pill(
                              text: 'KYC vérifié',
                              color: AppColors.success,
                              icon: AppIcons.verified_user_rounded,
                              dense: true,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                AppIconButton(
                  icon: AppIcons.edit_rounded,
                  size: 38,
                  onTap: () => context.push('/profile/edit'),
                ),
              ],
            ),

            // ------------------------------------------------------- Stats
            const SizedBox(height: 18),
            if (role == UserRole.acheteur)
              Row(
                children: [
                  Expanded(
                    child: StatCard(
                      emoji: '⭐',
                      label: 'Points fidélité',
                      value: '${user?.points ?? 0}',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: StatCard(
                      emoji: '📦',
                      label: 'Commandes',
                      value: '${orders.length}',
                      delta: orders.where((o) => o.status.isActive).isEmpty
                          ? null
                          : '${orders.where((o) => o.status.isActive).length} en cours',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: StatCard(
                      emoji: '❤️',
                      label: 'Favoris',
                      value: '$wishlistCount',
                    ),
                  ),
                ],
              )
            else if (role == UserRole.vendeur)
              Row(
                children: [
                  Expanded(
                    child: StatCard(
                      emoji: '💰',
                      label: 'CA du mois',
                      value: formatXafCompact(stats.monthRevenue),
                      delta: '+18 % vs M-1',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: StatCard(
                      emoji: '🛒',
                      label: 'Commandes',
                      value: '${stats.monthOrders}',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: StatCard(
                      emoji: '📦',
                      label: 'Produits',
                      value: '${sellerState.products.length}',
                    ),
                  ),
                ],
              )
            else
              Row(
                children: [
                  Expanded(
                    child: StatCard(
                      emoji: '💵',
                      label: 'Gains du jour',
                      value: formatXafCompact(livreurState.gainsToday),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: StatCard(
                      emoji: '🛵',
                      label: 'Courses',
                      value: '${livreurState.history.length}',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: StatCard(
                      emoji: '⭐',
                      label: 'Note',
                      value: '4,9',
                    ),
                  ),
                ],
              ),

            // -------------------------------------------------- Mon compte
            _SectionLabel('Mon compte'),
            AppListTile(
              emoji: '📍',
              title: 'Mes adresses',
              subtitle: 'Livraison et points relais',
              onTap: () => context.push('/addresses'),
            ),
            const SizedBox(height: 10),
            AppListTile(
              emoji: '💳',
              title: 'Moyens de paiement',
              subtitle: 'Airtel Money, Moov, carte…',
              onTap: () => context.push('/payment-methods'),
            ),
            const SizedBox(height: 10),
            AppListTile(
              emoji: '📦',
              title: 'Consignes de retrait',
              subtitle: 'Lockers près de chez vous, moins chers',
              onTap: () => context.push('/lockers'),
            ),
            const SizedBox(height: 10),
            AppListTile(
              emoji: '👛',
              title: 'Portefeuille Okoumé',
              subtitle: ref.watch(authProvider) == null
                  ? 'Rechargez et payez en 1 clic'
                  : 'Solde : ${formatXaf(user?.balance ?? 0)}',
              onTap: () => context.push('/wallet'),
            ),
            const SizedBox(height: 10),
            AppListTile(
              emoji: '❤️',
              title: 'Mes favoris',
              subtitle: '$wishlistCount produit(s) enregistré(s)',
              onTap: () => context.push('/wishlist'),
            ),
            const SizedBox(height: 10),
            AppListTile(
              emoji: '🔔',
              title: 'Notifications',
              subtitle: ref.watch(unreadNotificationsProvider) > 0
                  ? '${ref.watch(unreadNotificationsProvider)} non lue(s) · suivi et promo'
                  : 'Suivi de commandes et promo',
              onTap: () => context.push('/notifications'),
            ),
            const SizedBox(height: 10),
            AppListTile(
              emoji: '⚙️',
              title: 'Paramètres',
              subtitle: 'Thème, données, confidentialité, compte',
              onTap: () => context.push('/settings'),
            ),

            // -------------------------------------------------- Préférences
            _SectionLabel('Préférences'),
            _SwitchTile(
              emoji: '🌙',
              title: 'Mode sombre',
              subtitle: 'Repose les yeux le soir',
              value: settings.themeMode == ThemeMode.dark,
              onChanged: (v) =>
                  ref.read(settingsProvider.notifier).toggleDark(v),
            ),
            const SizedBox(height: 10),
            _SwitchTile(
              emoji: '📶',
              title: 'Mode bas débit',
              subtitle: 'Images allégées pour économiser la data',
              value: settings.lowData,
              onChanged: (v) =>
                  ref.read(settingsProvider.notifier).toggleLowData(v),
            ),
            const SizedBox(height: 10),
            _SwitchTile(
              emoji: '📴',
              title: 'Simuler hors ligne',
              subtitle: 'Testez l\'expérience sans connexion (démo)',
              value: !settings.online,
              onChanged: (v) =>
                  ref.read(settingsProvider.notifier).setOnline(!v),
            ),

            // ------------------------------------------------------- Aide
            _SectionLabel('Aide & démo'),
            AppListTile(
              emoji: '🏪',
              title: role == UserRole.vendeur
                  ? 'Mon espace vendeur'
                  : 'Devenir vendeur',
              subtitle: role == UserRole.vendeur
                  ? 'Tableau de bord, finance et vente rapide'
                  : 'Ouvrez votre boutique en quelques minutes (V-01 → V-08)',
              onTap: () {
                if (role == UserRole.vendeur) {
                  shellTabNotifier.value = 0;
                } else {
                  context.push('/seller/join');
                }
              },
              trailing: const AppIcon(AppIcons.chevron_right_rounded),
            ),
            const SizedBox(height: 10),
            AppListTile(
              emoji: '🛵',
              title: role == UserRole.livreur
                  ? 'Mon espace livreur'
                  : 'Devenir livreur',
              subtitle: role == UserRole.livreur
                  ? 'Courses, portefeuille et historique'
                  : 'Livrez à votre rythme, quiz de formation inclus',
              onTap: () {
                if (role == UserRole.livreur) {
                  shellTabNotifier.value = 0;
                } else {
                  context.push('/livreur/join');
                }
              },
              trailing: const AppIcon(AppIcons.chevron_right_rounded),
            ),
            const SizedBox(height: 10),
            AppListTile(
              emoji: '🗂️',
              title: 'Index des écrans (317)',
              subtitle: 'Catalogue officiel du CDC — écrans réels et aperçus démo',
              trailing: const AppIcon(AppIcons.chevron_right_rounded),
              onTap: () => context.push('/screens'),
            ),
            const SizedBox(height: 10),
            AppListTile(
              emoji: '🎧',
              title: 'Centre d\'aide',
              subtitle: 'FAQ, litiges, remboursements',
              trailing: const AppIcon(AppIcons.chevron_right_rounded),
              onTap: () => context.push('/help'),
            ),
            const SizedBox(height: 10),
            AppListTile(
              emoji: '📜',
              title: 'Conditions générales',
              subtitle: 'Version 1.0 · mai 2026',
              trailing: const AppIcon(AppIcons.chevron_right_rounded),
              onTap: () => context.push('/legal/terms'),
            ),
            const SizedBox(height: 10),
            AppListTile(
              emoji: 'ℹ️',
              title: 'À propos d\'Okoumé',
              subtitle: 'Version, équipe, licences',
              trailing: const AppIcon(AppIcons.chevron_right_rounded),
              onTap: () => context.push('/about'),
            ),

            // ------------------------------------------------ Changement de rôle
            _SectionLabel('Mode démo'),
            AppCard(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Changer de rôle instantanément',
                    style:
                        TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Explorez l\'app en tant qu\'acheteur, vendeur ou livreur.',
                    style:
                        TextStyle(fontSize: 12, color: cs.onSurfaceVariant),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final r in UserRole.values)
                        AppChip(
                          label: '${r.emoji} ${r.label}',
                          selected: role == r,
                          onTap: () {
                            ref.read(authProvider.notifier).switchRole(r);
                            shellTabNotifier.value = 0;
                            showAppSnack(
                              context,
                              'Vous naviguez en tant que ${r.label.toLowerCase()}',
                              emoji: r.emoji,
                            );
                          },
                        ),
                    ],
                  ),
                ],
              ),
            ),

            // ---------------------------------------------------- Déconnexion
            const SizedBox(height: 24),
            AppButton(
              label: 'Se déconnecter',
              variant: AppButtonVariant.danger,
              icon: AppIcons.logout_rounded,
              onPressed: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Se déconnecter ?'),
                    content: const Text(
                        'Vous devrez saisir à nouveau votre numéro pour vous reconnecter.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('Annuler'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text('Se déconnecter',
                            style: TextStyle(color: AppColors.danger)),
                      ),
                    ],
                  ),
                );
                if (confirmed == true && context.mounted) {
                  ref.read(authProvider.notifier).logout();
                  shellTabNotifier.value = 0;
                  context.go('/auth');
                }
              },
            ),
            const SizedBox(height: 16),
            Text(
              'Okoumé v1.0.0 · Fait au Gabon 🇬🇦\nTout le Gabon, dans ma poche.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 11.5, color: cs.onSurfaceVariant, height: 1.6),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 24, 4, 10),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.8,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  const _SwitchTile({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String emoji;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: cs.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Text(emoji, style: const TextStyle(fontSize: 17)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 1),
                Text(subtitle,
                    style: TextStyle(
                        fontSize: 12, color: cs.onSurfaceVariant)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

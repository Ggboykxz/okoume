import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/ui/app_icons.dart';
import '../../core/ui/common.dart';
import '../../core/ui/motion.dart';

/// A-66 · Consignes / lockers de retrait (+ A-67 : fiche d'une consigne).
class LockersScreen extends StatelessWidget {
  const LockersScreen({super.key});

  static const _lockers = <_Locker>[
    _Locker(
      name: 'Locker Okoumé · Marché Mont-Bouët',
      quartier: 'Mont-Bouët, Libreville',
      distanceKm: 1.2,
      slotsFree: 18,
      slotsTotal: 40,
      hours: '7 h – 20 h',
      openNow: true,
      emoji: '🏬',
      seed: 1,
      fee: 300,
    ),
    _Locker(
      name: 'Locker Okoumé · Glass',
      quartier: 'Glass, Libreville',
      distanceKm: 2.4,
      slotsFree: 6,
      slotsTotal: 32,
      hours: '24 h/24',
      openNow: true,
      emoji: '🏢',
      seed: 2,
      fee: 300,
    ),
    _Locker(
      name: 'Locker Okoumé · Akébé',
      quartier: 'Akébé, Libreville',
      distanceKm: 3.1,
      slotsFree: 0,
      slotsTotal: 24,
      hours: '7 h – 21 h',
      openNow: true,
      emoji: '🏪',
      seed: 3,
      fee: 300,
    ),
    _Locker(
      name: 'Locker Okoumé · Owendo Gare',
      quartier: 'Owendo, Libreville',
      distanceKm: 8.6,
      slotsFree: 12,
      slotsTotal: 30,
      hours: '6 h – 22 h',
      openNow: false,
      emoji: '🚉',
      seed: 4,
      fee: 400,
    ),
    _Locker(
      name: 'Locker Okoumé · Port-Gentil Centre',
      quartier: 'Centre-ville, Port-Gentil',
      distanceKm: 144,
      slotsFree: 21,
      slotsTotal: 36,
      hours: '7 h – 19 h',
      openNow: true,
      emoji: '🏨',
      seed: 5,
      fee: 400,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Consignes de retrait 📦')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        children: [
          const InfoBanner(
            emoji: '💡',
            color: AppColors.primary,
            text:
                'Faites livrer en consigne : vous récupérez votre colis quand vous voulez, avec votre code de retrait. Moins cher qu\'une livraison à domicile.',
          ),
          const SizedBox(height: 14),
          // ------------------------------------------------ « Carte » illustrée
          MotionEnter(
            child: Container(
              height: 130,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0E3A66), Color(0xFF0066CC)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Stack(
                children: [
                  for (var i = 0; i < 5; i++)
                    Positioned(
                      left: 26.0 + i * 74,
                      top: 26.0 + (i % 2) * 34,
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.92),
                              borderRadius: BorderRadius.circular(11),
                            ),
                            child: const AppIcon(AppIcons.lock_rounded,
                                size: 17, color: Color(0xFF0066CC)),
                          ),
                          const SizedBox(height: 3),
                          Container(
                            width: 44,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(99),
                            ),
                          ),
                        ],
                      ),
                    ),
                  Positioned(
                    left: 16,
                    bottom: 12,
                    child: Text(
                      '${_lockers.length} consignes près de vous',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          for (var i = 0; i < _lockers.length; i++) ...[
            MotionEnter(
              order: i,
              child: _LockerCard(
                locker: _lockers[i],
                onTap: () => _showLockerSheet(context, _lockers[i]),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }

  void _showLockerSheet(BuildContext context, _Locker locker) {
    showAppSheet(
      context,
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(locker.emoji, style: const TextStyle(fontSize: 26)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    locker.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              locker.quartier,
              style: TextStyle(
                  fontSize: 12.5,
                  color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 14),
            AppCard(
              child: Column(
                children: [
                  _InfoRow(
                    label: 'Horaires',
                    value: locker.hours,
                  ),
                  const SizedBox(height: 8),
                  _InfoRow(
                    label: 'Casiers libres',
                    value: '${locker.slotsFree} / ${locker.slotsTotal}',
                    valueColor: locker.slotsFree == 0
                        ? AppColors.danger
                        : AppColors.success,
                  ),
                  const SizedBox(height: 8),
                  _InfoRow(
                    label: 'Frais de dépôt',
                    value: '${locker.fee} FCFA',
                  ),
                  const SizedBox(height: 8),
                  const _InfoRow(
                    label: 'Conservation',
                    value: '72 h puis retour vendeur',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const InfoBanner(
              emoji: '🔑',
              color: AppColors.primary,
              text:
                  'Vous recevrez un code à 6 chiffres par SMS dès que le colis est déposé.',
            ),
            const SizedBox(height: 14),
            AppButton(
              label: locker.slotsFree == 0
                  ? 'Consigne pleine — choisir une autre'
                  : 'Choisir cette consigne',
              icon: AppIcons.check_rounded,
              onPressed: locker.slotsFree == 0
                  ? null
                  : () {
                      AppMotion.success();
                      Navigator.of(context).pop();
                      showAppSnack(
                        context,
                        'Consigne sélectionnée pour votre prochaine commande 📦',
                        emoji: '✅',
                      );
                    },
            ),
          ],
        ),
      ),
    );
  }
}

class _LockerCard extends StatelessWidget {
  const _LockerCard({required this.locker, required this.onTap});

  final _Locker locker;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final full = locker.slotsFree == 0;
    return Pressable(
      scale: 0.98,
      child: GestureDetector(
        onTap: () {
          AppMotion.tap();
          onTap();
        },
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: cs.outlineVariant),
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: cs.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                alignment: Alignment.center,
                child:
                    Text(locker.emoji, style: const TextStyle(fontSize: 22)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      locker.name.replaceFirst('Locker Okoumé · ', ''),
                      style: const TextStyle(
                          fontSize: 13.5, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${locker.quartier} · à ${locker.distanceKm.toStringAsFixed(1).replaceAll('.', ',')} km',
                      style: TextStyle(
                          fontSize: 11.5, color: cs.onSurfaceVariant),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Pill(
                          text: full
                              ? 'Pleine'
                              : '${locker.slotsFree} casiers libres',
                          color: full ? AppColors.danger : AppColors.success,
                        ),
                        const SizedBox(width: 6),
                        Pill(
                          text: locker.openNow ? 'Ouvert' : 'Fermé',
                          color: locker.openNow
                              ? AppColors.primary
                              : cs.onSurfaceVariant,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const AppIcon(AppIcons.chevron_right_rounded,
                  size: 20, color: Color(0xFF9AA4B2)),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value, this.valueColor});

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(
          child: Text(label,
              style: TextStyle(fontSize: 12.5, color: cs.onSurfaceVariant)),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}

class _Locker {
  const _Locker({
    required this.name,
    required this.quartier,
    required this.distanceKm,
    required this.slotsFree,
    required this.slotsTotal,
    required this.hours,
    required this.openNow,
    required this.emoji,
    required this.seed,
    required this.fee,
  });

  final String name;
  final String quartier;
  final double distanceKm;
  final int slotsFree;
  final int slotsTotal;
  final String hours;
  final bool openNow;
  final String emoji;
  final int seed;
  final int fee;
}

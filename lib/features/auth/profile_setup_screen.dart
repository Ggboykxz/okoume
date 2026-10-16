import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/ui/app_icons.dart';
import '../../core/ui/common.dart';
import '../../core/ui/motion.dart';
import '../../data/providers.dart';

/// C-09 · Création du profil (première connexion, après OTP).
/// Collecte nom, e-mail et photo — puis enchaîne sur la zone de livraison.
class ProfileSetupScreen extends ConsumerStatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  ConsumerState<ProfileSetupScreen> createState() =>
      _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends ConsumerState<ProfileSetupScreen> {
  late final TextEditingController _name;
  late final TextEditingController _email;

  @override
  void initState() {
    super.initState();
    final user = ref.read(authProvider);
    _name = TextEditingController(text: user?.name ?? '');
    _email = TextEditingController(text: user?.email ?? '');
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    super.dispose();
  }

  void _next() {
    final name = _name.text.trim();
    if (name.length < 3) {
      showAppSnack(context, 'Entrez votre nom complet (3 caractères min.)',
          emoji: '✍🏾');
      return;
    }
    final email = _email.text.trim();
    ref
        .read(authProvider.notifier)
        .updateProfile(name: name, email: email.isEmpty ? null : email);
    AppMotion.tap();
    context.push('/auth/location');
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final user = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Créer mon profil'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(34),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
            child: StepBar(
              steps: const ['Profil', 'Zone', 'Notifs'],
              current: 0,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(22, 18, 22, 28),
          children: [
            // ------------------------------------------------------ Avatar
            MotionEnter(
              child: Center(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 96,
                          height: 96,
                          decoration: BoxDecoration(
                            color: cs.primary.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: cs.primary.withValues(alpha: 0.35),
                                width: 2),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            user?.emoji ?? '🧑🏾',
                            style: const TextStyle(fontSize: 44),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Pressable(
                            scale: 0.9,
                            child: GestureDetector(
                              onTap: () => showAppSnack(
                                context,
                                'Appareil photo simulé en démo 📷 — choisissez un emoji ci-dessous',
                                emoji: '📸',
                              ),
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: cs.primary,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: cs.surface, width: 2.5),
                                ),
                                child: const AppIcon(
                                    AppIcons.photo_camera_rounded,
                                    size: 15,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    TextButton(
                      onPressed: () => showAppSnack(
                        context,
                        'Photo de profil simulée en démo 📷',
                        emoji: '📸',
                      ),
                      child: const Text('Changer la photo'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text('Comment doit-on vous appeler ?',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            AppTextField(
              controller: _name,
              hint: 'Nom complet',
              icon: AppIcons.person_rounded,
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: _email,
              hint: 'E-mail (facultatif)',
              icon: AppIcons.mail_rounded,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: TextEditingController(text: user?.phone ?? ''),
              hint: 'Téléphone',
              icon: AppIcons.phone_rounded,
              readOnly: true,
              onTap: () => showAppSnack(
                context,
                'Numéro vérifié par SMS — modifiable depuis le support',
                emoji: '📱',
              ),
            ),
            const SizedBox(height: 16),
            const InfoBanner(
              emoji: '🔒',
              color: AppColors.primary,
              text:
                  'Votre numéro et votre e-mail restent privés : ils ne sont jamais affichés aux vendeurs ni aux livreurs.',
            ),
            const SizedBox(height: 22),
            AppButton(
              label: 'Continuer',
              icon: AppIcons.arrow_forward_rounded,
              onPressed: _next,
            ),
            const SizedBox(height: 8),
            Center(
              child: TextButton(
                onPressed: () => context.push('/auth/location'),
                child: Text(
                  'Passer cette étape',
                  style: TextStyle(
                      color: cs.onSurfaceVariant,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

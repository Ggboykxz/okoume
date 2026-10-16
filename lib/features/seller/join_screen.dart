import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/ui/app_icons.dart';
import '../../core/ui/common.dart';
import '../../core/ui/motion.dart';
import '../../data/models.dart';
import '../../data/providers.dart';
import '../shell/main_shell.dart';

/// V-01 → V-08 · Devenir vendeur — parcours en 7 étapes + confirmation.
/// Vérifications (KYC, PSP) simulées en démo.
class SellerJoinScreen extends ConsumerStatefulWidget {
 const SellerJoinScreen({super.key});

 @override
 ConsumerState<SellerJoinScreen> createState() => _SellerJoinScreenState();
}

class _SellerJoinScreenState extends ConsumerState<SellerJoinScreen> {
 static const _labels = [
  'Bienvenue',
  'Type',
  'Boutique',
  'Zone',
  'KYC',
  'Paiement',
  'Résumé',
 ];

 int _step = 0;
 SellerType _type = SellerType.commercant;
 final _shopName = TextEditingController();
 final _desc = TextEditingController();
 String? _city;
 bool _cniScanned = false;
 String _payMethod = 'Airtel Money';
 final _payNumber = TextEditingController();
 bool _accepted = false;
 bool _submitted = false;

 @override
 void dispose() {
  _shopName.dispose();
  _desc.dispose();
  _payNumber.dispose();
  super.dispose();
 }

 void _next() {
  // Validations légères par étape.
  switch (_step) {
   case 2:
    if (_shopName.text.trim().length < 3) {
     showAppSnack(context, 'Donnez un nom à votre boutique (3 car. min)',
       emoji: '');
     return;
    }
   case 3:
    if (_city == null) {
     showAppSnack(context, 'Choisissez votre ville', emoji: '');
     return;
    }
   case 4:
    if (!_cniScanned) {
     showAppSnack(context, 'Scannez votre pièce d\'identité pour continuer',
       emoji: '');
     return;
    }
   case 5:
    if (_payNumber.text.trim().length < 9) {
     showAppSnack(context, 'Entrez le numéro qui recevra vos versements',
       emoji: '');
     return;
    }
   case 6:
    if (!_accepted) {
     showAppSnack(context, 'Acceptez les conditions vendeur', emoji: '');
     return;
    }
  }
  AppMotion.tap();
  setState(() => _step += 1);
 }

 void _back() {
  if (_step == 0) {
   context.pop();
   return;
  }
  setState(() => _step -= 1);
 }

 void _submit() {
  AppMotion.success();
  setState(() => _submitted = true);
 }

 @override
 Widget build(BuildContext context) {
  final cs = Theme.of(context).colorScheme;

  if (_submitted) return _buildSuccess(cs);

  return Scaffold(
   appBar: AppBar(
    title: const Text('Devenir vendeur'),
    leading: IconButton(
     icon: const AppIcon(AppIcons.arrow_back_rounded),
     onPressed: _back,
    ),
    bottom: PreferredSize(
     preferredSize: const Size.fromHeight(34),
     child: Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      child: StepBar(steps: _labels, current: _step),
     ),
    ),
   ),
   body: SafeArea(
    child: Column(
     children: [
      Expanded(
       child: ListView(
        padding: const EdgeInsets.fromLTRB(22, 16, 22, 20),
        children: [
         MotionEnter(
          key: ValueKey('step-$_step'),
          child: switch (_step) {
           0 => _stepWelcome(cs),
           1 => _stepType(cs),
           2 => _stepShop(cs),
           3 => _stepCity(cs),
           4 => _stepKyc(cs),
           5 => _stepPayment(cs),
           6 => _stepSummary(cs),
           _ => const SizedBox.shrink(),
          },
         ),
        ],
       ),
      ),
      Padding(
       padding: const EdgeInsets.fromLTRB(22, 0, 22, 16),
       child: Column(
        children: [
         AppButton(
          label: _step == 6 ? 'Envoyer ma demande' : 'Continuer',
          icon: _step == 6
            ? AppIcons.send_rounded
            : AppIcons.arrow_forward_rounded,
          onPressed: _step == 6 ? _submit : _next,
         ),
         const SizedBox(height: 4),
         Text(
          'Étape ${_step + 1} sur 7 · vérifications simulées (démo)',
          style:
            TextStyle(fontSize: 11, color: cs.onSurfaceVariant),
         ),
        ],
       ),
      ),
     ],
    ),
   ),
  );
 }

 // ------------------------------------------------------------ V-01 Bienvenue
 Widget _stepWelcome(ColorScheme cs) {
  return Column(
   crossAxisAlignment: CrossAxisAlignment.start,
   children: [
    const Center(child: Text('', style: TextStyle(fontSize: 56))),
    const SizedBox(height: 16),
    Text('Vendez à tout le Gabon 🇬🇦',
      style: Theme.of(context).textTheme.headlineSmall),
    const SizedBox(height: 10),
    Text(
     'Ouvrez votre boutique en quelques minutes et touchez des milliers d\'acheteurs à Libreville, Port-Gentil, Franceville…',
     style:
       TextStyle(fontSize: 13.5, height: 1.5, color: cs.onSurfaceVariant),
    ),
    const SizedBox(height: 18),
    for (final benefit in const [
     ('', 'Visibilité immédiate',
       'Votre boutique apparaît dans les recherches dès la validation.'),
     ('️', 'Paiements sécurisés',
       'Airtel, Moov, carte et cash : l\'argent est protégé par le séquestre.'),
     ('', 'Tableau de bord simple',
       'Ventes, stock, messages et versements au même endroit.'),
     ('🆓', 'Gratuit pour commencer',
       'Aucun abonnement — une commission uniquement sur les ventes.'),
    ]) ...[
     Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
       Text(benefit.$1, style: const TextStyle(fontSize: 20)),
       const SizedBox(width: 10),
       Expanded(
        child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
          Text(benefit.$2,
            style: const TextStyle(
              fontSize: 13.5, fontWeight: FontWeight.w700)),
          const SizedBox(height: 2),
          Text(benefit.$3,
            style: TextStyle(
              fontSize: 12.5,
              height: 1.4,
              color: cs.onSurfaceVariant)),
         ],
        ),
       ),
      ],
     ),
     const SizedBox(height: 14),
    ],
   ],
  );
 }

 // ----------------------------------------------------------------- V-02 Type
 Widget _stepType(ColorScheme cs) {
  return Column(
   crossAxisAlignment: CrossAxisAlignment.start,
   children: [
    Text('Quel type de vendeur êtes-vous ?',
      style: Theme.of(context).textTheme.titleMedium),
    const SizedBox(height: 6),
    Text(
     'Cela détermine les documents demandés et la commission appliquée.',
     style: TextStyle(fontSize: 13, color: cs.onSurfaceVariant),
    ),
    const SizedBox(height: 16),
    for (final entry in const [
     (SellerType.social, '', 'Particulier / Réseaux sociaux',
       'Vous vendez via WhatsApp, TikTok ou Facebook — commission 8 %.'),
     (SellerType.commercant, '', 'Commerçant',
       'Boutique ou marché déclaré — commission 6 %.'),
     (SellerType.artisan, '', 'Artisan',
       'Fabrication locale « Made in Gabon » — commission 5 %.'),
     (SellerType.entreprise, '', 'Entreprise',
       'Société immatriculée avec registre de commerce — commission 4 %.'),
    ]) ...[
     Pressable(
      scale: 0.98,
      child: GestureDetector(
       onTap: () {
        AppMotion.tap();
        setState(() => _type = entry.$1);
       },
       child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
         color: cs.surface,
         borderRadius: BorderRadius.circular(16),
         border: Border.all(
          color: _type == entry.$1 ? cs.primary : cs.outlineVariant,
          width: _type == entry.$1 ? 2 : 1,
         ),
        ),
        child: Row(
         children: [
          Text(entry.$2, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
           child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             Text(entry.$3,
               style: const TextStyle(
                 fontSize: 13.5,
                 fontWeight: FontWeight.w700)),
             const SizedBox(height: 2),
             Text(entry.$4,
               style: TextStyle(
                 fontSize: 12,
                 height: 1.35,
                 color: cs.onSurfaceVariant)),
            ],
           ),
          ),
          if (_type == entry.$1)
           AppIcon(AppIcons.check_circle_rounded,
             size: 20, color: cs.primary),
         ],
        ),
       ),
      ),
     ),
     const SizedBox(height: 10),
    ],
   ],
  );
 }

 // --------------------------------------------------------------- V-03 Boutique
 Widget _stepShop(ColorScheme cs) {
  return Column(
   crossAxisAlignment: CrossAxisAlignment.start,
   children: [
    Text('Parlez-nous de votre boutique',
      style: Theme.of(context).textTheme.titleMedium),
    const SizedBox(height: 14),
    AppTextField(
     controller: _shopName,
     hint: 'Nom de la boutique (ex. TechLibre 241)',
     icon: AppIcons.storefront_rounded,
     textCapitalization: TextCapitalization.words,
    ),
    const SizedBox(height: 12),
    AppTextField(
     controller: _desc,
     hint: 'Description courte : ce que vous vendez, vos points forts…',
     icon: AppIcons.notes_rounded,
     maxLines: 4,
    ),
    const SizedBox(height: 14),
    InfoBanner(
     emoji: '',
     color: cs.primary,
     text:
       'La photo de profil et la bannière s\'ajoutent depuis votre tableau de bord après validation.',
    ),
   ],
  );
 }

 // ----------------------------------------------------------------- V-04 Zone
 Widget _stepCity(ColorScheme cs) {
  final cities = ref.watch(citiesProvider);
  return Column(
   crossAxisAlignment: CrossAxisAlignment.start,
   children: [
    Text('Où êtes-vous installé ?',
      style: Theme.of(context).textTheme.titleMedium),
    const SizedBox(height: 14),
    Wrap(
     spacing: 9,
     runSpacing: 9,
     children: [
      for (final city in cities)
       AppChip(
        label: city,
        selected: _city == city,
        onTap: () {
         AppMotion.tap();
         setState(() => _city = city);
        },
       ),
     ],
    ),
    const SizedBox(height: 16),
    InfoBanner(
     emoji: '',
     color: cs.primary,
     text:
       'Vous pourrez livrer partout au Gabon, mais les commandes « proches de vous » arrivent en premier.',
    ),
   ],
  );
 }

 // ------------------------------------------------------------------ V-05 KYC
 Widget _stepKyc(ColorScheme cs) {
  return Column(
   crossAxisAlignment: CrossAxisAlignment.start,
   children: [
    Text('Vérifions votre identité ',
      style: Theme.of(context).textTheme.titleMedium),
    const SizedBox(height: 6),
    Text(
     'Obligatoire pour protéger acheteurs et vendeurs (conformité). Vos documents restent chiffrés.',
     style: TextStyle(fontSize: 13, color: cs.onSurfaceVariant),
    ),
    const SizedBox(height: 16),
    _KycTile(
     emoji: '',
     title: 'Pièce d\'identité (CNI ou passeport)',
     done: _cniScanned,
     onScan: () {
      AppMotion.tap();
      setState(() => _cniScanned = true);
      showAppSnack(context, 'CNI scannée et lue automatiquement ',
        emoji: '');
     },
    ),
    const SizedBox(height: 10),
    for (final doc in const [
     ('', 'Registre de commerce (commerçant/entreprise)',
       'À fournir après validation, sous 7 jours'),
     ('', 'Selfie de vérification', 'Demandé si la pièce est illisible'),
    ]) ...[
     Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
       color: cs.surface,
       borderRadius: BorderRadius.circular(16),
       border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
       children: [
        Text(doc.$1, style: const TextStyle(fontSize: 20)),
        const SizedBox(width: 12),
        Expanded(
         child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           Text(doc.$2,
             style: const TextStyle(
               fontSize: 13, fontWeight: FontWeight.w700)),
           const SizedBox(height: 2),
           Text(doc.$3,
             style: TextStyle(
               fontSize: 11.5, color: cs.onSurfaceVariant)),
          ],
         ),
        ),
       ],
      ),
     ),
     const SizedBox(height: 10),
    ],
   ],
  );
 }

 // -------------------------------------------------------------- V-06 Paiement
 Widget _stepPayment(ColorScheme cs) {
  final commission = switch (_type) {
   SellerType.social => '8',
   SellerType.commercant => '6',
   SellerType.artisan => '5',
   SellerType.entreprise => '4',
  };
  return Column(
   crossAxisAlignment: CrossAxisAlignment.start,
   children: [
    Text('Où envoyer vos versements ?',
      style: Theme.of(context).textTheme.titleMedium),
    const SizedBox(height: 6),
    Text(
     'Après chaque livraison confirmée, l\'argent en séquestre est versé sur ce compte (J+1 ouvré).',
     style: TextStyle(fontSize: 13, color: cs.onSurfaceVariant),
    ),
    const SizedBox(height: 16),
    Row(
     children: [
      for (final method in const ['Airtel Money', 'Moov Money']) ...[
       Expanded(
        child: Padding(
         padding: const EdgeInsets.only(right: 8),
         child: AppChip(
          label: method,
          selected: _payMethod == method,
          onTap: () {
           AppMotion.tap();
           setState(() => _payMethod = method);
          },
         ),
        ),
       ),
      ],
     ],
    ),
    const SizedBox(height: 14),
    AppTextField(
     controller: _payNumber,
     hint: 'Numéro ${_payMethod == 'Airtel Money' ? 'Airtel' : 'Moov'} (ex. 074 12 34 56)',
     icon: AppIcons.sms_rounded,
     keyboardType: TextInputType.phone,
    ),
    const SizedBox(height: 14),
    InfoBanner(
     emoji: '',
     color: AppColors.success,
     text:
       'Commission $commission % par vente — aucun abonnement. Le séquestre vous protège des impayés.',
    ),
   ],
  );
 }

 // --------------------------------------------------------------- V-07 Résumé
 Widget _stepSummary(ColorScheme cs) {
  final typeLabel = switch (_type) {
   SellerType.social => 'Particulier / réseaux sociaux',
   SellerType.commercant => 'Commerçant',
   SellerType.artisan => 'Artisan',
   SellerType.entreprise => 'Entreprise',
  };
  return Column(
   crossAxisAlignment: CrossAxisAlignment.start,
   children: [
    Text('Vérifiez votre demande',
      style: Theme.of(context).textTheme.titleMedium),
    const SizedBox(height: 14),
    AppCard(
     child: Column(
      children: [
       _SummaryRow(label: 'Type', value: typeLabel),
       const SizedBox(height: 8),
       _SummaryRow(label: 'Boutique', value: _shopName.text.trim()),
       const SizedBox(height: 8),
       _SummaryRow(label: 'Ville', value: _city ?? '—'),
       const SizedBox(height: 8),
       _SummaryRow(
         label: 'KYC',
         value: _cniScanned ? 'CNI vérifiée ' : 'À compléter',
         valueColor:
           _cniScanned ? AppColors.success : AppColors.danger),
       const SizedBox(height: 8),
       _SummaryRow(
         label: 'Versements', value: '$_payMethod · ${_payNumber.text.trim()}'),
      ],
     ),
    ),
    const SizedBox(height: 14),
    Pressable(
     scale: 0.99,
     child: GestureDetector(
      onTap: () {
       AppMotion.tap();
       setState(() => _accepted = !_accepted);
      },
      child: Row(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
        Checkbox(
         value: _accepted,
         activeColor: cs.primary,
         onChanged: (v) =>
           setState(() => _accepted = v ?? false),
        ),
        Expanded(
         child: Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Text.rich(
           TextSpan(
            style: TextStyle(
              fontSize: 12.5,
              height: 1.4,
              color: cs.onSurfaceVariant),
            children: [
             const TextSpan(
               text: 'J\'accepte les conditions vendeur '
                 'Okoumé et je certifie l\'exactitude des informations fournies.'),
            ],
           ),
          ),
         ),
        ),
       ],
      ),
     ),
    ),
   ],
  );
 }

 // -------------------------------------------------------------- V-08 Confirmation
 Widget _buildSuccess(ColorScheme cs) {
  return Scaffold(
   body: SafeArea(
    child: ListView(
     padding: const EdgeInsets.fromLTRB(26, 56, 26, 26),
     children: [
      Center(
       child: MotionEnter(
        child: LottieArt(
         'assets/lottie/success.json',
         size: 140,
         fallback: Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
           color: AppColors.success.withValues(alpha: 0.14),
           shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: const AppIcon(AppIcons.check_rounded,
            size: 52, color: AppColors.success),
         ),
        ),
       ),
      ),
      const SizedBox(height: 22),
      Text(
       'Demande envoyée ! ',
       textAlign: TextAlign.center,
       style: Theme.of(context).textTheme.headlineSmall,
      ),
      const SizedBox(height: 10),
      Text(
       'Notre équipe vérifie votre dossier sous 24 à 48 h. Vous recevrez un SMS à chaque étape. '
       'En attendant, explorez librement l\'espace vendeur en mode démo.',
       textAlign: TextAlign.center,
       style: TextStyle(
         fontSize: 13.5, height: 1.5, color: cs.onSurfaceVariant),
      ),
      const SizedBox(height: 22),
      AppButton(
       label: 'Explorer l\'espace vendeur (démo)',
       icon: AppIcons.storefront_rounded,
       onPressed: () {
        ref.read(authProvider.notifier).switchRole(UserRole.vendeur);
        shellTabNotifier.value = 0;
        context.go('/main');
       },
      ),
      const SizedBox(height: 10),
      AppButton(
       label: 'Retour à mes achats',
       variant: AppButtonVariant.outline,
       onPressed: () => context.go('/main'),
      ),
     ],
    ),
   ),
  );
 }
}

class _KycTile extends StatelessWidget {
 const _KycTile({
  required this.emoji,
  required this.title,
  required this.done,
  required this.onScan,
 });

 final String emoji;
 final String title;
 final bool done;
 final VoidCallback onScan;

 @override
 Widget build(BuildContext context) {
  final cs = Theme.of(context).colorScheme;
  return Container(
   padding: const EdgeInsets.all(14),
   decoration: BoxDecoration(
    color: done ? AppColors.success.withValues(alpha: 0.08) : cs.surface,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(
      color: done ? AppColors.success : cs.outlineVariant,
      width: done ? 1.6 : 1),
   ),
   child: Row(
    children: [
     Text(emoji, style: const TextStyle(fontSize: 22)),
     const SizedBox(width: 12),
     Expanded(
      child: Text(title,
        style: const TextStyle(
          fontSize: 13, fontWeight: FontWeight.w700)),
     ),
     if (done)
      const AppIcon(AppIcons.check_circle_rounded,
        size: 22, color: AppColors.success)
     else
      AppButton(
       label: 'Scanner',
       small: true,
       height: 36,
       expanded: false,
       variant: AppButtonVariant.outline,
       onPressed: onScan,
      ),
    ],
   ),
  );
 }
}

class _SummaryRow extends StatelessWidget {
 const _SummaryRow({required this.label, required this.value, this.valueColor});

 final String label;
 final String value;
 final Color? valueColor;

 @override
 Widget build(BuildContext context) {
  final cs = Theme.of(context).colorScheme;
  return Row(
   crossAxisAlignment: CrossAxisAlignment.start,
   children: [
    SizedBox(
     width: 90,
     child: Text(label,
       style: TextStyle(fontSize: 12.5, color: cs.onSurfaceVariant)),
    ),
    Expanded(
     child: Text(
      value,
      textAlign: TextAlign.end,
      style: TextStyle(
        fontSize: 12.5, fontWeight: FontWeight.w700, color: valueColor),
     ),
    ),
   ],
  );
 }
}

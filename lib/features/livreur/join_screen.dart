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

/// L-01 L-08 Devenir livreur — parcours en 7 étapes avec quiz de
/// formation (L-06). Vérifications (permis, KYC) simulées en démo.
class LivreurJoinScreen extends ConsumerStatefulWidget {
 const LivreurJoinScreen({super.key});

 @override
 ConsumerState<LivreurJoinScreen> createState() => _LivreurJoinScreenState();
}

class _LivreurJoinScreenState extends ConsumerState<LivreurJoinScreen> {
 static const _labels = [
 'Bienvenue',
 'Véhicule',
 'Docs',
 'Zone',
 'Dispos',
 'Quiz',
 'Résumé',
 ];

 int _step = 0;
 VehicleType _vehicle = VehicleType.moto;
 final _plate = TextEditingController();
 bool _permisScanned = false;
 String? _city;
 final _days = <String>{'Lun', 'Mar', 'Mer', 'Jeu', 'Ven'};
 final _slots = <String>{'Matin', 'Après-midi'};
 final _quizCorrect = <int>{};
 bool _accepted = false;
 bool _submitted = false;

 static const _quiz = <(String, List<String>, int)>[
 (
  'Un client ne répond pas au téléphone à la livraison. Que faites-vous ?',
  [
  'Je patiente 2 minutes puis je le rappelle, et je signale client injoignable dans l\'app',
  'Je laisse le colis devant la porte et je pars',
  'J\'ouvre le colis pour vérifier son contenu',
  ],
  0,
 ),
 (
  'Quand faut-il saisir le code de remise du client ?',
  [
  'Avant d\'arriver, pour gagner du temps',
  'Après avoir remis le colis, en présence du client',
  'Jamais — la validation est automatique',
  ],
  1,
 ),
 (
  'Le client propose de payer plus cher hors application pour accélérer. Vous…',
  [
  'Acceptez : c\'est un bonus',
  'Refusez et signalez la demande dans l\'application',
  'Négociez un pourboire en espèces',
  ],
  1,
 ),
 ];

 @override
 void dispose() {
 _plate.dispose();
 super.dispose();
 }

 void _next() {
 switch (_step) {
  case 2:
  if (!_permisScanned) {
   showAppSnack(context, 'Scannez votre permis pour continuer',
    emoji: '');
   return;
  }
  case 3:
  if (_city == null) {
   showAppSnack(context, 'Choisissez votre zone d\'activité',
    emoji: '');
   return;
  }
  case 4:
  if (_days.isEmpty || _slots.isEmpty) {
   showAppSnack(
    context, 'Sélectionnez au moins un jour et un créneau',
    emoji: '');
   return;
  }
  case 5:
  if (_quizCorrect.length < _quiz.length) {
   showAppSnack(
    context,
    'Répondez correctement aux ${_quiz.length} questions du quiz de formation',
    emoji: '');
   return;
  }
  case 6:
  if (!_accepted) {
   showAppSnack(context, 'Acceptez le contrat livreur', emoji: '');
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

 void _answer(int question, int choice, bool correct) {
 if (correct) {
  AppMotion.success();
  setState(() => _quizCorrect.add(question));
  showAppSnack(context, 'Bonne réponse ! ', emoji: '');
 } else {
  AppMotion.warning();
  showAppSnack(
  context,
  'Pas tout à fait — relisez la question et réessayez ',
  emoji: '',
  );
 }
 }

 @override
 Widget build(BuildContext context) {
 final cs = Theme.of(context).colorScheme;

 if (_submitted) return _buildSuccess(cs);

 return Scaffold(
  appBar: AppBar(
  title: const Text('Devenir livreur'),
  leading: IconButton(
   icon: const AppIcon(AppIcons.arrow_back_rounded),
   onPressed: _back,
  ),
  bottom: PreferredSize(
   preferredSize: const Size.fromHeight(34),
   child: Padding(
   padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
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
      1 => _stepVehicle(cs),
      2 => _stepDocs(cs),
      3 => _stepZone(cs),
      4 => _stepAvailability(cs),
      5 => _stepQuiz(cs),
      6 => _stepSummary(cs),
      _ => const SizedBox.shrink(),
     },
     ),
    ],
    ),
   ),
   Padding(
    padding: const EdgeInsets.fromLTRB(22, 16, 22, 16),
    child: Column(
    children: [
     AppButton(
     label: _step == 6 ? 'Envoyer ma candidature' : 'Continuer',
     icon: _step == 6
      ? AppIcons.send_rounded
      : AppIcons.arrow_forward_rounded,
     onPressed: () {
      if (_step == 6) {
      AppMotion.success();
      setState(() => _submitted = true);
      } else {
      _next();
      }
     },
     ),
     const SizedBox(height: 4),
     Text(
     'Étape ${_step + 1} sur 7 permis et documents simulés (démo)',
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

 // ------------------------------------------------------------ L-01 Bienvenue
 Widget _stepWelcome(ColorScheme cs) {
 return Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  const Center(child: Text('', style: TextStyle(fontSize: 56))),
  const SizedBox(height: 16),
  Text('Livrez à votre rythme',
   style: Theme.of(context).textTheme.headlineSmall),
  const SizedBox(height: 10),
  Text(
   'Devenez livreur Okoumé : encaissez des courses près de chez vous et retirez vos gains chaque jour sur Mobile Money.',
   style:
    TextStyle(fontSize: 13.5, height: 1.5, color: cs.onSurfaceVariant),
  ),
  const SizedBox(height: 18),
  for (final benefit in const [
   ('', 'Gains transparents',
    'Chaque course affiche son montant avant d\'accepter. Prime pluie incluse.'),
   ('', '100 % flexible',
    'Connectez-vous quand vous voulez — aucun quota imposé.'),
   ('', 'Retraits J+1',
    'Vos gains arrivent sur Airtel ou Moov Money le lendemain.'),
   ('', 'Assurés à chaque course',
    'Couverture vol et accident pendant les livraisons actives.'),
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

 // ------------------------------------------------------------- L-02 Véhicule
 Widget _stepVehicle(ColorScheme cs) {
 return Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  Text('Quel véhicule utilisez-vous ?',
   style: Theme.of(context).textTheme.titleMedium),
  const SizedBox(height: 14),
  for (final entry in const [
   (VehicleType.moto, '', 'Moto', 'Idéal pour le centre-ville — colis jusqu\'à 15 kg.'),
   (VehicleType.voiture, '', 'Voiture', 'Colis volumineux et courses climatisées.'),
   (VehicleType.camionnette, '', 'Camionnette', 'Meubles et gros électroménager.'),
  ]) ...[
   Pressable(
   scale: 0.98,
   child: GestureDetector(
    onTap: () {
    AppMotion.tap();
    setState(() => _vehicle = entry.$1);
    },
    child: Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
     color: cs.surface,
     borderRadius: BorderRadius.circular(16),
     border: Border.all(
     color: _vehicle == entry.$1
      ? cs.primary
      : cs.outlineVariant,
     width: _vehicle == entry.$1 ? 2 : 1,
     ),
    ),
    child: Row(
     children: [
     Text(entry.$2, style: const TextStyle(fontSize: 26)),
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
     if (_vehicle == entry.$1)
      AppIcon(AppIcons.check_circle_rounded,
       size: 20, color: cs.primary),
     ],
    ),
    ),
   ),
   ),
   const SizedBox(height: 10),
  ],
  const SizedBox(height: 6),
  AppTextField(
   controller: _plate,
   hint: 'Immatriculation (ex. LBV 4821 GA)',
   icon: AppIcons.qr_code_scanner_rounded,
   textCapitalization: TextCapitalization.characters,
  ),
  ],
 );
 }

 // ---------------------------------------------------------------- L-03 Docs
 Widget _stepDocs(ColorScheme cs) {
 return Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  Text('Permis et documents ',
   style: Theme.of(context).textTheme.titleMedium),
  const SizedBox(height: 6),
  Text(
   'Pour la sécurité de tous, nous vérifions votre permis et votre identité. Documents chiffrés, jamais partagés.',
   style: TextStyle(fontSize: 13, color: cs.onSurfaceVariant),
  ),
  const SizedBox(height: 16),
  Container(
   padding: const EdgeInsets.all(14),
   decoration: BoxDecoration(
   color:
    _permisScanned ? AppColors.success.withValues(alpha: 0.08) : cs.surface,
   borderRadius: BorderRadius.circular(16),
   border: Border.all(
    color: _permisScanned ? AppColors.success : cs.outlineVariant,
    width: _permisScanned ? 1.6 : 1,
   ),
   ),
   child: Row(
   children: [
    const Text('', style: TextStyle(fontSize: 22)),
    const SizedBox(width: 12),
    const Expanded(
    child: Text('Permis de conduire (recto/verso)',
     style: TextStyle(
      fontSize: 13, fontWeight: FontWeight.w700)),
    ),
    if (_permisScanned)
    const AppIcon(AppIcons.check_circle_rounded,
     size: 22, color: AppColors.success)
    else
    AppButton(
     label: 'Scanner',
     small: true,
     height: 36,
     expanded: false,
     variant: AppButtonVariant.outline,
     onPressed: () {
     AppMotion.tap();
     setState(() => _permisScanned = true);
     showAppSnack(context, 'Permis lu automatiquement ',
      emoji: '');
     },
    ),
   ],
   ),
  ),
  const SizedBox(height: 10),
  for (final doc in const [
   ('', 'Carte grise (si véhicule motorisé)',
    'À fournir après validation, sous 7 jours'),
   ('', 'Assurance véhicule', 'Valable au moins 3 mois'),
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

 // ---------------------------------------------------------------- L-04 Zone
 Widget _stepZone(ColorScheme cs) {
 final cities = ref.watch(citiesProvider);
 return Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  Text('Où voulez-vous livrer ?',
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
    'Votre zone peut être modifiée à tout moment depuis votre espace livreur.',
  ),
  ],
 );
 }

 // --------------------------------------------------------------- L-05 Dispos
 Widget _stepAvailability(ColorScheme cs) {
 return Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  Text('Quand êtes-vous disponible ?',
   style: Theme.of(context).textTheme.titleMedium),
  const SizedBox(height: 14),
  Text('Jours',
   style: TextStyle(
    fontSize: 12.5,
    fontWeight: FontWeight.w700,
    color: cs.onSurfaceVariant)),
  const SizedBox(height: 8),
  Wrap(
   spacing: 8,
   runSpacing: 8,
   children: [
   for (final day in const [
    'Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim',
   ])
    AppChip(
    label: day,
    selected: _days.contains(day),
    onTap: () {
     AppMotion.tap();
     setState(() {
     if (!_days.add(day)) _days.remove(day);
     });
    },
    ),
   ],
  ),
  const SizedBox(height: 16),
  Text('Créneaux',
   style: TextStyle(
    fontSize: 12.5,
    fontWeight: FontWeight.w700,
    color: cs.onSurfaceVariant)),
  const SizedBox(height: 8),
  Wrap(
   spacing: 8,
   runSpacing: 8,
   children: [
   for (final slot in const ['Matin', 'Après-midi', 'Soir', 'Nuit'])
    AppChip(
    label: slot,
    selected: _slots.contains(slot),
    onTap: () {
     AppMotion.tap();
     setState(() {
     if (!_slots.add(slot)) _slots.remove(slot);
     });
    },
    ),
   ],
  ),
  const SizedBox(height: 16),
  InfoBanner(
   emoji: '',
   color: AppColors.secondary,
   text:
    'Vous recevez les courses uniquement pendant vos créneaux actifs.',
  ),
  ],
 );
 }

 // ---------------------------------------------------------------- L-06 Quiz
 Widget _stepQuiz(ColorScheme cs) {
 return Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  Row(
   children: [
   Text('Formation express ',
    style: Theme.of(context).textTheme.titleMedium),
   const Spacer(),
   Pill(
    text: '${_quizCorrect.length} / ${_quiz.length}',
    color: _quizCorrect.length == _quiz.length
     ? AppColors.success
     : AppColors.warning,
   ),
   ],
  ),
  const SizedBox(height: 6),
  Text(
   'Trois questions pour valider les bons réflexes. Répondez correctement à toutes pour continuer.',
   style: TextStyle(fontSize: 13, color: cs.onSurfaceVariant),
  ),
  const SizedBox(height: 14),
  for (var q = 0; q < _quiz.length; q++) ...[
   Container(
   padding: const EdgeInsets.all(14),
   decoration: BoxDecoration(
    color: cs.surface,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(
    color: _quizCorrect.contains(q)
     ? AppColors.success
     : cs.outlineVariant,
    width: _quizCorrect.contains(q) ? 1.6 : 1,
    ),
   ),
   child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Row(
     crossAxisAlignment: CrossAxisAlignment.start,
     children: [
     Text('${q + 1}.',
      style: const TextStyle(
       fontWeight: FontWeight.w800, fontSize: 13.5)),
     const SizedBox(width: 6),
     Expanded(
      child: Text(
      _quiz[q].$1,
      style: const TextStyle(
       fontSize: 13.5,
       fontWeight: FontWeight.w700,
       height: 1.35),
      ),
     ),
     if (_quizCorrect.contains(q))
      const AppIcon(AppIcons.check_circle_rounded,
       size: 20, color: AppColors.success),
     ],
    ),
    const SizedBox(height: 10),
    for (var c = 0; c < _quiz[q].$2.length; c++)
     Padding(
     padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
     child: Pressable(
      scale: 0.99,
      child: GestureDetector(
      onTap: () => _answer(
       q, c, c == _quiz[q].$3),
      child: Container(
       width: double.infinity,
       padding: const EdgeInsets.symmetric(
        horizontal: 12, vertical: 10),
       decoration: BoxDecoration(
       color: cs.surfaceContainerHigh,
       borderRadius: BorderRadius.circular(12),
       ),
       child: Text(
       _quiz[q].$2[c],
       style: const TextStyle(
        fontSize: 12.5, height: 1.35),
       ),
      ),
      ),
     ),
     ),
    ],
   ),
   ),
   const SizedBox(height: 12),
  ],
  ],
 );
 }

 // --------------------------------------------------------------- L-07 Résumé
 Widget _stepSummary(ColorScheme cs) {
 final vehicleLabel = switch (_vehicle) {
  VehicleType.moto => 'Moto ',
  VehicleType.voiture => 'Voiture ',
  VehicleType.camionnette => 'Camionnette ',
 };
 return Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  Text('Vérifiez votre candidature',
   style: Theme.of(context).textTheme.titleMedium),
  const SizedBox(height: 14),
  AppCard(
   child: Column(
   children: [
    _SummaryRow(label: 'Véhicule', value: vehicleLabel),
    const SizedBox(height: 8),
    _SummaryRow(
     label: 'Immatriculation',
     value: _plate.text.trim().isEmpty
      ? '—'
      : _plate.text.trim()),
    const SizedBox(height: 8),
    _SummaryRow(
     label: 'Permis',
     value: _permisScanned ? 'Vérifié ' : 'À scanner',
     valueColor: _permisScanned
      ? AppColors.success
      : AppColors.danger),
    const SizedBox(height: 8),
    _SummaryRow(label: 'Zone', value: _city ?? '—'),
    const SizedBox(height: 8),
    _SummaryRow(
     label: 'Disponibilités',
     value: '${_days.length} jours ${_slots.length} créneaux'),
    const SizedBox(height: 8),
    const _SummaryRow(
     label: 'Formation', value: 'Quiz réussi ',
     valueColor: AppColors.success),
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
     onChanged: (v) => setState(() => _accepted = v ?? false),
    ),
    Expanded(
     child: Padding(
     padding: const EdgeInsets.only(top: 12),
     child: Text(
      'J\'accepte le contrat livreur Okoumé : ponctualité, respect du client, '
      'code de remise obligatoire et interdiction de tout paiement hors application.',
      style: TextStyle(
       fontSize: 12.5,
       height: 1.4,
       color: cs.onSurfaceVariant),
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

 // ------------------------------------------------------------ L-08 Confirmation
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
    'Candidature envoyée ! ',
    textAlign: TextAlign.center,
    style: Theme.of(context).textTheme.headlineSmall,
   ),
   const SizedBox(height: 10),
   Text(
    'Vérification sous 24 à 48 h (permis + identité). Vous serez notifié par SMS. '
    'Découvrez l\'espace livreur en mode démo dès maintenant.',
    textAlign: TextAlign.center,
    style: TextStyle(
     fontSize: 13.5, height: 1.5, color: cs.onSurfaceVariant),
   ),
   const SizedBox(height: 22),
   AppButton(
    label: 'Explorer l\'espace livreur (démo)',
    icon: AppIcons.local_shipping_rounded,
    onPressed: () {
    ref.read(authProvider.notifier).switchRole(UserRole.livreur);
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
   width: 110,
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

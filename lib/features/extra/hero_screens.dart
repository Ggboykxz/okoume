import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/art.dart';
import '../../core/format.dart';
import '../../core/theme/app_colors.dart';
import '../../core/ui/app_icons.dart';
import '../../core/ui/common.dart';
import '../../core/ui/motion.dart';
import '../../data/providers.dart';

// ═══════════════════════════════════════════════════════════════════════════
// Écrans vedette — implémentations réelles et interactives des écrans
// du catalogue qui ne relèvent pas du MVP strict (C-13, C-45, A-16, A-30,
// A-69, V-35, L-15).
// ═══════════════════════════════════════════════════════════════════════════

/// C-13 Mot de Passe Oublié — réinitialisation par SMS (démo : code 1234).
class ResetPasswordScreen extends StatefulWidget {
 const ResetPasswordScreen({super.key});

 @override
 State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
 final _phone = TextEditingController();
 final _code = TextEditingController();
 final _pass = TextEditingController();
 final _pass2 = TextEditingController();
 int _step = 0;

 @override
 void dispose() {
 _phone.dispose();
 _code.dispose();
 _pass.dispose();
 _pass2.dispose();
 super.dispose();
 }

 void _next() {
 if (_step == 0) {
  if (_phone.text.trim().length < 6) {
  AppMotion.warning();
  showAppSnack(context, 'Entrez votre numéro de téléphone ');
  return;
  }
  AppMotion.tap();
  setState(() => _step = 1);
  showAppSnack(context, 'Code envoyé par SMS — démo : 1234 ');
 } else if (_step == 1) {
  if (_code.text.trim() != '1234') {
  AppMotion.warning();
  showAppSnack(context, 'Code incorrect — essayez 1234 (démo) ');
  return;
  }
  AppMotion.tap();
  setState(() => _step = 2);
 } else {
  if (_pass.text.trim().length < 6 || _pass.text != _pass2.text) {
  AppMotion.warning();
  showAppSnack(context, 'Mots de passe différents ou trop courts ');
  return;
  }
  AppMotion.success();
  showAppSnack(context, 'Mot de passe réinitialisé ! Connectez-vous ');
  if (context.canPop()) context.pop();
 }
 }

 @override
 Widget build(BuildContext context) {
 final cs = Theme.of(context).colorScheme;
 return Scaffold(
  appBar: AppBar(title: const Text('Mot de passe oublié')),
  body: ListView(
  padding: const EdgeInsets.all(20),
  children: [
   MotionEnter(
   child: Container(
    width: 84,
    height: 84,
    decoration: BoxDecoration(
    color: cs.primary.withValues(alpha: 0.10),
    shape: BoxShape.circle,
    ),
    alignment: Alignment.center,
    child: const Text('', style: TextStyle(fontSize: 38)),
   ),
   ),
   const SizedBox(height: 16),
   MotionEnter(
   order: 1,
   child: Text(
    switch (_step) {
    0 => 'Vérifions votre numéro',
    1 => 'Code de vérification',
    _ => 'Nouveau mot de passe',
    },
    textAlign: TextAlign.center,
    style: Theme.of(context).textTheme.titleLarge,
   ),
   ),
   const SizedBox(height: 6),
   MotionEnter(
   order: 2,
   child: Text(
    switch (_step) {
    0 => 'Nous vous enverrons un code par SMS.',
    1 => 'Saisissez le code à 4 chiffres reçu (démo : 1234).',
    _ => 'Choisissez un mot de passe fort (6 caractères min.).',
    },
    textAlign: TextAlign.center,
    style: TextStyle(fontSize: 13, color: cs.onSurfaceVariant),
   ),
   ),
   const SizedBox(height: 22),
   if (_step == 0)
   AppTextField(
    controller: _phone,
    hint: 'Numéro (ex. 074 00 00 00)',
    icon: AppIcons.phone_rounded,
    keyboardType: TextInputType.phone,
   )
   else if (_step == 1)
   AppTextField(
    controller: _code,
    hint: 'Code SMS à 4 chiffres',
    icon: AppIcons.sms_rounded,
    keyboardType: TextInputType.number,
   )
   else ...[
   AppTextField(
    controller: _pass,
    hint: 'Nouveau mot de passe',
    icon: AppIcons.lock_rounded,
    obscure: true,
   ),
   const SizedBox(height: 12),
   AppTextField(
    controller: _pass2,
    hint: 'Confirmer le mot de passe',
    icon: AppIcons.lock_rounded,
    obscure: true,
   ),
   ],
   const SizedBox(height: 22),
   AppButton(
   label: switch (_step) {
    0 => 'Envoyer le code',
    1 => 'Vérifier le code',
    _ => 'Réinitialiser le mot de passe',
   },
   onPressed: _next,
   ),
   const SizedBox(height: 10),
   if (_step == 1)
   TextButton(
    onPressed: () => showAppSnack(
     context, 'Nouveau code envoyé — démo : 1234 '),
    child: const Text('Renvoyer le code'),
   ),
  ],
  ),
 );
 }
}

/// C-45 Recherche Vocale — micro animé + transcription simulée.
class VoiceSearchScreen extends StatefulWidget {
 const VoiceSearchScreen({super.key});

 @override
 State<VoiceSearchScreen> createState() => _VoiceSearchScreenState();
}

class _VoiceSearchScreenState extends State<VoiceSearchScreen> {
 Timer? _timer;
 bool _listening = true;

 static const _transcript = 'écouteurs sans fil';

 @override
 void initState() {
 super.initState();
 if (AppMotion.reduce) {
  _listening = false;
  return;
 }
 _timer = Timer(const Duration(milliseconds: 2400), () {
  if (!mounted) return;
  setState(() => _listening = false);
  AppMotion.success();
 });
 }

 @override
 void dispose() {
 _timer?.cancel();
 super.dispose();
 }

 @override
 Widget build(BuildContext context) {
 final cs = Theme.of(context).colorScheme;
 return Scaffold(
  appBar: AppBar(title: const Text('Recherche vocale')),
  body: Padding(
  padding: const EdgeInsets.all(24),
  child: Column(
   children: [
   const Spacer(),
   LottieArt(
    'assets/lottie/pulse.json',
    size: _listening ? 200 : 120,
    fallback: Container(
    width: 140,
    height: 140,
    decoration: BoxDecoration(
     color: cs.primary.withValues(alpha: 0.12),
     shape: BoxShape.circle,
    ),
    alignment: Alignment.center,
    child: const Text('', style: TextStyle(fontSize: 54)),
    ),
   ),
   const SizedBox(height: 18),
   Text(
    _listening ? 'Parlez maintenant…' : ' $_transcript ',
    textAlign: TextAlign.center,
    style: Theme.of(context).textTheme.titleLarge,
   ),
   const SizedBox(height: 8),
   Text(
    _listening
     ? 'Dites par exemple : écouteurs sans fil '
     : 'Appuyez sur un résultat ou relancez le micro.',
    textAlign: TextAlign.center,
    style: TextStyle(fontSize: 13, color: cs.onSurfaceVariant),
   ),
   const Spacer(),
   if (!_listening) ...[
    Wrap(
    spacing: 8,
    runSpacing: 8,
    alignment: WrapAlignment.center,
    children: [
     for (final s in const [
     'écouteurs sans fil',
     'écouteurs bluetooth',
     'casque audio',
     ])
     AppChip(
      label: s,
      onTap: () => context.push('/search'),
     ),
    ],
    ),
    const SizedBox(height: 14),
   ],
   AppButton(
    label: _listening ? 'Arrêter le micro' : 'Réessayer',
    variant: AppButtonVariant.outline,
    onPressed: () {
    AppMotion.tap();
    if (_listening) {
     _timer?.cancel();
     setState(() => _listening = false);
    } else {
     context.push('/search');
    }
    },
   ),
   ],
  ),
  ),
 );
 }
}

/// A-16/A-18 Galerie Photos plein écran avec zoom (pinch-to-zoom).
class ProductGalleryScreen extends ConsumerStatefulWidget {
 const ProductGalleryScreen({super.key, required this.productId});

 final String productId;

 @override
 ConsumerState<ProductGalleryScreen> createState() =>
  _ProductGalleryScreenState();
}

class _ProductGalleryScreenState extends ConsumerState<ProductGalleryScreen> {
 final _controller = PageController();
 int _page = 0;

 @override
 void dispose() {
 _controller.dispose();
 super.dispose();
 }

 @override
 Widget build(BuildContext context) {
 final product = ref.watch(productByIdProvider(widget.productId));
 if (product == null) {
  return Scaffold(
  appBar: AppBar(),
  body: const EmptyState(
   emoji: '',
   title: 'Produit introuvable',
   message: 'La galerie ne peut pas être affichée.',
  ),
  );
 }
 return Scaffold(
  backgroundColor: Colors.black,
  appBar: AppBar(
  backgroundColor: Colors.black,
  foregroundColor: Colors.white,
  title: Text(
   product.title,
   maxLines: 1,
   overflow: TextOverflow.ellipsis,
   style: const TextStyle(fontSize: 15, color: Colors.white),
  ),
  ),
  body: Column(
  children: [
   Expanded(
   child: PageView.builder(
    controller: _controller,
    itemCount: 4,
    onPageChanged: (i) => setState(() => _page = i),
    itemBuilder: (context, i) => InteractiveViewer(
    maxScale: 4,
    child: Center(
     child: AspectRatio(
     aspectRatio: 1,
     child: Padding(
      padding: const EdgeInsets.all(24),
      child: ProductArt(
      emoji: i == 3 ? '' : product.emoji.isNotEmpty ? product.emoji : '•',
      seed: product.seed + i,
      radius: 22,
      emojiScale: 0.42,
      ),
     ),
     ),
    ),
    ),
   ),
   ),
   const SizedBox(height: 10),
   Row(
   mainAxisAlignment: MainAxisAlignment.center,
   children: [
    for (var i = 0; i < 4; i++)
    Container(
     width: i == _page ? 22 : 8,
     height: 8,
     margin: const EdgeInsets.symmetric(horizontal: 3),
     decoration: BoxDecoration(
     color: i == _page
      ? Colors.white
      : Colors.white.withValues(alpha: 0.35),
     borderRadius: BorderRadius.circular(99),
     ),
    ),
   ],
   ),
   const SizedBox(height: 14),
   SizedBox(
   height: 62,
   child: ListView.separated(
    scrollDirection: Axis.horizontal,
    padding: const EdgeInsets.symmetric(horizontal: 20),
    itemCount: 4,
    separatorBuilder: (_, _) => const SizedBox(width: 10),
    itemBuilder: (context, i) => GestureDetector(
    onTap: () => _controller.animateToPage(
     i,
     duration: AppMotion.smooth,
     curve: Curves.easeOutCubic,
    ),
    child: SizedBox(
     width: 56,
     height: 56,
     child: Opacity(
     opacity: i == _page ? 1 : 0.45,
     child: ProductArt(
      emoji: i == 3 ? '' : product.emoji.isNotEmpty ? product.emoji : '•',
      seed: product.seed + i,
      radius: 12,
     ),
     ),
    ),
    ),
   ),
   ),
   const SizedBox(height: 8),
   Text(
   'Pincez pour zoomer ${_page + 1}/4',
   style: TextStyle(
    color: Colors.white.withValues(alpha: 0.7),
    fontSize: 12,
   ),
   ),
   const SizedBox(height: 16),
  ],
  ),
 );
 }
}

/// A-30 Comparer Produits — jusqu'à 3 produits côte à côte.
class CompareScreen extends ConsumerStatefulWidget {
 const CompareScreen({super.key});

 @override
 ConsumerState<CompareScreen> createState() => _CompareScreenState();
}

class _CompareScreenState extends ConsumerState<CompareScreen> {
 final _selected = <String>[];

 void _toggle(String id) {
 AppMotion.tap();
 setState(() {
  if (_selected.contains(id)) {
  _selected.remove(id);
  } else if (_selected.length < 3) {
  _selected.add(id);
  } else {
  showAppSnack(context, 'Maximum 3 produits à comparer (démo) ');
  }
 });
 }

 @override
 Widget build(BuildContext context) {
 final cs = Theme.of(context).colorScheme;
 final products = ref.watch(catalogProvider).take(10).toList();
 final chosen =
  [for (final p in products) if (_selected.contains(p.id)) p];

 return Scaffold(
  appBar: AppBar(
  title: const Text('Comparer'),
  actions: [
   if (_selected.isNotEmpty)
   TextButton(
    onPressed: () => setState(_selected.clear),
    child: const Text('Tout retirer'),
   ),
  ],
  ),
  body: ListView(
  padding: const EdgeInsets.all(16),
  children: [
   Text(
   'Choisissez jusqu’à 3 produits (${_selected.length}/3)',
   style: TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: cs.onSurfaceVariant,
   ),
   ),
   const SizedBox(height: 10),
   Wrap(
   spacing: 8,
   runSpacing: 8,
   children: [
    for (final p in products)
    AppChip(
     label: '${p.emoji.isNotEmpty ? p.emoji : '•'} ${p.title.split(' ').take(2).join(' ')}',
     selected: _selected.contains(p.id),
     onTap: () => _toggle(p.id),
    ),
   ],
   ),
   const SizedBox(height: 20),
   if (chosen.isEmpty)
   const EmptyState(
    emoji: '',
    title: 'Aucun produit sélectionné',
    message:
     'Touchez des produits ci-dessus pour les comparer côte à côte.',
   )
   else
   _table(chosen, cs),
  ],
  ),
 );
 }

 Widget _table(List<dynamic> chosen, ColorScheme cs) {
 Widget row(String label, List<String> values, {bool bold = false}) {
  return Padding(
  padding: const EdgeInsets.symmetric(vertical: 7),
  child: Row(
   crossAxisAlignment: CrossAxisAlignment.start,
   children: [
   SizedBox(
    width: 84,
    child: Text(
    label,
    style: TextStyle(
     fontSize: 12,
     fontWeight: FontWeight.w700,
     color: cs.onSurfaceVariant,
    ),
    ),
   ),
   for (final v in values)
    Expanded(
    child: Padding(
     padding: const EdgeInsets.only(right: 8),
     child: Text(
     v,
     style: TextStyle(
      fontSize: 12.5,
      fontWeight: bold ? FontWeight.w800 : FontWeight.w500,
     ),
     ),
    ),
    ),
   ],
  ),
  );
 }

 return AppCard(
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
   Row(
   children: [
    const SizedBox(width: 84),
    for (final p in chosen)
    Expanded(
     child: Padding(
     padding: const EdgeInsets.only(right: 8),
     child: Column(
      children: [
      SizedBox(
       width: 54,
       height: 54,
       child: ProductArt(emoji: p.emoji.isNotEmpty ? p.emoji : '•', seed: p.seed, radius: 14),
      ),
      const SizedBox(height: 6),
      Text(
       p.title,
       maxLines: 2,
       overflow: TextOverflow.ellipsis,
       style: const TextStyle(
        fontSize: 11.5, fontWeight: FontWeight.w600),
      ),
      ],
     ),
     ),
    ),
   ],
   ),
   const Divider(height: 24),
   row('Prix', [for (final p in chosen) formatXaf(p.price)], bold: true),
   row('Ancien prix', [
   for (final p in chosen)
    p.oldPrice == null ? '—' : formatXaf(p.oldPrice as int),
   ]),
   row('Note', [
   for (final p in chosen)
    '${(p.rating as double).toStringAsFixed(1).replaceAll('.', ',')} (${p.reviews})',
   ]),
   row('Ventes', [for (final p in chosen) '${p.sold}']),
   row('Stock', [
   for (final p in chosen) p.stock > 0 ? '${p.stock} dispo' : 'Épuisé',
   ]),
   row('Express', [
   for (final p in chosen) p.express ? 'Oui ' : 'Non',
   ]),
   row('Ville', [for (final p in chosen) p.city]),
   row('Vendeur', [
   for (final p in chosen)
    ref.watch(sellerByIdProvider(p.sellerId)).name,
   ]),
  ],
  ),
 );
 }
}

/// A-69/L-21 Scan QR — scanner simulé pour retrait de colis.
class ScanPickupScreen extends StatelessWidget {
 const ScanPickupScreen({super.key});

 @override
 Widget build(BuildContext context) {
 return Scaffold(
  backgroundColor: const Color(0xFF0B0E14),
  appBar: AppBar(
  backgroundColor: const Color(0xFF0B0E14),
  foregroundColor: Colors.white,
  title: const Text('Scan QR Retrait'),
  ),
  body: SafeArea(
  child: Padding(
   padding: const EdgeInsets.all(22),
   child: Column(
   children: [
    const SizedBox(height: 10),
    const Text(
    'Scannez le QR code du colis',
    style: TextStyle(
     color: Colors.white,
     fontSize: 17,
     fontWeight: FontWeight.w700,
    ),
    ),
    const SizedBox(height: 6),
    Text(
    'Visez le QR code collé sur le colis ou présenté par le vendeur.',
    textAlign: TextAlign.center,
    style: TextStyle(
     color: Colors.white.withValues(alpha: 0.65),
     fontSize: 12.5,
    ),
    ),
    const SizedBox(height: 18),
    Expanded(
    child: Center(
     child: LayoutBuilder(
     builder: (context, c) {
      final side = c.maxWidth < c.maxHeight
       ? c.maxWidth
       : c.maxHeight;
      return SizedBox(
      width: side,
      height: side,
      child: Stack(
     children: [
     Positioned.fill(
      child: Container(
      decoration: BoxDecoration(
       color: Colors.white.withValues(alpha: 0.04),
       borderRadius: BorderRadius.circular(24),
       border: Border.all(
        color: Colors.white.withValues(alpha: 0.14)),
      ),
      ),
     ),
     for (final a in const [
      Alignment.topLeft,
      Alignment.topRight,
      Alignment.bottomLeft,
      Alignment.bottomRight,
     ])
      Align(
      alignment: a,
      child: Container(
       width: 42,
       height: 42,
       margin: const EdgeInsets.all(10),
       decoration: BoxDecoration(
       border: Border(
        top: a.y < 0
         ? const BorderSide(
          color: AppColors.primary, width: 4)
         : BorderSide.none,
        bottom: a.y > 0
         ? const BorderSide(
          color: AppColors.primary, width: 4)
         : BorderSide.none,
        left: a.x < 0
         ? const BorderSide(
          color: AppColors.primary, width: 4)
         : BorderSide.none,
        right: a.x > 0
         ? const BorderSide(
          color: AppColors.primary, width: 4)
         : BorderSide.none,
       ),
       ),
      ),
      ),
     if (AppMotion.on(context))
      const _ScanLine()
     else
      Align(
      alignment: Alignment.center,
      child: Container(
       height: 3,
       margin: const EdgeInsets.symmetric(horizontal: 34),
       decoration: BoxDecoration(
       color: AppColors.primary,
       borderRadius: BorderRadius.circular(99),
       ),
      ),
      ),
     const Align(
      alignment: Alignment.center,
      child: Text('', style: TextStyle(fontSize: 64)),
     ),
     ],
      ),
      );
     },
     ),
    ),
    ),
    const SizedBox(height: 16),
    AppButton(
    label: 'Simuler le scan',
    icon: AppIcons.qr_code_scanner_rounded,
    onPressed: () {
     AppMotion.success();
     showAppSheet(
     context,
     Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
       const Text('', style: TextStyle(fontSize: 44)),
       const SizedBox(height: 10),
       Text('Colis OK-2026-0101 identifié',
        style: Theme.of(context).textTheme.titleMedium),
       const SizedBox(height: 6),
       const Text(
       'Locker Total Owendo Case B4\nCode de retrait : 4815',
       textAlign: TextAlign.center,
       style: TextStyle(height: 1.4),
       ),
       const SizedBox(height: 18),
       AppButton(
       label: 'Confirmer le retrait',
       onPressed: () {
        Navigator.of(context).pop();
        AppMotion.success();
        showAppSnack(
         context, 'Colis retiré — merci ! ');
       },
       ),
      ],
      ),
     ),
     );
    },
    ),
    const SizedBox(height: 10),
    AppButton(
    label: 'Saisir le code manuellement',
    variant: AppButtonVariant.outline,
    onPressed: () =>
     showAppSnack(context, 'Saisie manuelle simulée (démo) '),
    ),
   ],
   ),
  ),
  ),
 );
 }
}

class _ScanLine extends StatefulWidget {
 const _ScanLine();

 @override
 State<_ScanLine> createState() => _ScanLineState();
}

class _ScanLineState extends State<_ScanLine>
 with SingleTickerProviderStateMixin {
 late final AnimationController _c = AnimationController(
 vsync: this,
 duration: const Duration(milliseconds: 1800),
 )..repeat(reverse: true);

 @override
 void dispose() {
 _c.dispose();
 super.dispose();
 }

 @override
 Widget build(BuildContext context) {
 return AnimatedBuilder(
  animation: _c,
  builder: (context, _) => Align(
  alignment: Alignment(0, _c.value * 1.7 - 0.85),
  child: Container(
   height: 3,
   margin: const EdgeInsets.symmetric(horizontal: 34),
   decoration: BoxDecoration(
   color: AppColors.primary,
   borderRadius: BorderRadius.circular(99),
   boxShadow: [
    BoxShadow(
    color: AppColors.primary.withValues(alpha: 0.6),
    blurRadius: 12,
    ),
   ],
   ),
  ),
  ),
 );
 }
}

/// V-35 Live Shopping En Direct — diffusion + chat + achat intégré.
class LiveShoppingScreen extends StatefulWidget {
 const LiveShoppingScreen({super.key});

 @override
 State<LiveShoppingScreen> createState() => _LiveShoppingScreenState();
}

class _LiveShoppingScreenState extends State<LiveShoppingScreen> {
 Timer? _timer;
 int _shown = 0;
 int _viewers = 128;

 static const _pool = [
 ('', 'Aline N.', 'C’est trop beau '),
 ('', 'Jean-P.', 'Combien pour livrer à Owendo ?'),
 ('', 'Synthia', 'Je prends le pack complet !'),
 ('', 'Marc', 'Réservez-moi une paire '),
 ];

 @override
 void initState() {
 super.initState();
 if (AppMotion.reduce) {
  _shown = _pool.length;
  return;
 }
 _timer = Timer.periodic(const Duration(seconds: 2), (t) {
  if (!mounted) return;
  setState(() {
  _viewers += 7;
  if (_shown < _pool.length) _shown++;
  if (_shown >= _pool.length) t.cancel();
  });
 });
 }

 @override
 void dispose() {
 _timer?.cancel();
 super.dispose();
 }

 @override
 Widget build(BuildContext context) {
 final cs = Theme.of(context).colorScheme;
 return Scaffold(
  body: Stack(
  children: [
   Positioned.fill(
   child: DecoratedBox(
    decoration: BoxDecoration(
    gradient: LinearGradient(
     begin: Alignment.topCenter,
     end: Alignment.bottomCenter,
     colors: [
     ArtPalette.pair(3).last,
     Colors.black.withValues(alpha: 0.92),
     ],
    ),
    ),
   ),
   ),
   Positioned.fill(
   child: Center(
    child: LottieArt(
    'assets/lottie/pulse.json',
    size: 260,
    fallback: const Text('', style: TextStyle(fontSize: 90)),
    ),
   ),
   ),
   SafeArea(
   child: Column(
    children: [
    Padding(
     padding: const EdgeInsets.fromLTRB(14, 16, 14, 0),
     child: Row(
     children: [
      Container(
      padding: const EdgeInsets.symmetric(
       horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
       color: AppColors.danger,
       borderRadius: BorderRadius.circular(99),
      ),
      child: const Row(
       mainAxisSize: MainAxisSize.min,
       children: [
       _LiveDot(),
       SizedBox(width: 6),
       Text(
        'EN DIRECT',
        style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w800,
        fontSize: 11,
        ),
       ),
       ],
      ),
      ),
      const SizedBox(width: 8),
      Pill(
      text: ' ${_viewers.toString()} spectateurs',
      color: Colors.white,
      dense: true,
      ),
      const Spacer(),
      AppIconButton(
      label: 'Fermer',
      icon: AppIcons.close_rounded,
      onArt: true,
      size: 38,
      onTap: () => context.pop(),
      ),
     ],
     ),
    ),
    const Spacer(),
    Padding(
     padding: const EdgeInsets.fromLTRB(14, 16, 14, 10),
     child: Column(
     crossAxisAlignment: CrossAxisAlignment.start,
     children: [
      for (var i = 0; i < _shown; i++)
      Padding(
       padding: const EdgeInsets.fromLTRB(20, 16, 20, 6),
       child: Row(
       children: [
        Text(_pool[i].$1,
         style: const TextStyle(fontSize: 15)),
        const SizedBox(width: 7),
        Flexible(
        child: Container(
         padding: const EdgeInsets.symmetric(
          horizontal: 10, vertical: 5),
         decoration: BoxDecoration(
         color: Colors.black
          .withValues(alpha: 0.45),
         borderRadius: BorderRadius.circular(99),
         ),
         child: Text(
         '${_pool[i].$2} ${_pool[i].$3}',
         style: const TextStyle(
          color: Colors.white, fontSize: 12),
         maxLines: 1,
         overflow: TextOverflow.ellipsis,
         ),
        ),
        ),
       ],
       ),
      ),
     ],
     ),
    ),
    Container(
     margin: const EdgeInsets.all(12),
     padding: const EdgeInsets.all(12),
     decoration: BoxDecoration(
     color: cs.surface,
     borderRadius: BorderRadius.circular(20),
     ),
     child: Row(
     children: [
      SizedBox(
      width: 58,
      height: 58,
      child: ProductArt(emoji: '', seed: 1, radius: 14),
      ),
      const SizedBox(width: 12),
      Expanded(
      child: Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
       const Text(
        'Écouteurs ProSound — offre live',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
         fontWeight: FontWeight.w700, fontSize: 13),
       ),
       const SizedBox(height: 3),
       Text(
        '${formatXaf(24500)} ${formatXaf(32000)}',
        style: const TextStyle(
        fontWeight: FontWeight.w800,
        color: AppColors.secondary,
        fontSize: 13.5,
        ),
       ),
       ],
      ),
      ),
      AppButton(
      label: 'Acheter',
      small: true,
      expanded: false,
      onPressed: () {
       AppMotion.success();
       context.push('/product/p1');
      },
      ),
     ],
     ),
    ),
    ],
   ),
   ),
  ],
  ),
 );
 }
}

class _LiveDot extends StatelessWidget {
 const _LiveDot();

 @override
 Widget build(BuildContext context) {
 return Container(
  width: 8,
  height: 8,
  decoration: const BoxDecoration(
  color: Colors.white,
  shape: BoxShape.circle,
  ),
 );
 }
}

/// L-15 Carte des Courses — courses disponibles autour du livreur.
class CourierMapScreen extends ConsumerWidget {
 const CourierMapScreen({super.key});

 static const _courses = [
 ('', 'Mont-Bouët Akébé', 4.2, 2500, 23),
 ('', 'Owendo Libreville centre', 6.8, 3200, 31),
 ('', 'Akanda Mont-Bouët', 9.4, 4500, 38),
 ('', 'Bikele Owendo', 5.1, 2800, 26),
 ];

 @override
 Widget build(BuildContext context, WidgetRef ref) {
 final cs = Theme.of(context).colorScheme;
 return Scaffold(
  appBar: AppBar(title: const Text('Carte des courses')),
  body: ListView(
  padding: const EdgeInsets.all(16),
  children: [
   ClipRRect(
   borderRadius: BorderRadius.circular(18),
   child: Container(
    height: 230,
    decoration: BoxDecoration(
    gradient: LinearGradient(
     colors: [
     cs.primary.withValues(alpha: 0.12),
     AppColors.success.withValues(alpha: 0.12),
     ],
     begin: Alignment.topLeft,
     end: Alignment.bottomRight,
    ),
    ),
    child: Stack(
    children: [
     const Align(
     alignment: Alignment(0.1, 0.62),
     child: _Pin(emoji: '', label: 'Vous', highlight: true),
     ),
     const Align(
     alignment: Alignment(-0.5, -0.4),
     child: _Pin(emoji: '', label: 'Mont-Bouët'),
     ),
     const Align(
     alignment: Alignment(0.6, -0.1),
     child: _Pin(emoji: '', label: 'Owendo'),
     ),
     const Align(
     alignment: Alignment(0.35, 0.55),
     child: _Pin(emoji: '', label: 'Akanda'),
     ),
    ],
    ),
   ),
   ),
   const SizedBox(height: 16),
   Row(
   children: [
    Expanded(
    child: Text('Courses disponibles (4)',
     style: Theme.of(context).textTheme.titleMedium),
    ),
    Pill(text: 'Mode disponible', color: AppColors.success, dense: true),
   ],
   ),
   const SizedBox(height: 10),
   for (final c in _courses)
   Padding(
    padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
    child: AppListTile(
    emoji: c.$1,
    title: c.$2,
    subtitle:
     '${c.$3.toString().replaceAll('.', ',')} km ~${c.$5} min ${c.$1 == '' ? 'Voiture' : 'Moto'}',
    trailing: Text(
     formatXaf(c.$4),
     style: const TextStyle(
     fontWeight: FontWeight.w800,
     fontSize: 13,
     color: AppColors.success,
     ),
    ),
    onTap: () {
     AppMotion.tap();
     context.push('/livreur/course');
    },
    ),
   ),
  ],
  ),
 );
 }
}

class _Pin extends StatelessWidget {
 const _Pin({required this.emoji, required this.label, this.highlight = false});

 final String emoji;
 final String label;
 final bool highlight;

 @override
 Widget build(BuildContext context) {
 final cs = Theme.of(context).colorScheme;
 return Column(
  mainAxisSize: MainAxisSize.min,
  children: [
  Container(
   width: highlight ? 46 : 38,
   height: highlight ? 46 : 38,
   decoration: BoxDecoration(
   color: highlight ? cs.primary : cs.surface,
   shape: BoxShape.circle,
   border: Border.all(
    color: highlight ? Colors.white : cs.primary,
    width: 2,
   ),
   boxShadow: [
    BoxShadow(
    color: Colors.black.withValues(alpha: 0.15),
    blurRadius: 8,
    offset: const Offset(0, 3),
    ),
   ],
   ),
   alignment: Alignment.center,
   child: Text(emoji, style: TextStyle(fontSize: highlight ? 20 : 16)),
  ),
  const SizedBox(height: 3),
  Container(
   padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
   decoration: BoxDecoration(
   color: cs.surface,
   borderRadius: BorderRadius.circular(99),
   border: Border.all(color: cs.outlineVariant),
   ),
   child: Text(label,
    style:
     const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700)),
  ),
  ],
 );
 }
}

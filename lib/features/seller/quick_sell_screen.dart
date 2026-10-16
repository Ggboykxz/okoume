import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/art.dart';
import '../../core/theme/app_colors.dart';
import '../../core/ui/common.dart';
import '../../data/models.dart';
import '../../data/providers.dart';
import '../shell/main_shell.dart';
import '../../core/ui/app_icons.dart';

/// Vente rapide : publier un produit en 3 étapes, en moins de 60 secondes.
class QuickSellScreen extends ConsumerStatefulWidget {
  const QuickSellScreen({super.key});

  @override
  ConsumerState<QuickSellScreen> createState() => _QuickSellScreenState();
}

class _QuickSellScreenState extends ConsumerState<QuickSellScreen> {
  static const _emojis = [
    '👗',
    '👟',
    '📱',
    '💻',
    '🎧',
    '💄',
    '🕶️',
    '⌚',
    '🛋️',
    '🪑',
    '🍲',
    '🎣',
    '🏺',
    '🧴',
    '🎸',
    '⚽',
  ];

  int _step = 0;
  String _emoji = '👗';
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _descController = TextEditingController();
  bool _express = true;
  Product? _published;

  int get _seed => _emoji.codeUnits.fold<int>(0, (a, b) => a + b);

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _publish() {
    final title = _titleController.text.trim();
    final price =
        int.tryParse(_priceController.text.replaceAll(RegExp(r'[^0-9]'), ''));
    if (title.length < 3) {
      showAppSnack(context, 'Donnez un titre clair à votre annonce',
          emoji: '✏️');
      return;
    }
    if (price == null || price <= 0) {
      showAppSnack(context, 'Indiquez un prix en FCFA', emoji: '💰');
      return;
    }
    final product = ref.read(sellerProvider.notifier).quickSell(
          title: title,
          price: price,
          emoji: _emoji,
          seed: _seed,
          description: _descController.text.trim().isEmpty
              ? 'Vendu par un vendeur Okoumé — contactez-moi pour plus de détails.'
              : _descController.text.trim(),
          delivery: _express,
        );
    setState(() {
      _published = product;
      _step = 2;
    });
    showAppSnack(context, 'Annonce publiée — elle est déjà visible !',
        emoji: '🚀');
  }

  void _reset() {
    setState(() {
      _published = null;
      _step = 0;
      _emoji = '👗';
      _titleController.clear();
      _priceController.clear();
      _descController.clear();
      _express = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    if (_published != null) {
      return _buildSuccess(cs);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vente rapide'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: Center(
              child: Pill(
                text: '⚡ < 60 s',
                color: AppColors.secondary,
                dense: true,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 6),
            child: StepBar(
              steps: const ['Photo', 'Détails', 'Publié'],
              current: _step,
            ),
          ),
          if (_step == 0) ..._photoStep(cs),
          if (_step == 1) ..._detailsStep(cs),
          if (_step == 2) ..._previewStep(cs),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: cs.surface,
          border: Border(top: BorderSide(color: cs.outlineVariant)),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
            child: Row(
              children: [
                if (_step > 0)
                  Expanded(
                    child: AppButton(
                      label: 'Retour',
                      variant: AppButtonVariant.outline,
                      onPressed: () => setState(() => _step -= 1),
                    ),
                  ),
                if (_step > 0) const SizedBox(width: 10),
                Expanded(
                  flex: _step > 0 ? 2 : 1,
                  child: AppButton(
                    label: _step == 2 ? 'Publier maintenant' : 'Continuer',
                    icon: _step == 2
                        ? AppIcons.rocket_launch_rounded
                        : AppIcons.arrow_forward_rounded,
                    onPressed: () {
                      if (_step < 2) {
                        setState(() => _step += 1);
                      } else {
                        _publish();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _photoStep(ColorScheme cs) {
    return [
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
        child: Center(
          child: SizedBox(
            width: 190,
            height: 190,
            child: ProductArt(
              emoji: _emoji,
              seed: _seed,
              radius: 24,
              emojiScale: 0.45,
            ),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
        child: Text('Simulez votre photo',
            style: Theme.of(context).textTheme.titleMedium),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: GridView.count(
          crossAxisCount: 6,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          children: [
            for (final emoji in _emojis)
              GestureDetector(
                onTap: () => setState(() => _emoji = emoji),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 140),
                  decoration: BoxDecoration(
                    color: _emoji == emoji
                        ? cs.primary.withValues(alpha: 0.12)
                        : cs.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(13),
                    border: Border.all(
                      color: _emoji == emoji ? cs.primary : Colors.transparent,
                      width: 1.6,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(emoji, style: const TextStyle(fontSize: 23)),
                ),
              ),
          ],
        ),
      ),
      const SizedBox(height: 16),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: InfoBanner(
          emoji: '📸',
          text:
              'En production : appareil photo + compression automatique. En mode bas débit, la photo est réduite pour économiser votre forfait.',
          color: cs.primary,
        ),
      ),
    ];
  }

  List<Widget> _detailsStep(ColorScheme cs) {
    return [
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
        child: Row(
          children: [
            SizedBox(
              width: 56,
              height: 56,
              child: ProductArt(
                  emoji: _emoji, seed: _seed, radius: 14, emojiScale: 0.5),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Décrivez votre article en quelques mots',
                style: TextStyle(
                    fontSize: 13, color: cs.onSurfaceVariant, height: 1.4),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 16),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            AppTextField(
              controller: _titleController,
              hint: 'Titre (ex : Robe wax taille M)',
              icon: AppIcons.title_rounded,
              textCapitalization: TextCapitalization.sentences,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 10),
            AppTextField(
              controller: _priceController,
              hint: 'Prix en FCFA (ex : 15000)',
              icon: AppIcons.payments_rounded,
              keyboardType: TextInputType.number,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 10),
            AppTextField(
              controller: _descController,
              hint: 'Description (état, taille, couleur…)',
              icon: AppIcons.notes_rounded,
              maxLines: 3,
            ),
          ],
        ),
      ),
      const SizedBox(height: 6),
      SwitchListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        title: const Text('Livraison express disponible',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        subtitle: const Text('Livré en moins de 2 h en moto',
            style: TextStyle(fontSize: 12)),
        value: _express,
        activeThumbColor: cs.primary,
        onChanged: (v) => setState(() => _express = v),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
        child: InfoBanner(
          emoji: '🛡️',
          color: AppColors.success,
          text:
              'Vendeur vérifié : paiement escrow automatique, aucune démarche à faire.',
        ),
      ),
    ];
  }

  List<Widget> _previewStep(ColorScheme cs) {
    final price =
        int.tryParse(_priceController.text.replaceAll(RegExp(r'[^0-9]'), '')) ??
            0;
    return [
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 10),
        child: Text('Aperçu de votre annonce',
            style: Theme.of(context).textTheme.titleMedium),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: AppCard(
          child: Row(
            children: [
              SizedBox(
                width: 64,
                height: 64,
                child: ProductArt(
                    emoji: _emoji, seed: _seed, radius: 15, emojiScale: 0.5),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _titleController.text.trim().isEmpty
                          ? 'Titre de l\'annonce'
                          : _titleController.text.trim(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    PriceText(price: price, size: 15),
                  ],
                ),
              ),
              Pill(
                text: _express ? '⚡ Express' : '🛵 Standard',
                color: _express ? AppColors.success : cs.onSurfaceVariant,
                dense: true,
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 14),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: AppCard(
          child: Column(
            children: [
              const _CheckRow(text: 'Visible par tous les acheteurs du Gabon'),
              const SizedBox(height: 9),
              const _CheckRow(text: 'Paiement escrow sécurisé'),
              const SizedBox(height: 9),
              _CheckRow(
                  text: _express
                      ? 'Éligible livraison express (< 2 h)'
                      : 'Livraison standard activée'),
              const SizedBox(height: 9),
              const _CheckRow(
                  text: 'Lien de partage WhatsApp généré à la publication'),
            ],
          ),
        ),
      ),
      const SizedBox(height: 14),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: InfoBanner(
          emoji: '⏱',
          color: cs.secondary,
          text:
              'Démo : la publication est instantanée. En production, l\'annonce est en ligne en moins de 60 secondes.',
        ),
      ),
    ];
  }

  Widget _buildSuccess(ColorScheme cs) {
    final product = _published!;
    final link = 'okoume.ga/q/${product.id.substring(product.id.length - 8)}';
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 34, 24, 24),
          children: [
            Center(
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 650),
                curve: Curves.elasticOut,
                builder: (context, value, child) =>
                    Transform.scale(scale: value, child: child),
                child: Container(
                  width: 96,
                  height: 96,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF00E065), Color(0xFF00C853)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const AppIcon(AppIcons.rocket_launch_rounded,
                      size: 44, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text('Votre annonce est en ligne !',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(
              'Partagez le lien sur WhatsApp : vos clients commandent directement dans Okoumé.',
              textAlign: TextAlign.center,
              style:
                  TextStyle(fontSize: 13, height: 1.5, color: cs.onSurfaceVariant),
            ),
            const SizedBox(height: 22),
            AppCard(
              child: Row(
                children: [
                  SizedBox(
                    width: 56,
                    height: 56,
                    child: ProductArt(
                        emoji: product.emoji,
                        seed: product.seed,
                        radius: 14,
                        emojiScale: 0.5),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(product.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 13.5)),
                        const SizedBox(height: 3),
                        PriceText(price: product.price, size: 14),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: cs.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  AppIcon(AppIcons.link_rounded, size: 17, color: cs.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(link,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 13)),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await Clipboard.setData(ClipboardData(text: 'https://$link'));
                      if (!mounted) return;
                      showAppSnack(context, 'Lien copié', emoji: '📋');
                    },
                    child: AppIcon(AppIcons.copy_rounded,
                        size: 18, color: cs.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            AppButton(
              label: 'Partager sur WhatsApp',
              icon: AppIcons.chat_rounded,
              variant: AppButtonVariant.success,
              onPressed: () => showAppSnack(
                  context, 'Partage WhatsApp simulé en démo', emoji: '🟢'),
            ),
            const SizedBox(height: 10),
            AppButton(
              label: 'Voir dans mes produits',
              icon: AppIcons.inventory_2_rounded,
              variant: AppButtonVariant.outline,
              onPressed: () => shellTabNotifier.value = 1,
            ),
            const SizedBox(height: 10),
            AppButton(
              label: 'Vendre autre chose',
              icon: AppIcons.add_rounded,
              variant: AppButtonVariant.ghost,
              onPressed: _reset,
            ),
          ],
        ),
      ),
    );
  }
}

class _CheckRow extends StatelessWidget {
  const _CheckRow({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const AppIcon(AppIcons.check_circle_rounded,
            size: 18, color: AppColors.success),
        const SizedBox(width: 9),
        Expanded(
          child: Text(text,
              style: const TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }
}

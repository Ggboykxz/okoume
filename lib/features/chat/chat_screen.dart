import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/art.dart';
import '../../core/format.dart';
import '../../core/theme/app_colors.dart';
import '../../core/ui/common.dart';
import '../../data/models.dart';
import '../../data/providers.dart';
import '../../core/ui/app_icons.dart';

class ChatScreen extends ConsumerStatefulWidget {
 const ChatScreen({super.key, required this.threadId});

 final String threadId;

 @override
 ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
 final _controller = TextEditingController();

 static const _quickReplies = [
 'C\'est disponible ?',
 'Quel est votre dernier prix ?',
 'Livraison possible demain ?',
 'Pouvez-vous envoyer des photos ?',
 ];

 @override
 void initState() {
 super.initState();
 WidgetsBinding.instance.addPostFrameCallback((_) {
  ref.read(chatProvider.notifier).markRead(widget.threadId);
 });
 }

 @override
 void dispose() {
 _controller.dispose();
 super.dispose();
 }

 void _send() {
 final text = _controller.text.trim();
 if (text.isEmpty) return;
 ref.read(chatProvider.notifier).send(widget.threadId, text: text);
 _controller.clear();
 setState(() {});
 }

 void _proposePrice() {
 final controller = TextEditingController();
 showDialog<void>(
  context: context,
  builder: (context) => AlertDialog(
  title: const Text('Proposer un prix'),
  content: TextField(
   controller: controller,
   keyboardType: TextInputType.number,
   decoration: const InputDecoration(
   hintText: 'Votre offre en FCFA',
   suffixText: 'FCFA',
   ),
  ),
  actions: [
   TextButton(
   onPressed: () => Navigator.of(context).pop(),
   child: const Text('Annuler'),
   ),
   TextButton(
   onPressed: () {
    final amount = int.tryParse(
     controller.text.replaceAll(RegExp(r'[^0-9]'), ''));
    Navigator.of(context).pop();
    if (amount == null || amount <= 0) return;
    ref.read(chatProvider.notifier).send(
     widget.threadId,
     text: formatXaf(amount),
     kind: MessageKind.offer,
     );
   },
   child: const Text('Envoyer'),
   ),
  ],
  ),
 );
 }

 @override
 Widget build(BuildContext context) {
 final cs = Theme.of(context).colorScheme;
 final thread = ref.watch(threadByIdProvider(widget.threadId));
 if (thread == null) {
  return Scaffold(
  appBar: AppBar(),
  body: const EmptyState(
   emoji: '',
   title: 'Conversation introuvable',
  ),
  );
 }
 final seller = ref.watch(sellerByIdProvider(thread.sellerId));

 return Scaffold(
  appBar: AppBar(
  titleSpacing: 0,
  title: Row(
   children: [
   SellerAvatar(
    emoji: seller.emoji.isNotEmpty ? seller.emoji : '•',
    seed: seller.seed,
    size: 36,
    verified: seller.verified),
   const SizedBox(width: 10),
   Expanded(
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
     Text(seller.name,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
       fontWeight: FontWeight.w700, fontSize: 14.5)),
     const SizedBox(height: 1),
     Row(
     children: [
      Container(
      width: 7,
      height: 7,
      decoration: const BoxDecoration(
       color: AppColors.success,
       shape: BoxShape.circle,
      ),
      ),
      const SizedBox(width: 5),
      Text('En ligne répond en ~${seller.responseMin} min',
       style: const TextStyle(
        fontSize: 11, color: AppColors.success)),
     ],
     ),
    ],
    ),
   ),
   ],
  ),
  actions: [
   IconButton(
   icon: const AppIcon(AppIcons.storefront_rounded),
   onPressed: () => context.push('/seller/${seller.id}'),
   ),
   IconButton(
   icon: const AppIcon(AppIcons.more_vert_rounded),
   onPressed: () => showAppSheet(
    context,
    Column(
    mainAxisSize: MainAxisSize.min,
    children: [
     ListTile(
     leading: const AppIcon(AppIcons.storefront_rounded),
     title: const Text('Voir la boutique'),
     onTap: () {
      Navigator.of(context).pop();
      context.push('/seller/${seller.id}');
     },
     ),
     ListTile(
     leading: const AppIcon(AppIcons.flag_rounded,
      color: AppColors.danger),
     title: const Text('Signaler la conversation'),
     onTap: () {
      Navigator.of(context).pop();
      showAppSnack(context, 'Signalement transmis à Okoumé',
       emoji: '');
     },
     ),
     ListTile(
     leading: const AppIcon(AppIcons.block_rounded,
      color: AppColors.danger),
     title: const Text('Bloquer ce vendeur'),
     onTap: () {
      Navigator.of(context).pop();
      showAppSnack(context, '${seller.name} bloqué',
       emoji: '');
     },
     ),
     const SizedBox(height: 10),
    ],
    ),
   ),
   ),
  ],
  ),
  body: Column(
  children: [
   Expanded(
   child: thread.messages.isEmpty
    ? const EmptyState(
     emoji: '',
     title: 'Dites bonjour !',
     message:
      'Négociez le prix, demandez des photos ou la disponibilité.',
     )
    : ListView.builder(
     reverse: true,
     padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
     itemCount: thread.messages.length + 1,
     itemBuilder: (context, i) {
      if (i == thread.messages.length) {
      // Bandeau escrow en haut de conversation.
      return Padding(
       padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
       child: InfoBanner(
       emoji: '',
       text:
        'Gardez les paiements dans Okoumé — jamais de Mobile Money hors application.',
       color: AppColors.success,
       ),
      );
      }
      final message =
       thread.messages[thread.messages.length - 1 - i];
      return _Bubble(message: message);
     },
     ),
   ),
   // ------------------------------------------------- Barre de saisie
   Container(
   decoration: BoxDecoration(
    color: cs.surface,
    border: Border(top: BorderSide(color: cs.outlineVariant)),
   ),
   child: SafeArea(
    top: false,
    child: Column(
    children: [
     SizedBox(
     height: 46,
     child: ListView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(14, 16, 14, 0),
      children: [
      for (final reply in _quickReplies)
       Padding(
       padding: const EdgeInsets.only(right: 8),
       child: AppChip(
        label: reply,
        onTap: () {
        _controller.text = reply;
        setState(() {});
        },
       ),
       ),
      ],
     ),
     ),
     Padding(
     padding: const EdgeInsets.fromLTRB(12, 16, 12, 10),
     child: Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
      GestureDetector(
       onTap: () => showAppSnack(
        context, 'Photos, vocaux et localisation (démo)',
        emoji: ''),
       child: Container(
       width: 44,
       height: 44,
       decoration: BoxDecoration(
        color: cs.surfaceContainerHigh,
        shape: BoxShape.circle,
       ),
       child: AppIcon(AppIcons.add_rounded,
        size: 22, color: cs.onSurfaceVariant),
       ),
      ),
      const SizedBox(width: 8),
      Expanded(
       child: TextField(
       controller: _controller,
       minLines: 1,
       maxLines: 4,
       onSubmitted: (_) => _send(),
       onChanged: (_) => setState(() {}),
       style: const TextStyle(fontSize: 14),
       decoration: InputDecoration(
        hintText: 'Écrivez un message…',
        suffixIcon: IconButton(
        tooltip: 'Proposer un prix',
        icon: AppIcon(AppIcons.sell_rounded,
         size: 20, color: cs.secondary),
        onPressed: _proposePrice,
        ),
       ),
       ),
      ),
      const SizedBox(width: 8),
      GestureDetector(
       onTap: _send,
       child: AnimatedContainer(
       duration: const Duration(milliseconds: 150),
       width: 46,
       height: 46,
       decoration: BoxDecoration(
        color: _controller.text.trim().isEmpty
         ? cs.surfaceContainerHigh
         : cs.primary,
        shape: BoxShape.circle,
       ),
       child: AppIcon(
        AppIcons.send_rounded,
        size: 21,
        color: _controller.text.trim().isEmpty
         ? cs.onSurfaceVariant
         : Colors.white,
       ),
       ),
      ),
      ],
     ),
     ),
    ],
    ),
   ),
   ),
  ],
  ),
 );
 }
}

class _Bubble extends StatelessWidget {
 const _Bubble({required this.message});

 final ChatMessage message;

 @override
 Widget build(BuildContext context) {
 final cs = Theme.of(context).colorScheme;
 final isOffer = message.kind == MessageKind.offer;
 final bg = message.fromMe ? cs.primary : cs.surface;
 final fg = message.fromMe ? Colors.white : cs.onSurface;

 return Align(
  alignment:
   message.fromMe ? Alignment.centerRight : Alignment.centerLeft,
  child: Container(
  constraints: BoxConstraints(
   maxWidth: MediaQuery.sizeOf(context).width * 0.76),
  margin: const EdgeInsets.fromLTRB(20, 16, 20, 10),
  padding: const EdgeInsets.fromLTRB(14, 16, 14, 8),
  decoration: BoxDecoration(
   color: bg,
   borderRadius: BorderRadius.only(
   topLeft: const Radius.circular(18),
   topRight: const Radius.circular(18),
   bottomLeft: Radius.circular(message.fromMe ? 18 : 4),
   bottomRight: Radius.circular(message.fromMe ? 4 : 18),
   ),
   border: message.fromMe
    ? null
    : Border.all(color: cs.outlineVariant),
  ),
  child: Column(
   crossAxisAlignment: CrossAxisAlignment.start,
   children: [
   if (isOffer)
    Padding(
    padding: const EdgeInsets.fromLTRB(20, 16, 20, 6),
    child: Row(
     mainAxisSize: MainAxisSize.min,
     children: [
     const Text('', style: TextStyle(fontSize: 13)),
     const SizedBox(width: 5),
     Text(
      'Proposition de prix',
      style: TextStyle(
      fontSize: 11.5,
      fontWeight: FontWeight.w800,
      color: message.fromMe
       ? Colors.white
       : AppColors.secondary,
      ),
     ),
     ],
    ),
    ),
   Text(
    message.text,
    style: TextStyle(fontSize: 14, height: 1.35, color: fg),
   ),
   const SizedBox(height: 3),
   Row(
    mainAxisSize: MainAxisSize.min,
    children: [
    Text(
     formatTime(message.time),
     style: TextStyle(
     fontSize: 10,
     color: message.fromMe
      ? Colors.white.withValues(alpha: 0.75)
      : cs.onSurfaceVariant,
     ),
    ),
    if (message.fromMe) ...[
     const SizedBox(width: 4),
     AppIcon(
     AppIcons.done_all_rounded,
     size: 13,
     color: message.read
      ? Colors.white
      : Colors.white.withValues(alpha: 0.6),
     ),
    ],
    ],
   ),
   ],
  ),
  ),
 );
 }
}

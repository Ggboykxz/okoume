import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/format.dart';
import '../../core/theme/app_colors.dart';
import '../../core/ui/common.dart';
import '../../data/models.dart';
import '../../data/providers.dart';
import '../../core/ui/app_icons.dart';

class WalletScreen extends ConsumerWidget {
 const WalletScreen({super.key});

 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final cs = Theme.of(context).colorScheme;
  final user = ref.watch(authProvider);
  final txns = ref.watch(walletTxnsProvider);

  return Scaffold(
   appBar: AppBar(title: const Text('Portefeuille Okoumé')),
   body: ListView(
    padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
    children: [
     // ------------------------------------------------------- Solde
     Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
       gradient: const LinearGradient(
        colors: [Color(0xFF0066CC), Color(0xFF003D7A)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
       ),
       borderRadius: BorderRadius.circular(22),
       boxShadow: [
        BoxShadow(
         color: const Color(0xFF0066CC).withValues(alpha: 0.3),
         blurRadius: 20,
         offset: const Offset(0, 10),
        ),
       ],
      ),
      child: Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
        Row(
         children: [
          Text(
           'Solde disponible',
           style: TextStyle(
            color: Colors.white.withValues(alpha: 0.85),
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
           ),
          ),
          const Spacer(),
          Container(
           padding: const EdgeInsets.symmetric(
             horizontal: 9, vertical: 4),
           decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(99),
           ),
           child: const Row(
            children: [
             Text('', style: TextStyle(fontSize: 12)),
             SizedBox(width: 4),
             Text(
              'OKOUME PAY',
              style: TextStyle(
               color: Colors.white,
               fontSize: 9.5,
               fontWeight: FontWeight.w800,
               letterSpacing: 0.8,
              ),
             ),
            ],
           ),
          ),
         ],
        ),
        const SizedBox(height: 6),
        Text(
         formatXaf(user?.balance ?? 0),
         style: const TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w800,
          fontSize: 34,
          color: Colors.white,
         ),
        ),
        const SizedBox(height: 16),
        Row(
         children: [
          Expanded(
           child: GestureDetector(
            onTap: () => _recharge(context, ref),
            child: Container(
             height: 44,
             decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(13),
             ),
             alignment: Alignment.center,
             child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
               AppIcon(AppIcons.add_rounded,
                 size: 18, color: Color(0xFF0066CC)),
               SizedBox(width: 5),
               Text(
                'Recharger',
                style: TextStyle(
                 color: Color(0xFF0066CC),
                 fontWeight: FontWeight.w700,
                 fontSize: 13.5,
                ),
               ),
              ],
             ),
            ),
           ),
          ),
          const SizedBox(width: 10),
          Expanded(
           child: GestureDetector(
            onTap: () => showAppSnack(
              context, 'Paiement par QR code (démo)', emoji: ''),
            child: Container(
             height: 44,
             decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(13),
             ),
             alignment: Alignment.center,
             child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
               AppIcon(AppIcons.qr_code_scanner_rounded,
                 size: 17, color: Colors.white),
               SizedBox(width: 5),
               Text(
                'Payer QR',
                style: TextStyle(
                 color: Colors.white,
                 fontWeight: FontWeight.w700,
                 fontSize: 13.5,
                ),
               ),
              ],
             ),
            ),
           ),
          ),
         ],
        ),
       ],
      ),
     ),

     // ------------------------------------------------- Points fidélité
     const SizedBox(height: 14),
     AppCard(
      child: Row(
       children: [
        const Text('', style: TextStyle(fontSize: 26)),
        const SizedBox(width: 12),
        Expanded(
         child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           Text(
            '${user?.points ?? 0} points fidélité',
            style: const TextStyle(
              fontWeight: FontWeight.w800, fontSize: 14.5),
           ),
           const SizedBox(height: 2),
           Text(
            '10 points = 100 FCFA · valables au checkout',
            style: TextStyle(
              fontSize: 12, color: cs.onSurfaceVariant),
           ),
          ],
         ),
        ),
        Pill(
         text: 'Utiliser',
         color: cs.secondary,
         onTap: () => showAppSnack(
           context, 'Points déduits au prochain paiement (démo)',
           emoji: ''),
        ),
       ],
      ),
     ),

     // --------------------------------------------------- Code parrainage
     const SizedBox(height: 14),
     InfoBanner(
      emoji: '',
      color: cs.secondary,
      text:
        'Parrainez un ami avec le code ${user?.referralCode ?? 'OKOUME-241'} : +1 000 FCFA pour vous deux à sa première commande.',
      trailing: GestureDetector(
       onTap: () => showAppSnack(
         context, 'Code de parrainage copié', emoji: ''),
       child: AppIcon(AppIcons.copy_rounded,
         size: 18, color: cs.secondary),
      ),
     ),

     // ------------------------------------------------------ Historique
     const SizedBox(height: 18),
     Text('Historique', style: Theme.of(context).textTheme.titleMedium),
     const SizedBox(height: 10),
     AppCard(
      child: Column(
       children: [
        for (var i = 0; i < txns.length; i++) ...[
         if (i > 0)
          Divider(height: 20, color: cs.outlineVariant),
         _TxnRow(txn: txns[i]),
        ],
       ],
      ),
     ),
    ],
   ),
  );
 }

 void _recharge(BuildContext context, WidgetRef ref) {
  var amount = 10000;
  var method = PaymentMethod.airtel;
  const amounts = [2000, 5000, 10000, 20000, 50000];

  showAppSheet(
   context,
   StatefulBuilder(
    builder: (context, setSheetState) {
     final cs = Theme.of(context).colorScheme;
     return Padding(
      padding: const EdgeInsets.fromLTRB(22, 0, 22, 24),
      child: Column(
       mainAxisSize: MainAxisSize.min,
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
        Text('Recharger le portefeuille',
          style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 14),
        Wrap(
         spacing: 8,
         runSpacing: 8,
         children: [
          for (final a in amounts)
           AppChip(
            label: formatXaf(a),
            selected: amount == a,
            onTap: () => setSheetState(() => amount = a),
           ),
         ],
        ),
        const SizedBox(height: 18),
        Text('Source',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 13,
            color: cs.onSurfaceVariant)),
        const SizedBox(height: 10),
        Wrap(
         spacing: 8,
         runSpacing: 8,
         children: [
          for (final m in [
           PaymentMethod.airtel,
           PaymentMethod.moov,
           PaymentMethod.carte,
          ])
           AppChip(
            label: '${m.emoji.isNotEmpty ? m.emoji : '•'} ${m.label}',
            selected: method == m,
            color: m.color,
            onTap: () => setSheetState(() => method = m),
           ),
         ],
        ),
        const SizedBox(height: 20),
        AppButton(
         label: 'Recharger ${formatXaf(amount)}',
         icon: AppIcons.add_card_rounded,
         onPressed: () {
          ref.read(authProvider.notifier).credit(amount);
          Navigator.of(context).pop();
          showAppSnack(
            context, 'Portefeuille rechargé !', emoji: '');
         },
        ),
       ],
      ),
     );
    },
   ),
  );
 }
}

class _TxnRow extends StatelessWidget {
 const _TxnRow({required this.txn});

 final WalletTxn txn;

 @override
 Widget build(BuildContext context) {
  final cs = Theme.of(context).colorScheme;
  final positive = txn.amount > 0;
  return Row(
   children: [
    Container(
     width: 40,
     height: 40,
     decoration: BoxDecoration(
      color: cs.surfaceContainerHigh,
      borderRadius: BorderRadius.circular(12),
     ),
     alignment: Alignment.center,
     child: Text(txn.emoji.isNotEmpty ? txn.emoji : '•', style: const TextStyle(fontSize: 17)),
    ),
    const SizedBox(width: 12),
    Expanded(
     child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
       Text(txn.label,
         style: const TextStyle(
           fontWeight: FontWeight.w600, fontSize: 13.5)),
       const SizedBox(height: 2),
       Text(formatDate(txn.date),
         style:
           TextStyle(fontSize: 11.5, color: cs.onSurfaceVariant)),
      ],
     ),
    ),
    Text(
     '${positive ? '+' : '−'} ${formatXaf(txn.amount.abs())}',
     style: TextStyle(
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.w700,
      fontSize: 13.5,
      color: positive ? AppColors.success : AppColors.danger,
     ),
    ),
   ],
  );
 }
}

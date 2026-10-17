import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/format.dart';
import '../../core/theme/app_colors.dart';
import '../../core/ui/common.dart';
import '../../data/models.dart';
import '../../data/providers.dart';
import '../../core/ui/app_icons.dart';

class SellerFinanceScreen extends ConsumerStatefulWidget {
 const SellerFinanceScreen({super.key});

 @override
 ConsumerState<SellerFinanceScreen> createState() =>
   _SellerFinanceScreenState();
}

class _SellerFinanceScreenState extends ConsumerState<SellerFinanceScreen> {
 int _balance = 185000;
 static const _pending = 42500;

 @override
 Widget build(BuildContext context) {
  final cs = Theme.of(context).colorScheme;
  final stats = ref.watch(sellerStatsProvider);

  final history = [
   _Payout('Vente — Samsung Galaxy A15', 42000,
     DateTime.now().subtract(const Duration(hours: 3)), ''),
   _Payout('Vente — Écouteurs JBL', 18500,
     DateTime.now().subtract(const Duration(hours: 8)), ''),
   _Payout('Retrait vers Airtel Money', -50000,
     DateTime.now().subtract(const Duration(days: 1)), ''),
   _Payout('Vente — Montre connectée GT', 27500,
     DateTime.now().subtract(const Duration(days: 2)), ''),
   _Payout('Vente — Chargeur rapide 65W', 6500,
     DateTime.now().subtract(const Duration(days: 3)), ''),
  ];

  return Scaffold(
   appBar: AppBar(title: const Text('Revenus & retraits')),
   body: ListView(
    padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
    children: [
     // -------------------------------------------------------- Solde
     Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
       gradient: LinearGradient(
        colors: [AppColors.successDeep, const Color(0xFF005C26)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
       ),
       borderRadius: BorderRadius.circular(22),
       boxShadow: [
        BoxShadow(
         color: AppColors.success.withValues(alpha: 0.3),
         blurRadius: 20,
         offset: const Offset(0, 10),
        ),
       ],
      ),
      child: Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
        Text(
         'Solde retirable',
         style: TextStyle(
          color: Colors.white.withValues(alpha: 0.85),
          fontSize: 12.5,
          fontWeight: FontWeight.w600,
         ),
        ),
        const SizedBox(height: 6),
        Text(
         formatXaf(_balance),
         style: const TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w800,
          fontSize: 32,
          color: Colors.white,
         ),
        ),
        const SizedBox(height: 14),
        Row(
         children: [
          Expanded(
           child: _MiniInfo(
            label: 'En attente escrow',
            value: formatXaf(_pending),
           ),
          ),
          Expanded(
           child: _MiniInfo(
            label: 'Commission Okoumé',
            value: '5 %',
           ),
          ),
         ],
        ),
        const SizedBox(height: 16),
        GestureDetector(
         onTap: _openWithdraw,
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
            AppIcon(AppIcons.south_west_rounded,
              size: 17, color: Color(0xFF008F3B)),
            SizedBox(width: 6),
            Text(
             'Retirer vers Mobile Money',
             style: TextStyle(
              color: Color(0xFF008F3B),
              fontWeight: FontWeight.w700,
              fontSize: 13.5,
             ),
            ),
           ],
          ),
         ),
        ),
       ],
      ),
     ),

     // ------------------------------------------------------ Stats
     const SizedBox(height: 14),
     Row(
      children: [
       Expanded(
        child: StatCard(
         emoji: '',
         label: 'CA du mois',
         value: formatXafCompact(stats.monthRevenue),
        ),
       ),
       const SizedBox(width: 10),
       Expanded(
        child: StatCard(
         emoji: '',
         label: 'Net encaissé',
         value: formatXafCompact((stats.monthRevenue * 0.95).round()),
        ),
       ),
       const SizedBox(width: 10),
       Expanded(
        child: StatCard(
         emoji: '',
         label: 'Ventes',
         value: '${stats.monthOrders}',
        ),
       ),
      ],
     ),

     // -------------------------------------------------- Historique
     const SizedBox(height: 18),
     Text('Mouvements récents',
       style: Theme.of(context).textTheme.titleMedium),
     const SizedBox(height: 10),
     AppCard(
      child: Column(
       children: [
        for (var i = 0; i < history.length; i++) ...[
         if (i > 0)
          Divider(height: 20, color: cs.outlineVariant),
         Row(
          children: [
           Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
             color: cs.surfaceContainerHigh,
             borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Text(history[i].emoji,
              style: const TextStyle(fontSize: 17)),
           ),
           const SizedBox(width: 12),
           Expanded(
            child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
              Text(history[i].label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13)),
              const SizedBox(height: 2),
              Text(formatDate(history[i].date),
                style: TextStyle(
                  fontSize: 11.5,
                  color: cs.onSurfaceVariant)),
             ],
            ),
           ),
           Text(
            '${history[i].amount >= 0 ? '+' : '−'} ${formatXaf(history[i].amount.abs())}',
            style: TextStyle(
             fontFamily: 'Montserrat',
             fontWeight: FontWeight.w700,
             fontSize: 13.5,
             color: history[i].amount >= 0
               ? AppColors.success
               : AppColors.danger,
            ),
           ),
          ],
         ),
        ],
       ],
      ),
     ),
     const SizedBox(height: 16),
     const InfoBanner(
      emoji: '',
      color: AppColors.success,
      text:
        'Les fonds sous escrow sont automatiquement libérés 24 h après la confirmation de réception par l\'acheteur.',
     ),
    ],
   ),
  );
 }

 void _openWithdraw() {
  var amount = 50000;
  var method = PaymentMethod.airtel;

  showAppSheet(
   context,
   StatefulBuilder(
    builder: (context, setSheetState) {
     final cs = Theme.of(context).colorScheme;
     final amounts = [25000, 50000, 100000]
       .where((a) => a <= _balance)
       .toList();
     if (amount > _balance) amount = _balance;
     return Padding(
      padding: const EdgeInsets.fromLTRB(22, 16, 22, 24),
      child: Column(
       mainAxisSize: MainAxisSize.min,
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
        Text('Retirer des fonds',
          style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 4),
        Text(
         'Solde disponible : ${formatXaf(_balance)}',
         style:
           TextStyle(fontSize: 12.5, color: cs.onSurfaceVariant),
        ),
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
          AppChip(
           label: 'Tout (${formatXaf(_balance)})',
           selected: amount == _balance,
           onTap: () => setSheetState(() => amount = _balance),
          ),
         ],
        ),
        const SizedBox(height: 18),
        Text('Vers',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 13,
            color: cs.onSurfaceVariant)),
        const SizedBox(height: 10),
        Wrap(
         spacing: 8,
         children: [
          for (final m in [PaymentMethod.airtel, PaymentMethod.moov])
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
         label: 'Retirer ${formatXaf(amount)}',
         icon: AppIcons.south_west_rounded,
         variant: AppButtonVariant.success,
         onPressed: () {
          setState(() => _balance -= amount);
          Navigator.of(context).pop();
          showAppSnack(
           context,
           'Retrait de ${formatXaf(amount)} initié — réception sous 24 h via ${method.label}.',
           emoji: '',
          );
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

class _MiniInfo extends StatelessWidget {
 const _MiniInfo({required this.label, required this.value});

 final String label;
 final String value;

 @override
 Widget build(BuildContext context) {
  return Column(
   crossAxisAlignment: CrossAxisAlignment.start,
   children: [
    Text(
     label,
     style: TextStyle(
      color: Colors.white.withValues(alpha: 0.75),
      fontSize: 11,
      fontWeight: FontWeight.w600,
     ),
    ),
    const SizedBox(height: 2),
    Text(
     value,
     style: const TextStyle(
      color: Colors.white,
      fontSize: 14,
      fontWeight: FontWeight.w800,
     ),
    ),
   ],
  );
 }
}

class _Payout {
 const _Payout(this.label, this.amount, this.date, this.emoji);

 final String label;
 final int amount;
 final DateTime date;
 final String emoji;
}

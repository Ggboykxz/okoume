import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/format.dart';
import '../../core/ui/common.dart';
import '../../core/ui/motion.dart';
import '../../data/models.dart';
import '../../data/providers.dart';
import '../../core/ui/app_icons.dart';

/// Vérification OTP SMS (démo : le code est 1 2 3 4).
class OtpScreen extends ConsumerStatefulWidget {
 const OtpScreen({
 super.key,
 this.phone = '+241 07 45 12 33',
 this.role = UserRole.acheteur,
 });

 final String phone;
 final UserRole role;

 @override
 ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
 final _controllers = List.generate(4, (_) => TextEditingController());
 final _nodes = List.generate(4, (_) => FocusNode());
 Timer? _resendTimer;
 int _resendIn = 28;
 bool _error = false;

 @override
 void initState() {
 super.initState();
 _startResendTimer();
 }

 void _startResendTimer() {
 _resendTimer?.cancel();
 setState(() => _resendIn = 28);
 _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
  if (!mounted) return;
  setState(() => _resendIn -= 1);
  if (_resendIn <= 0) timer.cancel();
 });
 }

 @override
 void dispose() {
 for (final c in _controllers) {
  c.dispose();
 }
 for (final n in _nodes) {
  n.dispose();
 }
 _resendTimer?.cancel();
 super.dispose();
 }

 String get _code => _controllers.map((c) => c.text).join();

 void _onDigit(int index, String value) {
 setState(() => _error = false);
 if (value.isNotEmpty && index < 3) {
  _nodes[index + 1].requestFocus();
 }
 if (_code.length == 4) _verify();
 }

 void _verify() {
 if (_code == '1234') {
  ref.read(authProvider.notifier).login(widget.phone, widget.role);
  AppMotion.success();
  // Première connexion : profil (C-09) zone de livraison (C-10) 
  // permissions (C-11) application.
  context.go('/auth/profile-setup');
 } else {
  setState(() => _error = true);
  for (final c in _controllers) {
  c.clear();
  }
  _nodes.first.requestFocus();
  showAppSnack(context, 'Code incorrect — le code démo est 1 2 3 4',
   emoji: '');
 }
 }

 @override
 Widget build(BuildContext context) {
 final cs = Theme.of(context).colorScheme;
 return Scaffold(
  appBar: AppBar(
  leading: IconButton(
   icon: const AppIcon(AppIcons.arrow_back_rounded),
   onPressed: () => context.pop(),
  ),
  title: const Text('Vérification'),
  ),
  body: SafeArea(
  child: ListView(
   padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
   children: [
   Text('Code SMS ',
    style: Theme.of(context).textTheme.headlineSmall),
   const SizedBox(height: 8),
   Text(
    'Nous avons envoyé un code à 4 chiffres au ${maskPhone(widget.phone)}.',
    style: TextStyle(color: cs.onSurfaceVariant, height: 1.45),
   ),
   const SizedBox(height: 28),
   Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    for (var i = 0; i < 4; i++) ...[
     _OtpBox(
     controller: _controllers[i],
     node: _nodes[i],
     error: _error,
     onChanged: (v) => _onDigit(i, v),
     ),
     if (i < 3) const SizedBox(width: 12),
    ],
    ],
   ),
   const SizedBox(height: 16),
   if (_error)
    Text(
    'Code incorrect. Réessayez.',
    textAlign: TextAlign.center,
    style: TextStyle(
     color: cs.error, fontWeight: FontWeight.w700, fontSize: 13),
    ),
   const SizedBox(height: 10),
   InfoBanner(
    emoji: '',
    color: cs.secondary,
    text: 'Mode démo : utilisez le code 1 2 3 4 pour vous connecter.',
   ),
   const SizedBox(height: 24),
   AppButton(
    label: 'Vérifier et continuer',
    icon: AppIcons.verified_rounded,
    onPressed: _verify,
   ),
   const SizedBox(height: 14),
   Center(
    child: _resendIn > 0
     ? Text(
      'Renvoyer le code dans ${_resendIn}s',
      style: TextStyle(
       color: cs.onSurfaceVariant,
       fontWeight: FontWeight.w600,
       fontSize: 13),
     )
     : GestureDetector(
      onTap: _startResendTimer,
      child: Text(
      'Renvoyer le code SMS',
      style: TextStyle(
       color: cs.primary,
       fontWeight: FontWeight.w700,
       fontSize: 13.5),
      ),
     ),
   ),
   const SizedBox(height: 8),
   Center(
    child: GestureDetector(
    onTap: () => context.pop(),
    child: Text(
     'Modifier le numéro',
     style: TextStyle(
      color: cs.onSurfaceVariant,
      fontWeight: FontWeight.w600,
      fontSize: 13),
    ),
    ),
   ),
   ],
  ),
  ),
 );
 }
}

class _OtpBox extends StatelessWidget {
 const _OtpBox({
 required this.controller,
 required this.node,
 required this.error,
 required this.onChanged,
 });

 final TextEditingController controller;
 final FocusNode node;
 final bool error;
 final ValueChanged<String> onChanged;

 @override
 Widget build(BuildContext context) {
 final cs = Theme.of(context).colorScheme;
 return SizedBox(
  width: 62,
  child: TextField(
  controller: controller,
  focusNode: node,
  textAlign: TextAlign.center,
  keyboardType: TextInputType.number,
  maxLength: 1,
  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
  onChanged: onChanged,
  style: const TextStyle(
   fontSize: 24, fontWeight: FontWeight.w800, height: 1.2),
  decoration: InputDecoration(
   counterText: '',
   filled: true,
   fillColor: cs.surface,
   contentPadding: const EdgeInsets.symmetric(vertical: 14),
   enabledBorder: OutlineInputBorder(
   borderRadius: BorderRadius.circular(14),
   borderSide: BorderSide(
    color: error ? cs.error : cs.outlineVariant,
    width: error ? 1.6 : 1),
   ),
   focusedBorder: OutlineInputBorder(
   borderRadius: BorderRadius.circular(14),
   borderSide: BorderSide(
    color: error ? cs.error : cs.primary, width: 1.6),
   ),
  ),
  ),
 );
 }
}

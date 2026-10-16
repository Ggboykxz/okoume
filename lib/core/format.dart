import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

/// Formatage FCFA (XAF) et dates en français — cf. §2.1 (pas de décimales).
String _group(int value) {
 final s = value.abs().toString();
 final buf = StringBuffer();
 for (var i = 0; i < s.length; i++) {
  if (i > 0 && (s.length - i) % 3 == 0) buf.write('\u00A0');
  buf.write(s[i]);
 }
 return '${value < 0 ? '-' : ''}$buf';
}

/// "12 500 FCFA"
String formatXaf(num amount) => '${_group(amount.round())}\u00A0FCFA';

/// "12 500" (sans devise)
String formatNumber(num amount) => _group(amount.round());

/// "15 M FCFA" pour les gros montants (immobilier…)
String formatXafCompact(num amount) {
 if (amount >= 1000000) {
  final m = amount / 1000000;
  final str = m >= 100 || m == m.roundToDouble()
    ? m.round().toString()
    : m.toStringAsFixed(1).replaceAll('.', ',');
  return '$str\u00A0M\u00A0FCFA';
 }
 if (amount >= 100000) return '${(amount / 1000).round()}\u00A0k\u00A0FCFA';
 return formatXaf(amount);
}

bool _frReady = false;

/// "12 oct. 2026" — repli robuste si les données de locale ne sont pas initialisées.
String formatDate(DateTime d) {
 if (!_frReady) return '${d.day}/${d.month}/${d.year}';
 return DateFormat('d MMM yyyy', 'fr_FR').format(d);
}

String formatDateShort(DateTime d) {
 if (!_frReady) return '${d.day}/${d.month}';
 return DateFormat('d MMM', 'fr_FR').format(d);
}

String formatTime(DateTime d) => DateFormat('HH:mm').format(d);

/// À appeler au démarrage et dans les tests.
Future<void> initFormats() async {
 try {
  await initializeDateFormatting('fr_FR');
  _frReady = true;
 } catch (_) {
  _frReady = false;
 }
}

String timeAgo(DateTime d) {
 final diff = DateTime.now().difference(d);
 if (diff.inMinutes < 1) return "à l'instant";
 if (diff.inMinutes < 60) return 'il y a ${diff.inMinutes} min';
 if (diff.inHours < 24) return 'il y a ${diff.inHours} h';
 if (diff.inDays == 1) return 'hier';
 return formatDateShort(d);
}

/// "02:14:37" pour les compte à rebours (offres flash).
String durationHms(Duration d) {
 final h = d.inHours.toString().padLeft(2, '0');
 final m = (d.inMinutes % 60).toString().padLeft(2, '0');
 final s = (d.inSeconds % 60).toString().padLeft(2, '0');
 return '$h:$m:$s';
}

/// "+241 07 45 •• ••" (numéros masqués livreur/client)
String maskPhone(String phone) {
 final digits = phone.replaceAll(RegExp(r'[^0-9+]'), '');
 if (digits.length <= 6) return phone;
 final visible = digits.substring(0, digits.length - 4);
 return '$visible\u00A0••\u00A0••';
}

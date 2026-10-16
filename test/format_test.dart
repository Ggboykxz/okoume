import 'package:flutter_test/flutter_test.dart';
import 'package:okoume/core/format.dart';

void main() {
  group('formatXaf', () {
    test('groupe les milliers avec espace insécable', () {
      expect(formatXaf(3500), '3\u00A0500\u00A0FCFA');
      expect(formatXaf(12500), '12\u00A0500\u00A0FCFA');
      expect(formatXaf(850), '850\u00A0FCFA');
    });

    test('formatXafCompact pour les gros montants', () {
      expect(formatXafCompact(15000000), '15\u00A0M\u00A0FCFA');
      expect(formatXafCompact(385000), '385\u00A0k\u00A0FCFA');
      expect(formatXafCompact(9000), '9\u00A0000\u00A0FCFA');
    });

    test('maskPhone masque la fin du numéro', () {
      expect(maskPhone('+241 07 45 12 33'), contains('••'));
    });

    test('durationHms formate un compte à rebours', () {
      expect(durationHms(const Duration(hours: 2, minutes: 14, seconds: 37)),
          '02:14:37');
    });
  });
}

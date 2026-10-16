import '../../features/extra/extra_spec.dart';
import 'extras_a.dart';
import 'extras_ad1.dart';
import 'extras_ad2.dart';
import 'extras_c.dart';
import 'extras_l.dart';
import 'extras_v.dart';

/// Fusion des aperçus de tous les modules (177 écrans hors MVP).
final Map<String, ExtraSpec> allExtraSpecs = {
 ...extraSpecsC,
 ...extraSpecsA,
 ...extraSpecsV,
 ...extraSpecsL,
 ...extraSpecsAd1,
 ...extraSpecsAd2,
};

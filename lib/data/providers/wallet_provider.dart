import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../mock_data.dart';
import '../models.dart';

final walletTxnsProvider = Provider<List<WalletTxn>>((ref) => Mock.walletTxns);

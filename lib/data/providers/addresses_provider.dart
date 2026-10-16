import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../mock_data.dart';
import '../models.dart';

class AddressesNotifier extends Notifier<List<Address>> {
  @override
  List<Address> build() => List.of(Mock.addresses);

  void add(Address address) => state = [...state, address];
}

final addressesProvider =
    NotifierProvider<AddressesNotifier, List<Address>>(AddressesNotifier.new);

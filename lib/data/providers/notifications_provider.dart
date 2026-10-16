import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../mock_data.dart';
import '../models.dart';

class NotificationsNotifier extends Notifier<List<AppNotification>> {
  @override
  List<AppNotification> build() => List.of(Mock.notifications);

  void markAllRead() =>
      state = state.map((n) => n.copyWith(read: true)).toList();
}

final notificationsProvider =
    NotifierProvider<NotificationsNotifier, List<AppNotification>>(
        NotificationsNotifier.new);

final unreadNotificationsProvider = Provider<int>((ref) {
  return ref.watch(notificationsProvider).where((n) => !n.read).length;
});

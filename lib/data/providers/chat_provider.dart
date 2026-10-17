import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../mock_data.dart';
import '../models.dart';

class ChatNotifier extends Notifier<List<ChatThread>> {
  @override
  List<ChatThread> build() => List.of(Mock.threads);

  static const _replies = [
    'Je vous envoie les photos tout de suite ',
    'Oui, c\'est disponible Vous voulez réserver ?',
    'Je peux vous faire -5% si vous prenez 2 pièces ',
    'Livraison possible dès demain matin ',
    'Merci pour votre confiance ',
  ];

  int _replyIndex = 0;
  final Set<String> _blockedThreads = <String>{};

  ChatNotifier() {
    // Alias explicite pour la lisibilité.
  }

  void _append(String threadId, ChatMessage message) {
    try {
      final index = state.indexWhere((t) => t.id == threadId);
      if (index < 0) return;
      final thread = state[index];
      state = List.of(state)
        ..[index] = thread.copyWith(
          unread: message.fromMe ? 0 : thread.unread + 1,
          messages: [...thread.messages, message],
        );
    } catch (_) {
      // Conteneur dispose — ignore.
    }
  }

  void send(String threadId, {String text = '', MessageKind kind = MessageKind.text}) {
    _append(
        threadId, ChatMessage(text: text, fromMe: true, time: DateTime.now(), kind: kind));
    final reply = _replies[_replyIndex++ % _replies.length];
    Timer(const Duration(milliseconds: 1400), () {
      _append(threadId,
          ChatMessage(text: reply, fromMe: false, time: DateTime.now()));
    });
  }

  void markRead(String threadId) {
    final index = state.indexWhere((t) => t.id == threadId);
    if (index < 0) return;
    state = List.of(state)..[index] = state[index].copyWith(unread: 0);
  }
  void blockSeller(String threadId) {
    _blockedThreads.add(threadId);
    // Retire le fil de la liste affichée (l'utilisateur ne le voit plus).
    state = state.where((t) => t.id != threadId).toList();
  }

  bool isBlocked(String threadId) => _blockedThreads.contains(threadId);

  /// Retourne l'id du fil existant avec ce vendeur, ou en crée un nouveau.
  String ensureThread(String sellerId) {
    for (final t in state) {
      if (t.sellerId == sellerId) return t.id;
    }
    final id = 't-${DateTime.now().millisecondsSinceEpoch}';
    state = [
      ChatThread(
        id: id,
        sellerId: sellerId,
        messages: [
          ChatMessage(
            text: 'Bonjour Je suis disponible pour répondre à vos questions.',
            fromMe: false,
            time: DateTime.now(),
          ),
        ],
      ),
      ...state,
    ];
    return id;
  }
}

final chatProvider = NotifierProvider<ChatNotifier, List<ChatThread>>(ChatNotifier.new);

final threadByIdProvider = Provider.family<ChatThread?, String>((ref, id) {
  for (final t in ref.watch(chatProvider)) {
    if (t.id == id) return t;
  }
  return null;
});

final unreadMessagesProvider = Provider<int>((ref) {
  return ref.watch(chatProvider).fold(0, (sum, t) => sum + t.unread);
});

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../mock_data.dart';
import '../models.dart';

class LivreurState {
  const LivreurState({
    this.online = true,
    this.available = const [],
    this.active,
    this.gainsToday = 0,
    this.wallet = 0,
    this.history = const [],
  });

  final bool online;
  final List<Course> available;
  final Course? active;
  final int gainsToday;
  final int wallet;
  final List<Course> history;

  LivreurState copyWith({
    bool? online,
    List<Course>? available,
    Course? active,
    bool clearActive = false,
    int? gainsToday,
    int? wallet,
    List<Course>? history,
  }) =>
      LivreurState(
        online: online ?? this.online,
        available: available ?? this.available,
        active: clearActive ? null : (active ?? this.active),
        gainsToday: gainsToday ?? this.gainsToday,
        wallet: wallet ?? this.wallet,
        history: history ?? this.history,
      );
}

class LivreurNotifier extends Notifier<LivreurState> {
  @override
  LivreurState build() => LivreurState(
        available: List.of(Mock.availableCourses),
        gainsToday: 8500,
        wallet: 32000,
        history: const [
          Course(id: 'h1', pickup: 'AgroPêche — Akanda', dropoff: 'Glass', distanceKm: 4.1, payout: 2200, etaMin: 35, vehicle: VehicleType.moto, sellerEmoji: ''),
          Course(id: 'h2', pickup: 'LibreStyle — Centre', dropoff: 'Louis', distanceKm: 2.7, payout: 1600, etaMin: 25, vehicle: VehicleType.moto, sellerEmoji: ''),
        ],
      );

  void toggleOnline() => state = state.copyWith(online: !state.online);

  void accept(String courseId) {
    final index = state.available.indexWhere((c) => c.id == courseId);
    if (index < 0) return;
    final course = state.available[index];
    state = state.copyWith(
      available: List.of(state.available)..removeAt(index),
      active: course,
    );
  }

  void refuse(String courseId) {
    state = state.copyWith(
      available: state.available.where((c) => c.id != courseId).toList(),
    );
  }

  void completeActive() {
    final course = state.active;
    if (course == null) return;
    state = state.copyWith(
      clearActive: true,
      wallet: state.wallet + course.payout,
      gainsToday: state.gainsToday + course.payout,
      history: [course, ...state.history],
    );
  }
}

final livreurProvider =
    NotifierProvider<LivreurNotifier, LivreurState>(LivreurNotifier.new);

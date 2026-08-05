// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'active_sessions_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$activeSessionsNotifierHash() =>
    r'd187c9e33f0ecbd602bf3c61cadfdecd53426abf';

/// See also [ActiveSessionsNotifier].
@ProviderFor(ActiveSessionsNotifier)
final activeSessionsNotifierProvider =
    StreamNotifierProvider<ActiveSessionsNotifier, List<GameSession>>.internal(
      ActiveSessionsNotifier.new,
      name: r'activeSessionsNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$activeSessionsNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ActiveSessionsNotifier = StreamNotifier<List<GameSession>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

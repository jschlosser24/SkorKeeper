// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'football_game_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$footballGameNotifierHash() =>
    r'f28eb1cc1664cadfe8515bf7bb22f75bc6105aeb';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$FootballGameNotifier
    extends BuildlessAutoDisposeAsyncNotifier<SportGameState> {
  late final int sessionId;

  FutureOr<SportGameState> build(int sessionId);
}

/// See also [FootballGameNotifier].
@ProviderFor(FootballGameNotifier)
const footballGameNotifierProvider = FootballGameNotifierFamily();

/// See also [FootballGameNotifier].
class FootballGameNotifierFamily extends Family<AsyncValue<SportGameState>> {
  /// See also [FootballGameNotifier].
  const FootballGameNotifierFamily();

  /// See also [FootballGameNotifier].
  FootballGameNotifierProvider call(int sessionId) {
    return FootballGameNotifierProvider(sessionId);
  }

  @override
  FootballGameNotifierProvider getProviderOverride(
    covariant FootballGameNotifierProvider provider,
  ) {
    return call(provider.sessionId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'footballGameNotifierProvider';
}

/// See also [FootballGameNotifier].
class FootballGameNotifierProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          FootballGameNotifier,
          SportGameState
        > {
  /// See also [FootballGameNotifier].
  FootballGameNotifierProvider(int sessionId)
    : this._internal(
        () => FootballGameNotifier()..sessionId = sessionId,
        from: footballGameNotifierProvider,
        name: r'footballGameNotifierProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$footballGameNotifierHash,
        dependencies: FootballGameNotifierFamily._dependencies,
        allTransitiveDependencies:
            FootballGameNotifierFamily._allTransitiveDependencies,
        sessionId: sessionId,
      );

  FootballGameNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.sessionId,
  }) : super.internal();

  final int sessionId;

  @override
  FutureOr<SportGameState> runNotifierBuild(
    covariant FootballGameNotifier notifier,
  ) {
    return notifier.build(sessionId);
  }

  @override
  Override overrideWith(FootballGameNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: FootballGameNotifierProvider._internal(
        () => create()..sessionId = sessionId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        sessionId: sessionId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<FootballGameNotifier, SportGameState>
  createElement() {
    return _FootballGameNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FootballGameNotifierProvider &&
        other.sessionId == sessionId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, sessionId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FootballGameNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<SportGameState> {
  /// The parameter `sessionId` of this provider.
  int get sessionId;
}

class _FootballGameNotifierProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          FootballGameNotifier,
          SportGameState
        >
    with FootballGameNotifierRef {
  _FootballGameNotifierProviderElement(super.provider);

  @override
  int get sessionId => (origin as FootballGameNotifierProvider).sessionId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

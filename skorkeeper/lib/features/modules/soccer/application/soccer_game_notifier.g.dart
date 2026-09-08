// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'soccer_game_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$soccerGameNotifierHash() =>
    r'7a10cf58031b8a156382c6957d2220b2e80a9c0a';

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

abstract class _$SoccerGameNotifier
    extends BuildlessAutoDisposeAsyncNotifier<SportGameState> {
  late final int sessionId;

  FutureOr<SportGameState> build(int sessionId);
}

/// See also [SoccerGameNotifier].
@ProviderFor(SoccerGameNotifier)
const soccerGameNotifierProvider = SoccerGameNotifierFamily();

/// See also [SoccerGameNotifier].
class SoccerGameNotifierFamily extends Family<AsyncValue<SportGameState>> {
  /// See also [SoccerGameNotifier].
  const SoccerGameNotifierFamily();

  /// See also [SoccerGameNotifier].
  SoccerGameNotifierProvider call(int sessionId) {
    return SoccerGameNotifierProvider(sessionId);
  }

  @override
  SoccerGameNotifierProvider getProviderOverride(
    covariant SoccerGameNotifierProvider provider,
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
  String? get name => r'soccerGameNotifierProvider';
}

/// See also [SoccerGameNotifier].
class SoccerGameNotifierProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          SoccerGameNotifier,
          SportGameState
        > {
  /// See also [SoccerGameNotifier].
  SoccerGameNotifierProvider(int sessionId)
    : this._internal(
        () => SoccerGameNotifier()..sessionId = sessionId,
        from: soccerGameNotifierProvider,
        name: r'soccerGameNotifierProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$soccerGameNotifierHash,
        dependencies: SoccerGameNotifierFamily._dependencies,
        allTransitiveDependencies:
            SoccerGameNotifierFamily._allTransitiveDependencies,
        sessionId: sessionId,
      );

  SoccerGameNotifierProvider._internal(
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
    covariant SoccerGameNotifier notifier,
  ) {
    return notifier.build(sessionId);
  }

  @override
  Override overrideWith(SoccerGameNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: SoccerGameNotifierProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<SoccerGameNotifier, SportGameState>
  createElement() {
    return _SoccerGameNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SoccerGameNotifierProvider && other.sessionId == sessionId;
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
mixin SoccerGameNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<SportGameState> {
  /// The parameter `sessionId` of this provider.
  int get sessionId;
}

class _SoccerGameNotifierProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          SoccerGameNotifier,
          SportGameState
        >
    with SoccerGameNotifierRef {
  _SoccerGameNotifierProviderElement(super.provider);

  @override
  int get sessionId => (origin as SoccerGameNotifierProvider).sessionId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

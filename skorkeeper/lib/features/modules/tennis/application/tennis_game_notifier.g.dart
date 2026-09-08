// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tennis_game_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$tennisGameNotifierHash() =>
    r'3a1fa471a04fefccfc93326b6d8314a759e01687';

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

abstract class _$TennisGameNotifier
    extends BuildlessAutoDisposeAsyncNotifier<SportGameState> {
  late final int sessionId;

  FutureOr<SportGameState> build(int sessionId);
}

/// See also [TennisGameNotifier].
@ProviderFor(TennisGameNotifier)
const tennisGameNotifierProvider = TennisGameNotifierFamily();

/// See also [TennisGameNotifier].
class TennisGameNotifierFamily extends Family<AsyncValue<SportGameState>> {
  /// See also [TennisGameNotifier].
  const TennisGameNotifierFamily();

  /// See also [TennisGameNotifier].
  TennisGameNotifierProvider call(int sessionId) {
    return TennisGameNotifierProvider(sessionId);
  }

  @override
  TennisGameNotifierProvider getProviderOverride(
    covariant TennisGameNotifierProvider provider,
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
  String? get name => r'tennisGameNotifierProvider';
}

/// See also [TennisGameNotifier].
class TennisGameNotifierProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          TennisGameNotifier,
          SportGameState
        > {
  /// See also [TennisGameNotifier].
  TennisGameNotifierProvider(int sessionId)
    : this._internal(
        () => TennisGameNotifier()..sessionId = sessionId,
        from: tennisGameNotifierProvider,
        name: r'tennisGameNotifierProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$tennisGameNotifierHash,
        dependencies: TennisGameNotifierFamily._dependencies,
        allTransitiveDependencies:
            TennisGameNotifierFamily._allTransitiveDependencies,
        sessionId: sessionId,
      );

  TennisGameNotifierProvider._internal(
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
    covariant TennisGameNotifier notifier,
  ) {
    return notifier.build(sessionId);
  }

  @override
  Override overrideWith(TennisGameNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: TennisGameNotifierProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<TennisGameNotifier, SportGameState>
  createElement() {
    return _TennisGameNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TennisGameNotifierProvider && other.sessionId == sessionId;
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
mixin TennisGameNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<SportGameState> {
  /// The parameter `sessionId` of this provider.
  int get sessionId;
}

class _TennisGameNotifierProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          TennisGameNotifier,
          SportGameState
        >
    with TennisGameNotifierRef {
  _TennisGameNotifierProviderElement(super.provider);

  @override
  int get sessionId => (origin as TennisGameNotifierProvider).sessionId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

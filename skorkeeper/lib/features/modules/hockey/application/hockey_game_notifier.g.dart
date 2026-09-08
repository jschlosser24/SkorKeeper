// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hockey_game_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$hockeyGameNotifierHash() =>
    r'e4752912f6630c2195ddbcbf78f241bda47d9049';

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

abstract class _$HockeyGameNotifier
    extends BuildlessAutoDisposeAsyncNotifier<SportGameState> {
  late final int sessionId;

  FutureOr<SportGameState> build(int sessionId);
}

/// See also [HockeyGameNotifier].
@ProviderFor(HockeyGameNotifier)
const hockeyGameNotifierProvider = HockeyGameNotifierFamily();

/// See also [HockeyGameNotifier].
class HockeyGameNotifierFamily extends Family<AsyncValue<SportGameState>> {
  /// See also [HockeyGameNotifier].
  const HockeyGameNotifierFamily();

  /// See also [HockeyGameNotifier].
  HockeyGameNotifierProvider call(int sessionId) {
    return HockeyGameNotifierProvider(sessionId);
  }

  @override
  HockeyGameNotifierProvider getProviderOverride(
    covariant HockeyGameNotifierProvider provider,
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
  String? get name => r'hockeyGameNotifierProvider';
}

/// See also [HockeyGameNotifier].
class HockeyGameNotifierProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          HockeyGameNotifier,
          SportGameState
        > {
  /// See also [HockeyGameNotifier].
  HockeyGameNotifierProvider(int sessionId)
    : this._internal(
        () => HockeyGameNotifier()..sessionId = sessionId,
        from: hockeyGameNotifierProvider,
        name: r'hockeyGameNotifierProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$hockeyGameNotifierHash,
        dependencies: HockeyGameNotifierFamily._dependencies,
        allTransitiveDependencies:
            HockeyGameNotifierFamily._allTransitiveDependencies,
        sessionId: sessionId,
      );

  HockeyGameNotifierProvider._internal(
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
    covariant HockeyGameNotifier notifier,
  ) {
    return notifier.build(sessionId);
  }

  @override
  Override overrideWith(HockeyGameNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: HockeyGameNotifierProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<HockeyGameNotifier, SportGameState>
  createElement() {
    return _HockeyGameNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is HockeyGameNotifierProvider && other.sessionId == sessionId;
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
mixin HockeyGameNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<SportGameState> {
  /// The parameter `sessionId` of this provider.
  int get sessionId;
}

class _HockeyGameNotifierProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          HockeyGameNotifier,
          SportGameState
        >
    with HockeyGameNotifierRef {
  _HockeyGameNotifierProviderElement(super.provider);

  @override
  int get sessionId => (origin as HockeyGameNotifierProvider).sessionId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

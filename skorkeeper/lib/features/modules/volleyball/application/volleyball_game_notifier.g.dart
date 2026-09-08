// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'volleyball_game_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$volleyballGameNotifierHash() =>
    r'68bcebd96c81cb39c7d50f2628cd47e1fabf2b8a';

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

abstract class _$VolleyballGameNotifier
    extends BuildlessAutoDisposeAsyncNotifier<SportGameState> {
  late final int sessionId;

  FutureOr<SportGameState> build(int sessionId);
}

/// See also [VolleyballGameNotifier].
@ProviderFor(VolleyballGameNotifier)
const volleyballGameNotifierProvider = VolleyballGameNotifierFamily();

/// See also [VolleyballGameNotifier].
class VolleyballGameNotifierFamily extends Family<AsyncValue<SportGameState>> {
  /// See also [VolleyballGameNotifier].
  const VolleyballGameNotifierFamily();

  /// See also [VolleyballGameNotifier].
  VolleyballGameNotifierProvider call(int sessionId) {
    return VolleyballGameNotifierProvider(sessionId);
  }

  @override
  VolleyballGameNotifierProvider getProviderOverride(
    covariant VolleyballGameNotifierProvider provider,
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
  String? get name => r'volleyballGameNotifierProvider';
}

/// See also [VolleyballGameNotifier].
class VolleyballGameNotifierProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          VolleyballGameNotifier,
          SportGameState
        > {
  /// See also [VolleyballGameNotifier].
  VolleyballGameNotifierProvider(int sessionId)
    : this._internal(
        () => VolleyballGameNotifier()..sessionId = sessionId,
        from: volleyballGameNotifierProvider,
        name: r'volleyballGameNotifierProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$volleyballGameNotifierHash,
        dependencies: VolleyballGameNotifierFamily._dependencies,
        allTransitiveDependencies:
            VolleyballGameNotifierFamily._allTransitiveDependencies,
        sessionId: sessionId,
      );

  VolleyballGameNotifierProvider._internal(
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
    covariant VolleyballGameNotifier notifier,
  ) {
    return notifier.build(sessionId);
  }

  @override
  Override overrideWith(VolleyballGameNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: VolleyballGameNotifierProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<
    VolleyballGameNotifier,
    SportGameState
  >
  createElement() {
    return _VolleyballGameNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is VolleyballGameNotifierProvider &&
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
mixin VolleyballGameNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<SportGameState> {
  /// The parameter `sessionId` of this provider.
  int get sessionId;
}

class _VolleyballGameNotifierProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          VolleyballGameNotifier,
          SportGameState
        >
    with VolleyballGameNotifierRef {
  _VolleyballGameNotifierProviderElement(super.provider);

  @override
  int get sessionId => (origin as VolleyballGameNotifierProvider).sessionId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

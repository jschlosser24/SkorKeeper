// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'basketball_game_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$basketballGameNotifierHash() =>
    r'149825481da865b709e4539829f22567c558c70e';

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

abstract class _$BasketballGameNotifier
    extends BuildlessAutoDisposeAsyncNotifier<SportGameState> {
  late final int sessionId;

  FutureOr<SportGameState> build(int sessionId);
}

/// See also [BasketballGameNotifier].
@ProviderFor(BasketballGameNotifier)
const basketballGameNotifierProvider = BasketballGameNotifierFamily();

/// See also [BasketballGameNotifier].
class BasketballGameNotifierFamily extends Family<AsyncValue<SportGameState>> {
  /// See also [BasketballGameNotifier].
  const BasketballGameNotifierFamily();

  /// See also [BasketballGameNotifier].
  BasketballGameNotifierProvider call(int sessionId) {
    return BasketballGameNotifierProvider(sessionId);
  }

  @override
  BasketballGameNotifierProvider getProviderOverride(
    covariant BasketballGameNotifierProvider provider,
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
  String? get name => r'basketballGameNotifierProvider';
}

/// See also [BasketballGameNotifier].
class BasketballGameNotifierProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          BasketballGameNotifier,
          SportGameState
        > {
  /// See also [BasketballGameNotifier].
  BasketballGameNotifierProvider(int sessionId)
    : this._internal(
        () => BasketballGameNotifier()..sessionId = sessionId,
        from: basketballGameNotifierProvider,
        name: r'basketballGameNotifierProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$basketballGameNotifierHash,
        dependencies: BasketballGameNotifierFamily._dependencies,
        allTransitiveDependencies:
            BasketballGameNotifierFamily._allTransitiveDependencies,
        sessionId: sessionId,
      );

  BasketballGameNotifierProvider._internal(
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
    covariant BasketballGameNotifier notifier,
  ) {
    return notifier.build(sessionId);
  }

  @override
  Override overrideWith(BasketballGameNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: BasketballGameNotifierProvider._internal(
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
    BasketballGameNotifier,
    SportGameState
  >
  createElement() {
    return _BasketballGameNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BasketballGameNotifierProvider &&
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
mixin BasketballGameNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<SportGameState> {
  /// The parameter `sessionId` of this provider.
  int get sessionId;
}

class _BasketballGameNotifierProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          BasketballGameNotifier,
          SportGameState
        >
    with BasketballGameNotifierRef {
  _BasketballGameNotifierProviderElement(super.provider);

  @override
  int get sessionId => (origin as BasketballGameNotifierProvider).sessionId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

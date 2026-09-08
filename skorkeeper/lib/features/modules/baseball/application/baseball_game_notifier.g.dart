// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'baseball_game_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$baseballGameNotifierHash() =>
    r'46e83bca4aff6c156e1bb0500fb1cc70e22278bf';

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

abstract class _$BaseballGameNotifier
    extends BuildlessAutoDisposeAsyncNotifier<SportGameState> {
  late final int sessionId;

  FutureOr<SportGameState> build(int sessionId);
}

/// See also [BaseballGameNotifier].
@ProviderFor(BaseballGameNotifier)
const baseballGameNotifierProvider = BaseballGameNotifierFamily();

/// See also [BaseballGameNotifier].
class BaseballGameNotifierFamily extends Family<AsyncValue<SportGameState>> {
  /// See also [BaseballGameNotifier].
  const BaseballGameNotifierFamily();

  /// See also [BaseballGameNotifier].
  BaseballGameNotifierProvider call(int sessionId) {
    return BaseballGameNotifierProvider(sessionId);
  }

  @override
  BaseballGameNotifierProvider getProviderOverride(
    covariant BaseballGameNotifierProvider provider,
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
  String? get name => r'baseballGameNotifierProvider';
}

/// See also [BaseballGameNotifier].
class BaseballGameNotifierProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          BaseballGameNotifier,
          SportGameState
        > {
  /// See also [BaseballGameNotifier].
  BaseballGameNotifierProvider(int sessionId)
    : this._internal(
        () => BaseballGameNotifier()..sessionId = sessionId,
        from: baseballGameNotifierProvider,
        name: r'baseballGameNotifierProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$baseballGameNotifierHash,
        dependencies: BaseballGameNotifierFamily._dependencies,
        allTransitiveDependencies:
            BaseballGameNotifierFamily._allTransitiveDependencies,
        sessionId: sessionId,
      );

  BaseballGameNotifierProvider._internal(
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
    covariant BaseballGameNotifier notifier,
  ) {
    return notifier.build(sessionId);
  }

  @override
  Override overrideWith(BaseballGameNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: BaseballGameNotifierProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<BaseballGameNotifier, SportGameState>
  createElement() {
    return _BaseballGameNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BaseballGameNotifierProvider &&
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
mixin BaseballGameNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<SportGameState> {
  /// The parameter `sessionId` of this provider.
  int get sessionId;
}

class _BaseballGameNotifierProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          BaseballGameNotifier,
          SportGameState
        >
    with BaseballGameNotifierRef {
  _BaseballGameNotifierProviderElement(super.provider);

  @override
  int get sessionId => (origin as BaseballGameNotifierProvider).sessionId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

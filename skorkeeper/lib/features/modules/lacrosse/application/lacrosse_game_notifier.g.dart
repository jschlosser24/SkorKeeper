// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lacrosse_game_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$lacrosseGameNotifierHash() =>
    r'86a233fb5a9504bfa0cb24e0592443f3155348f6';

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

abstract class _$LacrosseGameNotifier
    extends BuildlessAutoDisposeAsyncNotifier<SportGameState> {
  late final int sessionId;

  FutureOr<SportGameState> build(int sessionId);
}

/// See also [LacrosseGameNotifier].
@ProviderFor(LacrosseGameNotifier)
const lacrosseGameNotifierProvider = LacrosseGameNotifierFamily();

/// See also [LacrosseGameNotifier].
class LacrosseGameNotifierFamily extends Family<AsyncValue<SportGameState>> {
  /// See also [LacrosseGameNotifier].
  const LacrosseGameNotifierFamily();

  /// See also [LacrosseGameNotifier].
  LacrosseGameNotifierProvider call(int sessionId) {
    return LacrosseGameNotifierProvider(sessionId);
  }

  @override
  LacrosseGameNotifierProvider getProviderOverride(
    covariant LacrosseGameNotifierProvider provider,
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
  String? get name => r'lacrosseGameNotifierProvider';
}

/// See also [LacrosseGameNotifier].
class LacrosseGameNotifierProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          LacrosseGameNotifier,
          SportGameState
        > {
  /// See also [LacrosseGameNotifier].
  LacrosseGameNotifierProvider(int sessionId)
    : this._internal(
        () => LacrosseGameNotifier()..sessionId = sessionId,
        from: lacrosseGameNotifierProvider,
        name: r'lacrosseGameNotifierProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$lacrosseGameNotifierHash,
        dependencies: LacrosseGameNotifierFamily._dependencies,
        allTransitiveDependencies:
            LacrosseGameNotifierFamily._allTransitiveDependencies,
        sessionId: sessionId,
      );

  LacrosseGameNotifierProvider._internal(
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
    covariant LacrosseGameNotifier notifier,
  ) {
    return notifier.build(sessionId);
  }

  @override
  Override overrideWith(LacrosseGameNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: LacrosseGameNotifierProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<LacrosseGameNotifier, SportGameState>
  createElement() {
    return _LacrosseGameNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LacrosseGameNotifierProvider &&
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
mixin LacrosseGameNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<SportGameState> {
  /// The parameter `sessionId` of this provider.
  int get sessionId;
}

class _LacrosseGameNotifierProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          LacrosseGameNotifier,
          SportGameState
        >
    with LacrosseGameNotifierRef {
  _LacrosseGameNotifierProviderElement(super.provider);

  @override
  int get sessionId => (origin as LacrosseGameNotifierProvider).sessionId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budgets_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$budgetsHash() => r'c0b08496b40378a97887b03aeffcb560a9521283';

/// Live stream of all per-category budget limits.
///
/// Copied from [budgets].
@ProviderFor(budgets)
final budgetsProvider = AutoDisposeStreamProvider<List<Budget>>.internal(
  budgets,
  name: r'budgetsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$budgetsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BudgetsRef = AutoDisposeStreamProviderRef<List<Budget>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

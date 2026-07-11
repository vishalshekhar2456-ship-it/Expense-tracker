// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'currency_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currencySymbolHash() => r'93002d6480c8dfa37f5713e225db93da9267945c';

/// Resolves the current currency code into a display symbol,
/// e.g. "INR" -> "₹", "USD" -> "$". Falls back to "₹" while settings
/// are still loading, since that's expenseful's default.
///
/// Copied from [currencySymbol].
@ProviderFor(currencySymbol)
final currencySymbolProvider = AutoDisposeProvider<String>.internal(
  currencySymbol,
  name: r'currencySymbolProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currencySymbolHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrencySymbolRef = AutoDisposeProviderRef<String>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

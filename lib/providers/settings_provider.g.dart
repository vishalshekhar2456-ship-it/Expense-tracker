// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$settingsHash() => r'6f8020ab68fa5801cc65c7be7ded1fa98627655d';

/// Live stream of the app's single settings row. Any widget watching this
/// rebuilds automatically the moment currency, theme, date format, or
/// budget reset day changes anywhere in the app.
///
/// Copied from [settings].
@ProviderFor(settings)
final settingsProvider = AutoDisposeStreamProvider<AppSettingsData>.internal(
  settings,
  name: r'settingsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$settingsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SettingsRef = AutoDisposeStreamProviderRef<AppSettingsData>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member

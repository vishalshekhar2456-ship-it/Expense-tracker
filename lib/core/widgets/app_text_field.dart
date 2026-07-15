import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// The single text input used across the app.
///
/// It's a thin wrapper over [TextField] that always disables stylus
/// handwriting (so Android never shows the "downloading stylus" toast and iOS
/// Scribble stays off). Use this instead of a raw [TextField] everywhere, so
/// input behavior stays consistent and is controlled in one place.
class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final InputDecoration? decoration;
  final TextStyle? style;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;
  final bool autofocus;
  final int maxLines;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  const AppTextField({
    super.key,
    this.controller,
    this.decoration,
    this.style,
    this.keyboardType,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
    this.autofocus = false,
    this.maxLines = 1,
    this.onChanged,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      // Single source of truth: pen handwriting input is off app-wide.
      stylusHandwritingEnabled: false,
      decoration: decoration,
      style: style,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      textCapitalization: textCapitalization,
      autofocus: autofocus,
      maxLines: maxLines,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
    );
  }
}

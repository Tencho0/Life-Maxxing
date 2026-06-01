// Form-field primitives — labelled field wrapper plus styled text inputs.
// Mirrors the prototype `Field`, `Input`, `TextArea` (design/life-maxxing/
// project/app/kit.jsx). See §2 of the technical spec.

import 'package:flutter/material.dart';

import 'package:lifemaxxing/core/theme/tokens.dart';
import 'package:lifemaxxing/core/theme/typography.dart';

/// A labelled form field: an uppercased mono label (with an optional accent
/// `•` when [required] and an optional right-aligned faint [hint]), a 7px gap,
/// then [child]. Carries a 14px bottom margin.
class Field extends StatelessWidget {
  const Field({
    super.key,
    required this.label,
    required this.child,
    this.required = false,
    this.hint,
  });

  final String label;
  final Widget child;
  final bool required;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(label.toUpperCase(), style: AppText.fieldLabel),
              if (required) ...[
                const SizedBox(width: 6),
                const Text(
                  '•',
                  style: TextStyle(
                    fontFamily: AppText.mono,
                    fontSize: 11,
                    color: AppColors.accent,
                  ),
                ),
              ],
              if (hint != null) ...[
                const Spacer(),
                Text(hint!, style: AppText.monoFaint),
              ],
            ],
          ),
          const SizedBox(height: 7),
          child,
        ],
      ),
    );
  }
}

/// Shared input decoration: card fill, 1px border, 13px radius, 13×14 padding,
/// accent border when focused, faint hint, no Material underline.
InputDecoration _inputDecoration(String? hintText) {
  const border = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(AppRadii.input)),
    borderSide: BorderSide(color: AppColors.border, width: 1),
  );
  return InputDecoration(
    isDense: true,
    filled: true,
    fillColor: AppColors.card,
    hintText: hintText,
    hintStyle: const TextStyle(color: AppColors.textFaint),
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
    enabledBorder: border,
    border: border,
    focusedBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(AppRadii.input)),
      borderSide: BorderSide(color: AppColors.accent, width: 1),
    ),
    disabledBorder: border,
  );
}

/// A single-line styled text input. 15px sans body text on a card surface.
class LmInput extends StatelessWidget {
  const LmInput({
    super.key,
    this.controller,
    this.hintText,
    this.keyboardType,
    this.initialText,
    this.onChanged,
    this.enabled = true,
    this.style,
  });

  final TextEditingController? controller;
  final String? hintText;
  final TextInputType? keyboardType;
  final String? initialText;
  final ValueChanged<String>? onChanged;
  final bool enabled;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      initialValue: controller == null ? initialText : null,
      keyboardType: keyboardType,
      onChanged: onChanged,
      enabled: enabled,
      cursorColor: AppColors.accent,
      style: style ?? AppText.body.copyWith(fontSize: 15),
      decoration: _inputDecoration(hintText),
    );
  }
}

/// A multiline styled text input. ~3 visible lines (~84px min height), 14px
/// text with 1.5 line height; set [mono] to switch to the mono family.
class LmTextArea extends StatelessWidget {
  const LmTextArea({
    super.key,
    this.controller,
    this.hintText,
    this.initialText,
    this.onChanged,
    this.enabled = true,
    this.mono = false,
    this.style,
  });

  final TextEditingController? controller;
  final String? hintText;
  final String? initialText;
  final ValueChanged<String>? onChanged;
  final bool enabled;
  final bool mono;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final base = TextStyle(
      fontFamily: mono ? AppText.mono : AppText.sans,
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: AppColors.text,
      height: 1.5,
    );
    return TextFormField(
      controller: controller,
      initialValue: controller == null ? initialText : null,
      onChanged: onChanged,
      enabled: enabled,
      minLines: 3,
      maxLines: null,
      keyboardType: TextInputType.multiline,
      cursorColor: AppColors.accent,
      style: style ?? base,
      decoration: _inputDecoration(hintText),
    );
  }
}

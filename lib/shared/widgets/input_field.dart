import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputField extends StatelessWidget {
  final String? Function(String? input)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final String? label;
  final String? hint;
  final bool obscureText;
  final int? maxLength;
  final TextEditingController? controller;
  final TextInputAction? textInputAction;
  final Widget? suffixIcon;
  final Widget? suffix;
  final double borderWidth;
  final bool enabled;

  /// callbacks
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;

  const InputField({
    this.label,
    super.key,
    this.controller,
    this.hint,
    this.obscureText = false,
    this.borderWidth = 1,
    this.validator,
    this.textInputAction,
    this.keyboardType,
    this.suffixIcon,
    this.suffix,
    this.maxLength,
    this.inputFormatters,
    this.enabled = true,
    this.onTap,
    this.onChanged,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) Text(label!, style: TextStyle(color: theme.outline)),
        const SizedBox(height: 6),
        TextFormField(
          enabled: enabled,

          inputFormatters: inputFormatters,
          obscureText: obscureText,
          textInputAction: textInputAction, // Moves focus to next.
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          maxLength: maxLength,

          decoration: InputDecoration(
            suffixIcon: suffixIcon,
            suffix: suffix,
            errorMaxLines: 2,
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderSide:
                  BorderSide(color: theme.outlineVariant, width: borderWidth),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          onChanged: onChanged,
          onFieldSubmitted: onFieldSubmitted,
          onTap: onTap,
        ),
      ],
    );
  }
}

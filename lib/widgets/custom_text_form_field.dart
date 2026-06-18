import "package:auto_size_text_field/auto_size_text_field.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";

/// Custom text form field for displaying text form field
class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField({
    this.controller,
    this.onChanged,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.enabled = true,
    this.readOnly = false,
    this.onTap,
    this.autofillHints,
    this.inputFormatters,
    this.autofocus = false,
    this.obscureText = false,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.autoSize = true,
    super.key,
  });

  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final bool enabled;
  final bool readOnly;
  final void Function()? onTap;
  final Iterable<String>? autofillHints;
  final List<TextInputFormatter>? inputFormatters;
  final bool autofocus;
  final bool obscureText;
  final String? labelText;
  final String? hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool autoSize;

  @override
  State<CustomTextFormField> createState() => CustomTextFormFieldState();
}

class CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(final BuildContext context) {
    return decisionBuilder();
  }

  Widget decisionBuilder() {
    return widget.autoSize ? autoSizeTextFormField() : textFormField();
  }

  Widget autoSizeTextFormField() {
    return AutoSizeTextFormField(
      controller: widget.controller,
      onChanged: widget.onChanged,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      validator: widget.validator,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      onTap: widget.onTap,
      autofillHints: widget.autofillHints,
      inputFormatters: widget.inputFormatters,
      autofocus: widget.autofocus,
      obscureText: widget.obscureText,
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.never,
        labelText: widget.labelText,
        hintText: widget.hintText,
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.suffixIcon,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
      ),
    );
  }

  Widget textFormField() {
    return TextFormField(
      controller: widget.controller,
      onChanged: widget.onChanged,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      validator: widget.validator,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      onTap: widget.onTap,
      autofillHints: widget.autofillHints,
      inputFormatters: widget.inputFormatters,
      autofocus: widget.autofocus,
      obscureText: widget.obscureText,
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.never,
        labelText: widget.labelText,
        hintText: widget.hintText,
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.suffixIcon,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
      ),
    );
  }
}

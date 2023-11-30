import 'package:flutter/material.dart';

import '../shared/styles.dart';

class TextField2 extends StatelessWidget {
  const TextField2({
    this.obscureText,
    this.readOnly,
    this.textAlign,
    this.initialValue,
    this.hintText,
    this.focusNode,
    this.controller,
    this.hintStyle,
    this.onSaved,
    this.onChanged,
    this.validator,
    this.type,
    this.border,
    this.onTap,
    super.key,
  });

  final String? initialValue;
  final String? hintText;
  final TextAlign? textAlign;
  final TextInputType? type;
  final TextStyle? hintStyle;
  final TextEditingController? controller;
  final void Function(String?)? onSaved;
  final void Function(String?)? onChanged;
  final String? Function(String?)? validator;
  final bool? obscureText;
  final bool? readOnly;
  final FocusNode? focusNode;
  final OutlineInputBorder? border;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enableSuggestions: false,
      autocorrect: false,
      controller: controller,
      inputFormatters: const [],
      textAlign: textAlign ?? TextAlign.start,
      keyboardType: type ?? TextInputType.text, //username or email
      initialValue: initialValue ?? '',
      style: fontFamilyBold.size16,
      cursorColor: Colors.white,
      decoration: InputDecoration(
        hintText: hintText ?? '',
        hintStyle: hintStyle,
        focusColor: Colors.black,

        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(width: 1, color: Colors.black),
        ),
        border: border,
        // border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
      ),
      onSaved: onSaved,
      onChanged: onChanged,
      validator: validator,
      obscureText: obscureText ?? false,
      autofocus: true,
      focusNode: focusNode,
      readOnly: readOnly ?? false,
      onTap: onTap,
    );
  }
}

import 'package:flutter/material.dart';

class CustomInputText extends StatelessWidget {
  final String labelText;
  final String hintText;
  final bool obscureText;
  final bool enableSuggestions;
  final bool autocorrect;
  final Function(dynamic) onChange;
  final dynamic prefix;
  final dynamic suffix;
  final TextEditingController? controller;
  CustomInputText({
    super.key,
    required this.hintText,
    required this.labelText,
    onChange,
    this.obscureText = false,
    this.enableSuggestions = false,
    this.autocorrect = false,
    this.controller,
    prefix,
    suffix,
  })  : onChange = onChange ?? ((e) {}),
        prefix = (prefix != null)
            ? prefix is Widget
                ? prefix
                : null
            : null,
        suffix = (suffix != null)
            ? suffix is Widget
                ? suffix
                : null
            : null;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w300,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 10.0),
        TextFormField(
          textInputAction: TextInputAction.next,
          controller: controller,
          obscureText: obscureText,
          enableSuggestions: enableSuggestions,
          autocorrect: autocorrect,
          onChanged: onChange,
          decoration: InputDecoration(
            hintText: hintText,
            suffixIcon: suffix,
            prefixIcon: prefix,
            hintStyle: const TextStyle(
              color: Colors.grey,
            ),
            border: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black87,
              ),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black87,
              ),
            ),
          ),
          style: const TextStyle(
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
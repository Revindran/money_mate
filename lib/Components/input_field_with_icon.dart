import 'package:flutter/material.dart';

class FormInputFieldWithIcon extends StatelessWidget {
  FormInputFieldWithIcon(
      {required this.controller,
        required this.iconPrefix,
        required this.labelText,
        required this.validator,
        this.keyboardType = TextInputType.text,
        this.obscureText = false,
        this.minLines = 1,
        this.maxLines,
        required this.onChanged,
        required this.onSaved});

  final TextEditingController controller;
  final IconData iconPrefix;
  final String labelText;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final bool obscureText;
  final int minLines;
  final int? maxLines;
  final void Function(String) onChanged;
  final void Function(String?)? onSaved;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        filled: true,
        prefixIcon: Icon(iconPrefix),
        labelText: labelText,
      ),
      controller: controller,
      onSaved: onSaved,
      onChanged: onChanged,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLines: maxLines,
      minLines: minLines,
      validator: validator,
    );
  }
}


class PrimaryButton extends StatelessWidget {
  PrimaryButton({required this.labelText, required this.onPressed});

  final String labelText;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        labelText.toUpperCase(),
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}


class LabelButton extends StatelessWidget {
  LabelButton({required this.labelText, required this.onPressed});
  final String labelText;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text(
        labelText,
      ),
      onPressed: onPressed,
    );
  }
}
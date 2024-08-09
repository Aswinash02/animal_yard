import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PhoneNumberInputFormatter extends TextInputFormatter {
  final RegExp _regExp = RegExp(r'[^\d+]'); // Allows digits and '+'

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Remove unwanted characters
    String newText = newValue.text.replaceAll(_regExp, '');

    // Preserve the cursor position
    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
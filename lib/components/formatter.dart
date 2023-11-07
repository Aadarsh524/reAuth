import 'package:flutter/services.dart';

class NoUppercaseInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.replaceAll(RegExp(r'[A-Z]'), ''),
      selection: newValue.selection,
    );
  }
}

import 'package:flutter/services.dart';

class BunchesFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String filter = newValue.text;
    final TextSelection newSelection = newValue.selection;

    if (newValue.text == "0" || newValue.text.isEmpty) {
      filter = "0";
      return TextEditingValue(
          text: filter,
          selection:
              TextSelection.fromPosition(TextPosition(offset: filter.length)));
    } else {
      if (newValue.text.contains(RegExp(r'^0+'))) {
        filter = newValue.text.replaceFirst(RegExp(r'^0+'), "");
        return TextEditingValue(
            text: filter,
            selection: TextSelection.fromPosition(
                TextPosition(offset: filter.length)));
      } else {
        return TextEditingValue(text: filter, selection: newSelection);
      }
    }
  }
}

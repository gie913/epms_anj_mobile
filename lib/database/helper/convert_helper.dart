class ConvertHelper {
  static String capitalCase(String text) {
    final newText = text.isNotEmpty
        ? '${text[0].toUpperCase()}${text.substring(1).toLowerCase()}'
        : '';
    // ex : Hello world
    return newText;
  }

  static String titleCase(String text) {
    final newText = text
        .replaceAll(RegExp(' +'), ' ')
        .split(' ')
        .map(capitalCase)
        .join(' ');
    // ex : Hello World
    return newText;
  }

  static double stringToDouble(String value) {
    if (value.isNotEmpty) {
      return double.parse(value);
    }

    return double.parse('0');
  }

  static bool intToBool(int value) {
    return value == 1;
  }

  static int boolToInt(bool value) {
    if (value == true) {
      return 1;
    } else {
      return 0;
    }
  }
}

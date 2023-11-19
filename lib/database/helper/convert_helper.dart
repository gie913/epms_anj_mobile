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
}

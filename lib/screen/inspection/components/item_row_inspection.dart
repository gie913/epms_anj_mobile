import 'package:epms/base/ui/style.dart';
import 'package:epms/base/ui/theme_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ItemRowInspection extends StatelessWidget {
  const ItemRowInspection({
    super.key,
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: Style.whiteBold12.copyWith(
                      color: themeNotifier.status == true ||
                              MediaQuery.of(context).platformBrightness ==
                                  Brightness.dark
                          ? Colors.white
                          : Colors.black,
                      fontWeight: FontWeight.normal),
                ),
                Text(
                  value,
                  style: Style.whiteBold12.copyWith(
                      color: themeNotifier.status == true ||
                              MediaQuery.of(context).platformBrightness ==
                                  Brightness.dark
                          ? Colors.white
                          : Colors.black,
                      fontWeight: FontWeight.normal),
                )
              ],
            ),
            Divider(height: 1.5, color: Colors.grey.shade300),
          ],
        );
      },
    );
  }
}

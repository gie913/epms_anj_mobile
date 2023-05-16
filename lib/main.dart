import 'package:epms/app.dart';
import 'package:epms/base/api/api_endpoint.dart';
import 'package:epms/base/ui/theme_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:provider/provider.dart';

import 'base/common/locator.dart';

void main() async {
  await setupLocator();
  FlavorConfig(
    variables: {
      "appMode": "Production",
      "variable": "production",
      "appName": "EPMS",
      "baseUrl": APIEndPoint.BASE_URL_PROD,
    },
  );
  return runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(lazy: false, create: (_) => ThemeNotifier()),
      ],
      child: App(),
    ),
  );
}

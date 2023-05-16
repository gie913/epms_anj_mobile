import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'base/api/api_endpoint.dart';
import 'base/common/locator.dart';
import 'base/ui/theme_notifier.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  FlavorConfig(
    variables: {
      "appMode": "Development",
      "variable": "development",
      "appName": "EPMS Dev",
      "baseUrl": APIEndPoint.BASE_URL,
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

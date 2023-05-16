import 'package:epms/base/common/routes_manager.dart' as router;
import 'package:epms/widget/manager_dialog.dart' as dialog;
import 'package:epms/base/ui/theme_notifier.dart';
import 'package:epms/screen/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'base/common/locator.dart';
import 'base/common/routes.dart';
import 'base/ui/screen_style.dart';
import 'common_manager/navigator_service.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Consumer<ThemeNotifier>(
      builder: (context, theme, child) => MaterialApp(
        theme: theme.getTheme(),
        darkTheme: theme.darkTheme,
        debugShowCheckedModeBanner: false,
        navigatorKey: locator<NavigatorService>().navigatorKey,
        onGenerateRoute: router.generateRoute,
        initialRoute: Routes.ROOT,
        builder: (context, child) {
          child = dialog.builderDialog(context, child);
          child = ScreenStyle.responsiveBuilder(context, child);
          return child;
        },
        home: SplashScreen(),
      ),
    );
  }
}

import 'package:epms/base/constants/constanta.dart';
import 'package:epms/base/constants/image_assets.dart';
import 'package:epms/base/ui/palette.dart';
import 'package:epms/base/ui/style.dart';
import 'package:epms/common_manager/navigator_service.dart';
import 'package:epms/screen/configuration/configuration_notifier.dart';
import 'package:epms/screen/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConfigurationScreen extends StatefulWidget {
  const ConfigurationScreen({Key? key}) : super(key: key);

  @override
  _ConfigurationScreenState createState() => _ConfigurationScreenState();
}

class _ConfigurationScreenState extends State<ConfigurationScreen> {
  @override
  void initState() {
    context.read<ConfigurationNotifier>().onInitConfiguration();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ConfigurationNotifier>(
      builder: (context, configuration, child) {
        return Scaffold(
          body: MediaQuery(
            data: Style.mediaQueryText(context),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 30),
                      Image.asset(ImageAssets.ANJ_LOGO, height: 60),
                      SizedBox(height: 40),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 60),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Api Server:"),
                              TextFormField(
                                  controller: configuration.apiServer,
                                  autocorrect: false,
                                  textInputAction: TextInputAction.next,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  decoration:
                                      InputDecoration(hintText: "Api Server"),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Tidak Boleh Kosong";
                                    }
                                    return null;
                                  }),
                              SizedBox(
                                height: 30,
                              ),
                              SizedBox(height: 30),
                              InkWell(
                                onTap: () {
                                  configuration.doSaveButton(
                                      context,
                                      configuration.apiServer.text,
                                      configuration.database.text);
                                },
                                child: Card(
                                  color: Palette.primaryColorProd,
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.all(14),
                                    width: MediaQuery.of(context).size.width,
                                    child: Text("SIMPAN",
                                        style: Style.whiteBold18,
                                        textAlign: TextAlign.center),
                                  ),
                                ),
                              ),
                              SizedBox(height: 30),
                              Container(
                                alignment: Alignment.center,
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.arrow_back_rounded,
                                          size: 15, color: Palette.primaryColorProd),
                                      InkWell(
                                        onTap: () {
                                          NavigatorService.navigateTo(
                                              context, LoginPage());
                                        },
                                        child: Text(
                                          "Ke Halaman Login",
                                          style: Style.primaryBold,
                                        ),
                                      ),
                                    ]),
                              ),
                              SizedBox(height: 30),
                              Container(
                                alignment: Alignment.center,
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "${Constanta.APP_VERSION}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ]),
                              ),
                            ]),
                      )
                    ]),
              ),
            ),
          ),
        );
      },
    );
  }
}

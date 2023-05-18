import 'package:epms/base/constants/constanta.dart';
import 'package:epms/base/constants/image_assets.dart';
import 'package:epms/base/ui/palette.dart';
import 'package:epms/base/ui/style.dart';
import 'package:epms/screen/login/login_notifier.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/elusive_icons.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    context.read<LoginNotifier>().onInitLoginScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginNotifier>(
      builder: (context, login, child) {
        return WillPopScope(
          onWillPop: () async => false,
          child: MediaQuery(
            data: Style.mediaQueryText(context),
            child: Scaffold(
              body: Form(
                key: login.formKey,
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        Image.asset(
                          ImageAssets.ANJ_LOGO,
                          height: 70,
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 55),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFormField(
                                controller: login.username,
                                autocorrect: false,
                                textInputAction: TextInputAction.next,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                decoration: InputDecoration(
                                    hintText: "Username",
                                    labelText: "Username"),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Username tidak boleh kosong";
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: login.password,
                                autocorrect: false,
                                obscureText: login.obscureText,
                                textInputAction: TextInputAction.next,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                decoration: InputDecoration(
                                    suffixIcon: InkWell(
                                        onTap: login.toggle,
                                        child: login.obscureText
                                            ? Icon(Elusive.eye)
                                            : Icon(Elusive.eye_off)),
                                    hintText: "Password",
                                    labelText: "Password"),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Password tidak boleh kosong";
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 30),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: InkWell(
                                  onTap: () {
                                    login.doLogin(context);
                                  },
                                  child: Card(
                                    color: Palette.primaryColorProd,
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.all(14),
                                      child: login.loading
                                          ? SizedBox(
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 3,
                                              ),
                                              height: 26.0,
                                              width: 26.0,
                                            )
                                          : Text(
                                              "LOGIN",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                              textAlign: TextAlign.center,
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 30),
                              Container(
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      InkWell(
                                          onTap: () {
                                            login.onPressConfiguration(context);
                                          },
                                          child: Text(
                                            "Halaman Konfigurasi",
                                            style: TextStyle(
                                                color: Palette.primaryColorProd,
                                                fontWeight: FontWeight.bold),
                                          )),
                                      Icon(
                                        Icons.arrow_forward_rounded,
                                        size: 15,
                                        color: Palette.primaryColorProd,
                                      ),
                                    ],
                                  )),
                              SizedBox(height: 30),
                              Container(
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "${Constanta.APP_VERSION}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 10),
                                      Text("${login.appName}"),
                                    ],
                                  )),
                              SizedBox(height: 30),
                              Container(
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          login.onPressResetData(context);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Text(
                                            "Reset Data",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Palette.redColorDark),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

import 'package:epms/base/constants/image_assets.dart';
import 'package:epms/base/ui/palette.dart';
import 'package:epms/base/ui/style.dart';
import 'package:epms/base/ui/theme_notifier.dart';
import 'package:epms/common_manager/storage_manager.dart';
import 'package:epms/screen/home/home_notifier.dart';
import 'package:epms/screen/supervisor_spb/supervisor_spb_menu/supervisor_spb_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SupervisorSPBScreen extends StatefulWidget {
  const SupervisorSPBScreen({Key? key}) : super(key: key);

  @override
  _SupervisorSPBScreenState createState() => _SupervisorSPBScreenState();
}

class _SupervisorSPBScreenState extends State<SupervisorSPBScreen> {
  int countInspection = 2;
  bool isShowMenuInspection = false;

  @override
  void initState() {
    context.read<HomeNotifier>().getUser(context);
    getMenuInspection();
    super.initState();
  }

  getMenuInspection() async {
    final isLoginInspectionSuccess =
        await StorageManager.readData('is_login_inspection_success');

    setState(() {
      isShowMenuInspection = isLoginInspectionSuccess;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeNotifier>(builder: (context, homeNotifier, child) {
      return Consumer<ThemeNotifier>(
        builder: (context, themeNotifier, child) {
          return MediaQuery(
            data: Style.mediaQueryText(context),
            child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                surfaceTintColor: themeNotifier.status == true ||
                        MediaQuery.of(context).platformBrightness ==
                            Brightness.dark
                    ? Colors.transparent
                    : Colors.white10,
                backgroundColor: themeNotifier.status == true ||
                        MediaQuery.of(context).platformBrightness ==
                            Brightness.dark
                    ? Colors.transparent
                    : Colors.white10,
                elevation: 0,
                actions: [
                  Consumer<ThemeNotifier>(
                    builder: (context, theme, child) => Flexible(
                      child: Switch(
                          activeColor: Palette.greenColor,
                          value: theme.status ?? true,
                          onChanged: (value) {
                            value ? theme.setDarkMode() : theme.setLightMode();
                          }),
                    ),
                  )
                ],
              ),
              body: Padding(
                padding: EdgeInsets.only(bottom: 10, left: 5, right: 5),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.only(left: 10, right: 10, bottom: 10),
                          child: Image.asset(ImageAssets.ANJ_LOGO, height: 60),
                        ),
                        Padding(
                          padding: EdgeInsets.all(6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                ImageAssets.SUPERVISI_SPB,
                                color: Palette.primaryColorProd,
                                height: 45,
                              ),
                              Text(
                                " SUPERVISI SPB",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Palette.primaryColorProd,
                                    fontSize: 18),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Palette.primaryColorProd,
                              minimumSize:
                                  Size(MediaQuery.of(context).size.width, 50),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  side: BorderSide(
                                      color: Palette.primaryColorProd)),
                              padding: const EdgeInsets.all(16.0),
                              textStyle: const TextStyle(
                                  fontSize: 20, color: Colors.white),
                            ),
                            onPressed: () {
                              SupervisorSPBNotifier()
                                  .onClickMenu(context, 'SUPERVISI SPB');
                            },
                            child: Text("SUPERVISI SPB",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Palette.primaryColorProd,
                              minimumSize:
                                  Size(MediaQuery.of(context).size.width, 50),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  side: BorderSide(
                                      color: Palette.primaryColorProd)),
                              padding: const EdgeInsets.all(16.0),
                              textStyle: const TextStyle(
                                  fontSize: 20, color: Colors.white),
                            ),
                            onPressed: () {
                              SupervisorSPBNotifier().onClickMenu(
                                  context, 'HISTORY GRADING TBS LUAR');
                            },
                            child: Text("HISTORY GRADING TBS LUAR",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Palette.primaryColorProd,
                              minimumSize:
                                  Size(MediaQuery.of(context).size.width, 50),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  side: BorderSide(
                                      color: Palette.primaryColorProd)),
                              padding: const EdgeInsets.all(16.0),
                              textStyle: const TextStyle(
                                  fontSize: 20, color: Colors.white),
                            ),
                            onPressed: () {
                              SupervisorSPBNotifier().onClickMenu(
                                  context, 'HISTORY SUPERVISI SPB');
                            },
                            child: Text("HISTORY SUPERVISI SPB",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Palette.primaryColorProd,
                              minimumSize:
                                  Size(MediaQuery.of(context).size.width, 50),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  side: BorderSide(
                                      color: Palette.primaryColorProd)),
                              padding: const EdgeInsets.all(16.0),
                              textStyle: const TextStyle(
                                  fontSize: 20, color: Colors.white),
                            ),
                            onPressed: () {
                              SupervisorSPBNotifier()
                                  .onClickMenu(context, 'BACA KARTU SPB');
                            },
                            child: Text("BACA KARTU SPB",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Palette.primaryColorProd,
                              minimumSize:
                                  Size(MediaQuery.of(context).size.width, 50),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  side: BorderSide(
                                      color: Palette.primaryColorProd)),
                              padding: const EdgeInsets.all(16.0),
                              textStyle: const TextStyle(
                                  fontSize: 20, color: Colors.white),
                            ),
                            onPressed: () {
                              SupervisorSPBNotifier()
                                  .onClickMenu(context, 'BACA KARTU TBS LUAR');
                            },
                            child: Text("BACA KARTU TBS LUAR",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        if (isShowMenuInspection)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextButton(
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Palette.primaryColorProd,
                                  minimumSize: Size(
                                      MediaQuery.of(context).size.width, 50),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      side: BorderSide(
                                          color: Palette.primaryColorProd)),
                                  padding: const EdgeInsets.all(16.0),
                                  textStyle: const TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                                onPressed: () {
                                  SupervisorSPBNotifier()
                                      .onClickMenu(context, 'INSPECTION');
                                },
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("INSPECTION",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold)),
                                      SizedBox(width: 10),
                                      homeNotifier.countInspection == 0
                                          ? const SizedBox()
                                          : Row(children: [
                                              Icon(Icons.warning,
                                                  color: Colors.yellow),
                                              SizedBox(width: 10),
                                              Text(
                                                  "${homeNotifier.countInspection}",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ])
                                    ])),
                          ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.green,
                              minimumSize:
                                  Size(MediaQuery.of(context).size.width, 50),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  side: BorderSide(color: Colors.green)),
                              padding: const EdgeInsets.all(16.0),
                              textStyle: const TextStyle(
                                  fontSize: 20, color: Colors.white),
                            ),
                            onPressed: () {
                              SupervisorSPBNotifier()
                                  .onClickMenu(context, 'UPLOAD DATA');
                            },
                            child: Text("UPLOAD DATA",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Palette.redColorLight,
                              minimumSize:
                                  Size(MediaQuery.of(context).size.width, 50),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  side:
                                      BorderSide(color: Palette.redColorLight)),
                              padding: const EdgeInsets.all(16.0),
                              textStyle: const TextStyle(
                                  fontSize: 20, color: Colors.white),
                            ),
                            onPressed: () {
                              SupervisorSPBNotifier()
                                  .onClickMenu(context, 'KELUAR');
                            },
                            child: Text("KELUAR",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 16),
                          child: Column(
                            children: [
                              Text("${homeNotifier.configSchema.employeeCode}",
                                  style: Style.textBold14),
                              Text("${homeNotifier.configSchema.employeeName}",
                                  style: Style.textBold14),
                              SizedBox(height: 30),
                              Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    child: Text("Sync Ulang"),
                                    onTap: () {
                                      SupervisorSPBNotifier().reSynch();
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    child: Text("Export Json"),
                                    onTap: () {
                                      SupervisorSPBNotifier()
                                          .exportJson(context);
                                    },
                                  ),
                                ),
                              ),
                              Divider(),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  ImageAssets.ANJ_LOGO,
                                  height: 25,
                                ),
                              ),
                              Text("ePMS ANJ Group")
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
    });
  }
}

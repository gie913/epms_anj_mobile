import 'package:epms/base/constants/image_assets.dart';
import 'package:epms/base/ui/palette.dart';
import 'package:epms/base/ui/style.dart';
import 'package:epms/base/ui/theme_notifier.dart';
import 'package:epms/common_manager/flushbar_manager.dart';
import 'package:epms/common_manager/inspection_service.dart';
import 'package:epms/database/service/database_ticket_inspection.dart';
import 'package:epms/database/service/database_todo_inspection.dart';
import 'package:epms/screen/home_inspection/home_inspection_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeInspectionScreen extends StatefulWidget {
  const HomeInspectionScreen({super.key});

  @override
  State<HomeInspectionScreen> createState() => _HomeInspectionScreenState();
}

class _HomeInspectionScreenState extends State<HomeInspectionScreen> {
  @override
  void initState() {
    context.read<HomeInspectionNotifier>().initData(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        onPopInvoked: (didPop) {},
        // onWillPop: () async => false,
        child: Consumer<HomeInspectionNotifier>(
          builder: (context, homeInspectionNotifier, _) {
            return MediaQuery(
              data: Style.mediaQueryText(context),
              child: Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  actions: [
                    Consumer<ThemeNotifier>(
                      builder: (context, theme, child) => Flexible(
                        child: Switch(
                            activeColor: Palette.greenColor,
                            value: theme.status ?? true,
                            onChanged: (value) {
                              value
                                  ? theme.setDarkMode()
                                  : theme.setLightMode();
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
                            padding: EdgeInsets.only(
                                left: 10, right: 10, bottom: 10),
                            child:
                                Image.asset(ImageAssets.ANJ_LOGO, height: 60),
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
                                  " USER INTRANET",
                                  style: Style.primaryBold18,
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
                                homeInspectionNotifier.goToMenuBacaKartuOPH();
                              },
                              child: Text("BACA KARTU OPH",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold)),
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
                              onPressed: () async {
                                await homeInspectionNotifier
                                    .goToMenuInspection();
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("INSPECTION",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(width: 4),
                                  homeInspectionNotifier.countInspection == 0
                                      ? const SizedBox()
                                      : Row(children: [
                                          Icon(Icons.warning,
                                              color: Colors.yellow, size: 18),
                                          SizedBox(width: 4),
                                          Text(
                                              "${homeInspectionNotifier.countInspection}",
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                overflow: TextOverflow.ellipsis,
                                              )),
                                        ]),
                                ],
                              ),
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
                                    side: BorderSide(
                                        color: Palette.redColorLight)),
                                padding: const EdgeInsets.all(16.0),
                                textStyle: const TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                              onPressed: () async {
                                final dataMyInspection =
                                    await DatabaseTicketInspection
                                        .selectDataNeedUpload();
                                final dataToDoInspection =
                                    await DatabaseTodoInspection
                                        .selectDataNeedUpload();
                                final isInternetExist = await InspectionService
                                    .isInternetConnectionExist();

                                final totalDataInspectionUnUpload =
                                    dataMyInspection.length +
                                        dataToDoInspection.length;

                                if (!isInternetExist) {
                                  FlushBarManager.showFlushBarWarning(
                                    context,
                                    "Gagal Logout",
                                    "Anda tidak memiliki akses internet",
                                  );
                                  return;
                                }

                                if (totalDataInspectionUnUpload != 0) {
                                  FlushBarManager.showFlushBarWarning(
                                    context,
                                    "Gagal Logout",
                                    "Anda memiliki inspection yang belum di upload",
                                  );
                                  return;
                                }

                                homeInspectionNotifier.showPopUpLogOut();
                              },
                              child: Text("KELUAR",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 16),
                            child: Column(
                              children: [
                                Text(
                                    "${homeInspectionNotifier.dataUser.employeeNumber}",
                                    style: Style.textBold14),
                                Text("${homeInspectionNotifier.dataUser.name}",
                                    style: Style.textBold14),
                                SizedBox(height: 30),
                                Divider(),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset(ImageAssets.ANJ_LOGO,
                                      height: 25),
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
        ));
  }
}

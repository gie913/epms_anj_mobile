import 'package:epms/base/constants/image_assets.dart';
import 'package:epms/base/ui/palette.dart';
import 'package:epms/base/ui/style.dart';
import 'package:epms/base/ui/theme_notifier.dart';
import 'package:epms/database/service/database_laporan_restan.dart';
import 'package:epms/model/laporan_restan.dart';
import 'package:epms/model/menu_entities.dart';
import 'package:epms/model/supervisor.dart';
import 'package:epms/screen/home/home_notifier.dart';
import 'package:epms/screen/kerani_kirim/kerani_kirim_menu/kerani_kirim_notifier.dart';
import 'package:epms/screen/kerani_panen/kerani_panen_menu/kerani_panen_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class KeraniKirimScreen extends StatefulWidget {
  const KeraniKirimScreen({Key? key}) : super(key: key);

  @override
  _KeraniKirimScreenState createState() => _KeraniKirimScreenState();
}

class _KeraniKirimScreenState extends State<KeraniKirimScreen> {
  Supervisor? supervisor;
  int countRestan = 0;

  @override
  void initState() {
    context.read<HomeNotifier>().getUser(context);
    getRestan();
    super.initState();
  }

  getRestan() async {
    List<LaporanRestan> count =
        await DatabaseLaporanRestan().selectLaporanRestan();
    setState(() {
      countRestan = count.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeNotifier>(builder: (context, login, child) {
      return Consumer<ThemeNotifier>(
        builder: (context, themeNotifier, child) {
          return MediaQuery(
            data: Style.mediaQueryText(context),
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: themeNotifier.status == true ||
                        MediaQuery.of(context).platformBrightness ==
                            Brightness.dark
                    ? Colors.transparent
                    : Colors.white10,
                automaticallyImplyLeading: false,
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
                          ))
                ],
              ),
              body: Container(
                padding: EdgeInsets.only(bottom: 10, left: 20, right: 20),
                child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: deliveryMenuEntries.length + 3,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: index == 0
                            ? Padding(
                                padding: EdgeInsets.only(
                                    left: 10, right: 10, bottom: 10),
                                child: Image.asset(
                                  ImageAssets.ANJ_LOGO,
                                  height: 60,
                                ),
                              )
                            : index == 1
                                ? Padding(
                                    padding: EdgeInsets.all(6),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          "assets/kerani-kirim.png",
                                          color: Palette.primaryColorProd,
                                          height: 45,
                                        ),
                                        Text(
                                          " KERANI KIRIM",
                                          style: Style.primaryBold18,
                                        )
                                      ],
                                    ))
                                : index == deliveryMenuEntries.length + 2
                                    ? Container(
                                        padding: EdgeInsets.only(top: 16),
                                        alignment: Alignment.center,
                                        child: Column(
                                          children: [
                                            Text(
                                              "${login.configSchema.employeeCode}",
                                              style: Style.textBold14,
                                            ),
                                            Text(
                                              "${login.configSchema.employeeName}",
                                              style: Style.textBold14,
                                            ),
                                            SizedBox(height: 20),
                                            Text(
                                              "Estate ${login.configSchema.estateCode}",
                                              style: Style.textBold14,
                                            ),
                                            SizedBox(height: 30),
                                            Card(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: InkWell(
                                                  child: Text("Synch Ulang"),
                                                  onTap: () {
                                                    KeraniPanenNotifier()
                                                        .reSynch();
                                                  },
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Card(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: InkWell(
                                                  child: Text("Export Json"),
                                                  onTap: () {
                                                    KeraniKirimNotifier()
                                                        .exportJson(context);
                                                  },
                                                ),
                                              ),
                                            ),
                                            Divider(),
                                            Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Image.asset(
                                                    ImageAssets.ANJ_LOGO,
                                                    height: 25,
                                                  ),
                                                ),
                                                Text("ePMS ANJ Group")
                                              ],
                                            )
                                          ],
                                        ),
                                      )
                                    : TextButton(
                                        style: TextButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          backgroundColor:
                                              colorCodesDelivery[index - 2],
                                          minimumSize: Size(
                                              MediaQuery.of(context).size.width,
                                              50),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                              side: BorderSide(
                                                  color: colorCodesDelivery[
                                                      index - 2])),
                                          padding: const EdgeInsets.all(16.0),
                                          textStyle: const TextStyle(
                                              fontSize: 20,
                                              color: Colors.white),
                                        ),
                                        onPressed: () {
                                          KeraniKirimNotifier().onClickMenu(
                                              deliveryMenuEntries, index);
                                        },
                                        child: deliveryMenuEntries[index - 2]
                                                    .toUpperCase() ==
                                                "LAPORAN RESTAN HARI INI"
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                    Text(
                                                        "${deliveryMenuEntries[index - 2].toUpperCase()}",
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    SizedBox(width: 10),
                                                    countRestan == 0
                                                        ? Container()
                                                        : Row(children: [
                                                            Icon(Icons.warning,
                                                                color: Colors
                                                                    .yellow),
                                                            SizedBox(width: 10),
                                                            Text("$countRestan",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
                                                          ])
                                                  ])
                                            : Text(
                                                "${deliveryMenuEntries[index - 2].toUpperCase()}",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                      ),
                      );
                    }),
              ),
            ),
          );
        },
      );
    });
  }
}

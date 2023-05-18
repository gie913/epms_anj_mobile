import 'package:epms/base/constants/image_assets.dart';
import 'package:epms/base/ui/palette.dart';
import 'package:epms/base/ui/style.dart';
import 'package:epms/base/ui/theme_notifier.dart';
import 'package:epms/database/service/database_laporan_restan.dart';
import 'package:epms/database/service/database_supervisor.dart';
import 'package:epms/model/laporan_restan.dart';
import 'package:epms/model/menu_entities.dart';
import 'package:epms/model/supervisor.dart';
import 'package:epms/screen/home/home_notifier.dart';
import 'package:epms/screen/kerani_panen/kerani_panen_menu/kerani_panen_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class KeraniPanenScreen extends StatefulWidget {
  const KeraniPanenScreen({Key? key}) : super(key: key);

  @override
  _KeraniPanenScreenState createState() => _KeraniPanenScreenState();
}

class _KeraniPanenScreenState extends State<KeraniPanenScreen> {
  Supervisor? supervisor;
  int countRestan = 0;

  @override
  void initState() {
    context.read<HomeNotifier>().getUser(context);
    getSupervisor();
    super.initState();
  }

  getSupervisor() async {
    Supervisor? _supervisor = await DatabaseSupervisor().selectSupervisor();
    List<LaporanRestan> count =
        await DatabaseLaporanRestan().selectLaporanRestan();
    setState(() {
      countRestan = count.length;
      supervisor = _supervisor;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeNotifier>(builder: (context, login, child) {
      return Scaffold(
        appBar: AppBar(
            leading: InkWell(
              child: Icon(Icons.account_box_rounded,
                  color: Palette.primaryColorProd),
              onTap: () {
                KeraniPanenNotifier().navigateToSupervisionForm();
              },
            ),
            backgroundColor: Colors.transparent,
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
            ]),
        body: Container(
          padding: EdgeInsets.only(bottom: 10, left: 20, right: 20),
          child: Column(children: [
            Flexible(
              child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: harvesterMenuEntries.length + 3,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        "assets/kerani-panen.png",
                                        color: Palette.primaryColorProd,
                                        height: 45,
                                      ),
                                      Text(
                                        "  KERANI PANEN",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Palette.primaryColorProd,
                                            fontSize: 18),
                                      )
                                    ],
                                  ))
                              : index == harvesterMenuEntries.length + 2
                                  ? Container(
                                      padding: EdgeInsets.only(top: 16),
                                      alignment: Alignment.center,
                                      child: Column(children: [
                                        Text(
                                            "${login.configSchema.employeeCode}",
                                            style: Style.textBold14),
                                        Text(
                                            "${login.configSchema.employeeName}",
                                            style: Style.textBold14),
                                        SizedBox(height: 20),
                                        Text(
                                            "Estate ${login.configSchema.estateCode}",
                                            style: Style.textBold14),
                                        SizedBox(height: 30),
                                        InkWell(
                                          onTap: () {
                                            KeraniPanenNotifier()
                                                .showDialogSupervisi(
                                                    supervisor!);
                                          },
                                          child: Text("Lihat Supervisi",
                                              style: Style.primaryBold16),
                                        ),
                                        SizedBox(height: 10),
                                        Divider(),
                                        Column(children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Image.asset(
                                              ImageAssets.ANJ_LOGO,
                                              height: 25,
                                            ),
                                          ),
                                          Text("ePMS ANJ Group")
                                        ])
                                      ]),
                                    )
                                  : TextButton(
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.white, backgroundColor:
                                            colorCodesHarvester[index - 2],
                                        minimumSize: Size(
                                            MediaQuery.of(context).size.width,
                                            50),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                            side: BorderSide(
                                                color: colorCodesHarvester[
                                                    index - 2])),
                                        padding: const EdgeInsets.all(16.0),
                                        textStyle: const TextStyle(
                                            fontSize: 20, color: Colors.white),
                                      ),
                                      onPressed: () {
                                        KeraniPanenNotifier().onClickedMenu(
                                            context,
                                            harvesterMenuEntries,
                                            index);
                                      },
                                      child: harvesterMenuEntries[index - 2]
                                                  .toUpperCase() ==
                                              "LAPORAN RESTAN HARI INI"
                                          ? Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                  Text(
                                                      "${harvesterMenuEntries[index - 2].toUpperCase()}",
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  SizedBox(width: 10),
                                                  Row(children: [
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
                                                ])
                                          : Text(
                                              "${harvesterMenuEntries[index - 2].toUpperCase()}",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold)),
                                    ),
                    );
                  }),
            ),
          ]),
        ),
      );
    });
  }
}

import 'package:epms/base/constants/image_assets.dart';
import 'package:epms/base/ui/palette.dart';
import 'package:epms/base/ui/style.dart';
import 'package:epms/base/ui/theme_notifier.dart';
import 'package:epms/model/menu_entities.dart';
import 'package:epms/screen/home/home_notifier.dart';
import 'package:epms/screen/kerani_panen/kerani_panen_menu/kerani_panen_notifier.dart';
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

  @override
  void initState() {
    context.read<HomeNotifier>().getUser(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeNotifier>(builder: (context, login, child) {
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
                        value ? theme.setDarkMode() : theme.setLightMode();
                      }),
                ),
              )
            ],
          ),
          body: Container(
            padding: EdgeInsets.only(bottom: 10, left: 20, right: 20, top: 20),
            child: Column(children: [
              Flexible(
                child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: supervisorSPBMenuEntries.length + 3,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            ImageAssets.SUPERVISI_SPB,
                                            color: Palette.primaryColorProd,
                                            height: 45,
                                          ),
                                          Text(
                                            "  SUPERVISI SPB",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Palette.primaryColorProd,
                                                fontSize: 18),
                                          )
                                        ]),
                                  )
                                : index == supervisorSPBMenuEntries.length + 2
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
                                            // Text(
                                            //   "Estate ${login.configSchema.estateCode}",
                                            //   style: Style.textBold14,
                                            // ),
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
                                                    SupervisorSPBNotifier()
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
                                        onPressed: () {
                                          SupervisorSPBNotifier()
                                              .onClickMenu(index);
                                        },
                                        style: TextButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          backgroundColor:
                                              colorCodesSupervisorSPB[
                                                  index - 2],
                                          minimumSize: Size(
                                              MediaQuery.of(context).size.width,
                                              50),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                              side: BorderSide(
                                                  color:
                                                      colorCodesSupervisorSPB[
                                                          index - 2])),
                                          padding: const EdgeInsets.all(16.0),
                                          textStyle: const TextStyle(
                                              fontSize: 20,
                                              color: Colors.white),
                                        ),
                                        child: Text(
                                            supervisorSPBMenuEntries[index - 2]
                                                .toUpperCase(),
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold)),
                                        // child: supervisorSPBMenuEntries[
                                        //                 index - 2]
                                        //             .toUpperCase() ==
                                        //         'INSPECTION'
                                        //     ? Row(
                                        //         mainAxisAlignment:
                                        //             MainAxisAlignment.center,
                                        //         children: [
                                        //             Text(
                                        //                 "${supervisorSPBMenuEntries[index - 2].toUpperCase()}",
                                        //                 style: TextStyle(
                                        //                     fontSize: 14,
                                        //                     fontWeight:
                                        //                         FontWeight
                                        //                             .bold)),
                                        //             SizedBox(width: 10),
                                        //             Row(children: [
                                        //               countInspection == 0
                                        //                   ? SizedBox()
                                        //                   : Row(children: [
                                        //                       Icon(
                                        //                           Icons.warning,
                                        //                           color: Colors
                                        //                               .yellow),
                                        //                       SizedBox(
                                        //                           width: 10),
                                        //                       Text(
                                        //                           "$countInspection",
                                        //                           style: TextStyle(
                                        //                               fontSize:
                                        //                                   14,
                                        //                               fontWeight:
                                        //                                   FontWeight
                                        //                                       .bold)),
                                        //                     ])
                                        //             ])
                                        //           ])
                                        //     : Text(
                                        //         supervisorSPBMenuEntries[
                                        //                 index - 2]
                                        //             .toUpperCase(),
                                        //         style: TextStyle(
                                        //             fontSize: 14,
                                        //             fontWeight:
                                        //                 FontWeight.bold)),
                                      ),
                      );
                    }),
              ),
            ]),
          ),
        ),
      );
    });
  }
}

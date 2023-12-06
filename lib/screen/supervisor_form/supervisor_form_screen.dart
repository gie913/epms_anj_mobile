import 'package:epms/base/constants/constanta.dart';
import 'package:epms/base/constants/image_assets.dart';
import 'package:epms/base/ui/palette.dart';
import 'package:epms/base/ui/style.dart';
import 'package:epms/model/m_employee_schema.dart';
import 'package:epms/screen/kerani_panen/kerani_panen_menu/kerani_panen_notifier.dart';
import 'package:epms/screen/search/search_employee_screen.dart';
import 'package:epms/screen/supervisor_form/supervisor_form_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SupervisorFormScreen extends StatefulWidget {
  final String? form;

  const SupervisorFormScreen({Key? key, this.form}) : super(key: key);

  @override
  _SupervisorFormScreenState createState() => _SupervisorFormScreenState();
}

class _SupervisorFormScreenState extends State<SupervisorFormScreen> {
  @override
  void initState() {
    context.read<SupervisorFormNotifier>().getSupervisi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // onWillPop: () async => false,
      canPop: false,
      onPopInvoked: (didPop) {},
      child: Consumer<SupervisorFormNotifier>(
        builder: (context, supervisor, child) {
          return Scaffold(
            body: MediaQuery(
              data: Style.mediaQueryText(context),
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
                        height: 60,
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Text(
                        "Halaman Supervisi",
                        style: Style.primaryBold16,
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Mandor:", style: Style.textBold16),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.6,
                                        child: Column(
                                          children: [
                                            Text(
                                              "${supervisor.mandorValue?.employeeCode ?? "Tidak ada data"}",
                                              style: Style.textBold14,
                                            ),
                                            Text(
                                                "${supervisor.mandorValue?.employeeName ?? "belum di mapping"}")
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(Icons.search),
                                    ),
                                  ),
                                  onTap: () async {
                                    MEmployeeSchema? mEmployee =
                                        await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SearchEmployeeScreen()));
                                    if (mEmployee != null) {
                                      supervisor.onSetSupervisi(mEmployee);
                                    }
                                  },
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text("Mandor 1:", style: Style.textBold16),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.6,
                                        child: Column(
                                          children: [
                                            Text(
                                              "${supervisor.mandorValue1?.employeeCode ?? "Tidak ada data"}",
                                              style: Style.textBold14,
                                            ),
                                            Text(
                                                "${supervisor.mandorValue1?.employeeName ?? "belum di mapping"}")
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  child: Card(
                                      child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(Icons.search),
                                  )),
                                  onTap: () async {
                                    MEmployeeSchema? mEmployee =
                                        await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SearchEmployeeScreen()));
                                    if (mEmployee != null) {
                                      supervisor.onSetSupervisi1(mEmployee);
                                    }
                                  },
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Text("Kerani Panen:", style: Style.textBold16),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.6,
                                        child: Column(
                                          children: [
                                            Text(
                                              "${supervisor.keraniPanenValue?.employeeCode ?? "Tidak ada data"}",
                                              style: Style.textBold14,
                                            ),
                                            Text(
                                                "${supervisor.keraniPanenValue?.employeeName ?? "belum di mapping"}")
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(Icons.search),
                                    ),
                                  ),
                                  onTap: () async {
                                    MEmployeeSchema? mEmployee =
                                        await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SearchEmployeeScreen()));
                                    if (mEmployee != null) {
                                      supervisor.onSetKeraniPanen(mEmployee);
                                    }
                                  },
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Text("Kerani Kirim:", style: Style.textBold16),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.6,
                                        child: Column(
                                          children: [
                                            Text(
                                              "${supervisor.keraniKirimValue?.employeeCode ?? "Tidak ada data"}",
                                              style: Style.textBold14,
                                            ),
                                            Text(
                                                "${supervisor.keraniKirimValue?.employeeName ?? "belum di mapping"}")
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(Icons.search),
                                    ),
                                  ),
                                  onTap: () async {
                                    MEmployeeSchema? mEmployee =
                                        await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SearchEmployeeScreen()));
                                    if (mEmployee != null) {
                                      supervisor.onSetKeraniKirim(mEmployee);
                                    }
                                  },
                                ),
                              ],
                            ),
                            SizedBox(height: 30),
                            InkWell(
                              onTap: () {
                                supervisor.onSaveClick(context);
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
                                  child: Text(
                                    "SIMPAN",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            widget.form == "Home"
                                ? InkWell(
                                    onTap: () {
                                      supervisor.onCancelClick(context);
                                    },
                                    child: Card(
                                      color: Palette.redColorLight,
                                      elevation: 2,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Container(
                                        padding: EdgeInsets.all(14),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Text(
                                          "KEMBALI",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(),
                            SizedBox(height: 30),
                            Divider(),
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  child: Text("Synch Ulang"),
                                  onTap: () {
                                    KeraniPanenNotifier().reSynch();
                                  },
                                ),
                              ),
                            ),
                            Column(
                              children: [
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
          );
        },
      ),
    );
  }
}

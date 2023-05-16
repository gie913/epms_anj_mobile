import 'package:epms/base/ui/palette.dart';
import 'package:epms/base/ui/style.dart';
import 'package:epms/common_manager/time_manager.dart';
import 'package:epms/model/m_attendance_schema.dart';
import 'package:epms/screen/kerani_panen/attendance/attendance_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({Key? key}) : super(key: key);

  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  @override
  void initState() {
    context.read<AttendanceNotifier>().getMandorEmployee();
    context.read<AttendanceNotifier>().getAttendanceList();
    context.read<AttendanceNotifier>().getMAttendanceSchema();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child:
          Consumer<AttendanceNotifier>(builder: (context, attendance, child) {
        return MediaQuery(
          data: Style.mediaQueryText(context),
          child: Scaffold(
            appBar: AppBar(title: Text("Absensi")),
            body: Column(
              children: [
                Card(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Tanggal:"),
                            Text(
                                "${TimeManager.dateWithDash(DateTime.now())} ${TimeManager.timeWithColon(DateTime.now())}")
                          ],
                        ),
                        SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Kode Mandor:"),
                            Text(
                                "${attendance.tUserAssignmentSchema.mandorEmployeeCode ?? "-"}")
                          ],
                        ),
                        SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Nama Mandor:"),
                            Text(
                                "${attendance.tUserAssignmentSchema.mandorEmployeeName ?? "-"}"),
                          ],
                        ),
                        SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Jumlah Pekerja:"),
                            Text("${attendance.tAttendanceList.length}"),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Divider(),
                Flexible(
                  child: ListView.builder(
                      itemCount: attendance.tAttendanceList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 180,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          "${attendance.tAttendanceList[index].attendanceEmployeeCode}"),
                                      SizedBox(height: 12),
                                      Text(
                                          "${attendance.tAttendanceList[index].attendanceEmployeeName}")
                                    ],
                                  ),
                                ),
                                Flexible(
                                  child: Container(
                                    child: DropdownButton(
                                      isExpanded: true,
                                      value:
                                          attendance.listAttendanceValue[index],
                                      items: attendance.mAttendanceSchema
                                          .map((MAttendanceSchema value) {
                                        return DropdownMenuItem<
                                            MAttendanceSchema>(
                                          child: Text(
                                            "${value.attendanceCode!} - ${value.attendanceDesc!}",
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          value: value,
                                        );
                                      }).toList(),
                                      onChanged: (MAttendanceSchema? value) {
                                        attendance.onChangeAttendance(
                                            value!, index);
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      attendance.onClickSave();
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
                          style: Style.whiteBold18,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

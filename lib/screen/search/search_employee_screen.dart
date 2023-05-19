import 'dart:convert';

import 'package:epms/base/ui/palette.dart';
import 'package:epms/base/ui/style.dart';
import 'package:epms/database/service/database_m_config.dart';
import 'package:epms/database/service/database_m_employee.dart';
import 'package:epms/database/service/database_t_user_assignment.dart';
import 'package:epms/model/m_config_schema.dart';
import 'package:epms/model/m_employee_schema.dart';
import 'package:epms/model/t_user_assignment_schema.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/rpg_awesome_icons.dart';

class SearchEmployeeScreen extends StatefulWidget {
  @override
  _SearchEmployeeScreenState createState() => _SearchEmployeeScreenState();
}

class _SearchEmployeeScreenState extends State<SearchEmployeeScreen> {
  TextEditingController typeEmployeeController = TextEditingController();

  TextEditingController typeAssignmentController = TextEditingController();

  bool isFiltered = true;
  String? valFarmer;
  bool isLoading = true;
  ScrollController? scrollController;

  List<MEmployeeSchema> _searchEmployeeResult = [];

  List<MEmployeeSchema> _employeeDetails = [];

  List<TUserAssignmentSchema> _tUserAssignmentList = [];

  List<TUserAssignmentSchema> _tUserAssignmentResult = [];

  @override
  void initState() {
    getEmployeeList();
    getUserAssignmentList();
    super.initState();
  }

  getEmployeeList() async {
    isLoading = true;
    List<MEmployeeSchema> listEmployee =
        await DatabaseMEmployeeSchema().selectMEmployeeSchema();
    setState(() {
      _employeeDetails = listEmployee;
      isLoading = false;
    });
  }

  getUserAssignmentList() async {
    MConfigSchema mConfigSchema = await DatabaseMConfig().selectMConfig();
    isLoading = true;
    List<TUserAssignmentSchema> listUserAssignment =
        await DatabaseTUserAssignment()
            .selectEmployeeTUserAssignment(mConfigSchema);
    setState(() {
      _tUserAssignmentList = listUserAssignment;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text("Pencarian Karyawan"))),
      body: MediaQuery(
        data: Style.mediaQueryText(context),
        child: Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Filter berdasarkan kemandoran:"),
                    Flexible(
                      child: Switch(
                          activeColor: Palette.greenColor,
                          value: isFiltered,
                          onChanged: (value) {
                            setState(() {
                              isFiltered = value;
                            });
                          }),
                    )
                  ],
                ),
              ),
              isFiltered ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: Container(
                    child: ListTile(
                      leading: Icon(Icons.search),
                      title: TextField(
                        controller: typeAssignmentController,
                        decoration: InputDecoration(
                            hintText: "Pencarian", border: InputBorder.none),
                        onChanged: onSearchTextChangedTUserAssignment,
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.cancel),
                        onPressed: () {
                          typeAssignmentController.clear();
                          onSearchTextChangedTUserAssignment('');
                        },
                      ),
                    ),
                  ),
                ),
              ) : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: Container(
                    child: ListTile(
                      leading: Icon(Icons.search),
                      title: TextField(
                        controller: typeEmployeeController,
                        decoration: InputDecoration(
                            hintText: "Pencarian", border: InputBorder.none),
                        onChanged: onSearchTextChanged,
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.cancel),
                        onPressed: () {
                          typeEmployeeController.clear();
                          onSearchTextChanged('');
                        },
                      ),
                    ),
                  ),
                ),
              ),
              isLoading
                  ? CircularProgressIndicator()
                  : !isFiltered ? _employeeDetails.isNotEmpty
                      ? Flexible(
                          child: Container(
                            child: _searchEmployeeResult.length != 0 ||
                                    typeEmployeeController.text.isNotEmpty
                                ? ListView.builder(
                                    controller: scrollController,
                                    physics: AlwaysScrollableScrollPhysics(),
                                    itemCount: _searchEmployeeResult.length,
                                    itemBuilder: (context, index) => Container(
                                          child: Card(
                                            child: Container(
                                              child: ListTile(
                                                title: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "${_searchEmployeeResult[index].employeeCode}",
                                                      style: Style.textBold14,
                                                    ),
                                                    Text(
                                                        "${_searchEmployeeResult[index].employeeName}"),
                                                  ],
                                                ),
                                                trailing: InkWell(
                                                  onTap: () {
                                                    Navigator.pop(
                                                        context,
                                                        _searchEmployeeResult[
                                                            index]);
                                                  },
                                                  child: Card(
                                                    color:
                                                        Palette.primaryColorProd,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Icon(
                                                        Icons
                                                            .check_circle_outline,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ))
                                : _employeeDetails.length != 0
                                    ? ListView.builder(
                                        controller: scrollController,
                                        physics: AlwaysScrollableScrollPhysics(),
                                        itemCount: _employeeDetails.length,
                                        itemBuilder: (context, index) =>
                                            Container(
                                          child: Card(
                                            child: Container(
                                              child: ListTile(
                                                title: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "${_employeeDetails[index].employeeCode}",
                                                      style: Style.textBold14,
                                                    ),
                                                    Text(
                                                        "${_employeeDetails[index].employeeName}"),
                                                  ],
                                                ),
                                                trailing: InkWell(
                                                  onTap: () {
                                                    Navigator.pop(context,
                                                        _employeeDetails[index]);
                                                  },
                                                  child: Card(
                                                    color:
                                                        Palette.primaryColorProd,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Icon(
                                                        Icons
                                                            .check_circle_outline,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : Flexible(
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(RpgAwesome.palm_tree,
                                                  color: Colors.orange, size: 60),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 20.0),
                                                child: Text("Belum ada Pekerja"),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                          ),
                        )
                      : Flexible(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(RpgAwesome.palm_tree,
                                    color: Colors.orange, size: 60),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                  child: Text("Belum ada Pekerja"),
                                ),
                              ],
                            ),
                          ),
                        ) : _tUserAssignmentList.isNotEmpty
                  ? Flexible(
                child: Container(
                  child: _tUserAssignmentResult.length != 0 ||
                      typeAssignmentController.text.isNotEmpty
                      ? ListView.builder(
                      controller: scrollController,
                      physics: AlwaysScrollableScrollPhysics(),
                      itemCount: _tUserAssignmentResult.length,
                      itemBuilder: (context, index) => Container(
                        child: Card(
                          child: Container(
                            child: ListTile(
                              title: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.start,
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${_tUserAssignmentResult[index].employeeCode}",
                                    style: Style.textBold14,
                                  ),
                                  Text(
                                      "${_tUserAssignmentResult[index].employeeName}"),
                                ],
                              ),
                              trailing: InkWell(
                                onTap: () {
                                  String string = jsonEncode(_tUserAssignmentResult[index]);
                                  Map<String, dynamic> map = jsonDecode(string);
                                  MEmployeeSchema employee = MEmployeeSchema.fromJson(map);
                                  Navigator.pop(context, employee);
                                },
                                child: Card(
                                  color:
                                  Palette.primaryColorProd,
                                  child: Padding(
                                    padding:
                                    const EdgeInsets.all(
                                        8.0),
                                    child: Icon(
                                      Icons
                                          .check_circle_outline,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ))
                      : _tUserAssignmentList.length != 0
                      ? ListView.builder(
                    controller: scrollController,
                    physics: AlwaysScrollableScrollPhysics(),
                    itemCount: _tUserAssignmentList.length,
                    itemBuilder: (context, index) =>
                        Container(
                          child: Card(
                            child: Container(
                              child: ListTile(
                                title: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.start,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${_tUserAssignmentList[index].employeeCode}",
                                      style: Style.textBold14,
                                    ),
                                    Text(
                                        "${_tUserAssignmentList[index].employeeName}"),
                                  ],
                                ),
                                trailing: InkWell(
                                  onTap: () {
                                    String string = jsonEncode(_tUserAssignmentList[index]);
                                    Map<String, dynamic> map = jsonDecode(string);
                                    MEmployeeSchema employee = MEmployeeSchema.fromJson(map);
                                    Navigator.pop(context, employee);
                                  },
                                  child: Card(
                                    color:
                                    Palette.primaryColorProd,
                                    child: Padding(
                                      padding:
                                      const EdgeInsets.all(
                                          8.0),
                                      child: Icon(
                                        Icons
                                            .check_circle_outline,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                  )
                      : Flexible(
                    child: Center(
                      child: Column(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: [
                          Icon(RpgAwesome.palm_tree,
                              color: Colors.orange, size: 60),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 20.0),
                            child: Text("Belum ada Pekerja"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
                  : Flexible(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(RpgAwesome.palm_tree,
                          color: Colors.orange, size: 60),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Text("Belum ada Pekerja"),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  onSearchTextChanged(String text) async {
    _searchEmployeeResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }
    _employeeDetails.forEach((farmerDetail) {
      if (farmerDetail.employeeName!
              .toLowerCase()
              .contains(text.toLowerCase()) ||
          farmerDetail.employeeCode!.toLowerCase().contains(text.toLowerCase()))
        _searchEmployeeResult.add(farmerDetail);
    });
    setState(() {});
  }

  onSearchTextChangedTUserAssignment(String text) async {
    _tUserAssignmentResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }
    _tUserAssignmentList.forEach((farmerDetail) {
      if (farmerDetail.employeeName!
              .toLowerCase()
              .contains(text.toLowerCase()) ||
          farmerDetail.employeeCode!.toLowerCase().contains(text.toLowerCase()))
        _tUserAssignmentResult.add(farmerDetail);
    });
    setState(() {});
  }
}

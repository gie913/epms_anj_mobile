import 'package:epms/database/service/database_t_workplan_schema.dart';
import 'package:epms/model/t_work_plan_schema.dart';
import 'package:flutter/material.dart';

class WorkPlanNotifier extends ChangeNotifier {

  List<TWorkplanSchema> _listWorkPlan = [];

  List<TWorkplanSchema> get listWorkPlan => _listWorkPlan;

  onInit() async {
    _listWorkPlan = await DatabaseTWorkplanSchema().selectTWorkPlan();
    notifyListeners();
  }
}
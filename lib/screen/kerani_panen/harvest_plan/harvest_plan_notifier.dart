
import 'package:epms/database/service/database_harvesting_plan.dart';
import 'package:epms/model/t_harvesting_plan_schema.dart';
import 'package:flutter/material.dart';

class HarvestPlanNotifier extends ChangeNotifier {
  List<THarvestingPlanSchema> _listHarvestingPlanSchema = [];

  List<THarvestingPlanSchema> get listHarvestingPlanSchema =>
      _listHarvestingPlanSchema;

  getListHarvestPlan() async {
    _listHarvestingPlanSchema =
        await DatabaseTHarvestingPlan().selectTHarvestingPlan();
    notifyListeners();
  }
}

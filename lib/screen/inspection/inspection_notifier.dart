import 'dart:developer';

import 'package:epms/database/service/database_member_inspection.dart';
import 'package:epms/database/service/database_team_inspection.dart';
import 'package:epms/database/service/database_user_inspection.dart';
import 'package:flutter/material.dart';

class InspectionNotifier extends ChangeNotifier {
  Future<void> getTeamInspection() async {
    final listTeamInspection = await DatabaseTeamInspection.selectData();
    log('cek listTeamInspection : $listTeamInspection');
  }

  Future<void> getMemberInspection() async {
    final listMemberInspection = await DatabaseMemberInspection.selectData();
    log('cek listMemberInspection : $listMemberInspection');
  }

  Future<void> getUserInspection() async {
    final listUserInspection = await DatabaseUserInspection.selectData();
    log('cek listUserInspection : $listUserInspection');
  }
}

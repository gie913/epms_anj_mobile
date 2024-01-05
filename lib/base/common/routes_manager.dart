import 'package:epms/base/common/routes.dart';
import 'package:epms/model/laporan_restan.dart';
import 'package:epms/model/laporan_spb_kemarin.dart';
import 'package:epms/model/spb_supervise.dart';
import 'package:epms/model/ticket_inspection_model.dart';
import 'package:epms/screen/configuration/configuration_page.dart';
import 'package:epms/screen/home/home_page.dart';
import 'package:epms/screen/home_inspection/home_inspection_page.dart';
import 'package:epms/screen/inspection/inspection_approval_view.dart';
import 'package:epms/screen/inspection/inspection_assignment_detail_view.dart';
import 'package:epms/screen/inspection/inspection_detail_view.dart';
import 'package:epms/screen/inspection/inspection_form_view.dart';
import 'package:epms/screen/inspection/inspection_list_view.dart';
import 'package:epms/screen/inspection/inspection_location_view.dart';
import 'package:epms/screen/inspection/inspection_page.dart';
import 'package:epms/screen/inspection/inspection_user_view.dart';
import 'package:epms/screen/kerani_kirim/administration_spb/administration_spb_screen.dart';
import 'package:epms/screen/kerani_kirim/detail_spb/detail_spb_page.dart';
import 'package:epms/screen/kerani_kirim/edit_spb/edit_spb_page.dart';
import 'package:epms/screen/kerani_kirim/form_spb/form_spb_page.dart';
import 'package:epms/screen/kerani_kirim/history_spb/history_spb_page.dart';
import 'package:epms/screen/kerani_kirim/laporan_spb_kemarin/detail_spb_kemarin_screen.dart';
import 'package:epms/screen/kerani_kirim/laporan_spb_kemarin/laporan_spb_kemarin_page.dart';
import 'package:epms/screen/kerani_panen/attendance/attendance_page.dart';
import 'package:epms/screen/kerani_panen/bagi_oph/bagi_oph_page.dart';
import 'package:epms/screen/kerani_panen/detail_oph/detail_oph_page.dart';
import 'package:epms/screen/kerani_panen/form_oph/form_oph_page.dart';
import 'package:epms/screen/kerani_panen/harvest_plan/harvest_plan_page.dart';
import 'package:epms/screen/kerani_panen/harvest_report_yesterday/harvest_report_yesterday_page.dart';
import 'package:epms/screen/kerani_panen/history_oph/history_oph_page.dart';
import 'package:epms/screen/kerani_panen/kerani_panen_menu/administration_oph.dart';
import 'package:epms/screen/kerani_panen/restan_report/detail_restan_screen.dart';
import 'package:epms/screen/kerani_panen/restan_report/restan_report_page.dart';
import 'package:epms/screen/login/login_page.dart';
import 'package:epms/screen/splash/splash_screen.dart';
import 'package:epms/screen/supervisor/history_supervise_harvest/history_supervise_harvest_page.dart';
import 'package:epms/screen/supervisor/history_supervisor_ancak/history_supervisor_ancak_page.dart';
import 'package:epms/screen/supervisor/supervisor_ancak_harvest_form/supervisor_ancak_harvest_form_page.dart';
import 'package:epms/screen/supervisor/supervisor_harvest_form/supervisor_harvest_form_page.dart';
import 'package:epms/screen/supervisor/workplan/workplan_page.dart';
import 'package:epms/screen/supervisor_form/supervisor_form_page.dart';
import 'package:epms/screen/supervisor_spb/supervisi_spb_form/supervisor_spb_form_page.dart';
import 'package:epms/screen/supervisor_spb/supervisi_tbs_luar_detail/supervisor_tbs_luar_detail_page.dart';
import 'package:epms/screen/supervisor_spb/supervisi_tbs_luar_form/supervisor_tbs_luar_form_page.dart';
import 'package:epms/screen/supervisor_spb/supervisi_tbs_luar_history/supervisor_tbs_luar_history_page.dart';
import 'package:epms/screen/supervisor_spb/supervisor_spb_detail/supervisor_spb_detail_page.dart';
import 'package:epms/screen/supervisor_spb/supervisor_spb_history/supervisor_spb_history_page.dart';
import 'package:epms/screen/synch/synch_page.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case Routes.ROOT:
      return MaterialPageRoute(
        builder: (context) => SplashScreen(),
      );
    case Routes.LOGIN_PAGE:
      return MaterialPageRoute(
        builder: (context) => LoginPage(),
      );

    case Routes.HOME_PAGE:
      // int current = settings.arguments as int;
      return MaterialPageRoute(
        builder: (context) => HomePage(),
      );
    case Routes.HOME_INSPECTION_PAGE:
      // int current = settings.arguments as int;
      return MaterialPageRoute(
        builder: (context) => HomeInspectionPage(),
      );

    case Routes.CONFIGURATION_PAGE:
      // int current = settings.arguments as int;
      return MaterialPageRoute(
        builder: (context) => ConfigurationPage(),
      );
    //
    case Routes.SUPERVISOR_FORM_PAGE:
      String? form = settings.arguments as String?;
      return MaterialPageRoute(
        builder: (context) => SupervisorFormPage(form: form),
      );

    case Routes.ATTENDANCE_PAGE:
      // int current = settings.arguments as int;
      return MaterialPageRoute(
        builder: (context) => AttendancePage(),
      );

    case Routes.SYNCH_PAGE:
      // int current = settings.arguments as int;
      return MaterialPageRoute(
        builder: (context) => SynchPage(),
      );

    case Routes.OPH_FORM_PAGE:
      // int current = settings.arguments as int;
      return MaterialPageRoute(
        builder: (context) => FormOPHPage(),
      );

    case Routes.OPH_HISTORY_PAGE:
      String? method = settings.arguments as String;
      return MaterialPageRoute(
        builder: (context) => HistoryOPHPage(method: method),
      );

    case Routes.OPH_DETAIL_PAGE:
      final arguments = (settings.arguments ?? <String, dynamic>{}) as Map;
      return MaterialPageRoute(
        builder: (context) => DetailOPHPage(
          method: arguments['method'],
          oph: arguments['oph'],
          restan: arguments['restan'],
        ),
      );

    case Routes.PANEN_KEMARIN:
      // final arguments = (settings.arguments  ?? <String, dynamic>{}) as Map;
      return MaterialPageRoute(
        builder: (context) => HarvestReportYesterdayPage(),
      );

    case Routes.RESTAN_REPORT:
      String? method = settings.arguments as String;
      return MaterialPageRoute(
        builder: (context) => RestanReportPage(method: method),
      );

    case Routes.ADMIN_OPH:
      return MaterialPageRoute(
        builder: (context) => AdministrationOPHScreen(),
      );

    case Routes.HARVEST_PLAN:
      return MaterialPageRoute(
        builder: (context) => HarvestPlanPage(),
      );

    case Routes.BAGI_OPH:
      return MaterialPageRoute(
        builder: (context) => BagiOPHPage(),
      );

    case Routes.RESTAN_DETAIL:
      LaporanRestan laporanRestan = settings.arguments as LaporanRestan;
      return MaterialPageRoute(
        builder: (context) => DetailRestanScreen(laporanRestan: laporanRestan),
      );

    case Routes.SPB_KEMARIN_DETAIL:
      LaporanSPBKemarin laporanSPBKemarin =
          settings.arguments as LaporanSPBKemarin;
      return MaterialPageRoute(
        builder: (context) =>
            DetailSPBKemarinScreen(laporanSPBKemarin: laporanSPBKemarin),
      );

    case Routes.REPORT_SPB_KEMARIN:
      return MaterialPageRoute(
        builder: (context) => LaporanSPBKemarinPage(),
      );

    case Routes.SPB_FORM_PAGE:
      return MaterialPageRoute(
        builder: (context) => FormSPBPage(),
      );

    case Routes.SPB_HISTORY_PAGE:
      String method = settings.arguments as String;
      return MaterialPageRoute(
        builder: (context) => HistorySPBPage(method: method),
      );

    case Routes.ADMIN_SPB:
      return MaterialPageRoute(
        builder: (context) => AdministrationSPBScreen(),
      );

    case Routes.SPB_DETAIL_PAGE:
      final arguments = (settings.arguments ?? <String, dynamic>{}) as Map;
      return MaterialPageRoute(
        builder: (context) =>
            DetailSPBPage(spb: arguments["spb"], method: arguments["method"]),
      );

    case Routes.EDIT_SPB:
      final argument = (settings.arguments ?? <String, dynamic>{}) as Map;
      return MaterialPageRoute(
        builder: (context) => EditSPBPage(
            spb: argument["spb"],
            spbDetail: argument["spb_detail"],
            spbLoader: argument["spb_loader"]),
      );

    case Routes.SPB_SUPERVISI_FORM_PAGE:
      return MaterialPageRoute(
        builder: (context) => SupervisorSPBFormPage(),
      );

    case Routes.SPB_SUPERVISI_HISTORY_PAGE:
      return MaterialPageRoute(
        builder: (context) => SupervisorSPBHistoryPage(),
      );

    case Routes.TBS_LUAR_HISTORY_PAGE:
      return MaterialPageRoute(
        builder: (context) => SupervisorTBSLuarHistoryPage(),
      );

    case Routes.SPB_SUPERVISI_DETAIL_PAGE:
      final argument = settings.arguments as SPBSupervise;
      return MaterialPageRoute(
        builder: (context) => SupervisorSPBDetailPage(spbSupervise: argument),
      );

    case Routes.WORK_PLAN:
      return MaterialPageRoute(
        builder: (context) => WorkPlanPage(),
      );

    case Routes.OPH_SUPERVISI_HISTORY_PAGE:
      return MaterialPageRoute(
        builder: (context) => HistorySuperviseHarvestPage(),
      );

    case Routes.OPH_SUPERVISI_ANCAK_HISTORY_PAGE:
      return MaterialPageRoute(
        builder: (context) => HistorySuperviseAncakPage(),
      );

    case Routes.OPH_SUPERVISI_FORM_PAGE:
      return MaterialPageRoute(
        builder: (context) => SupervisorHarvestFormPage(),
      );

    case Routes.OPH_SUPERVISI_ANCAK_FORM_PAGE:
      return MaterialPageRoute(
        builder: (context) => SupervisorAncakHarvestFormPage(),
      );
    case Routes.TBS_LUAR_FORM_PAGE:
      return MaterialPageRoute(
        builder: (context) => SupervisorTBSLuarFormPage(),
      );

    case Routes.TBS_LUAR_DETAIL_PAGE:
      final arguments = (settings.arguments ?? <String, dynamic>{}) as Map;
      return MaterialPageRoute(
        builder: (context) => SupervisorTBSLuarDetailPage(
          tbsLuar: arguments['tbs_luar'],
          method: arguments['method'],
        ),
      );
    case Routes.INSPECTION:
      final arguments =
          settings.arguments != null ? settings.arguments as String : '';
      return MaterialPageRoute(
        builder: (context) => InspectionPage(arguments: arguments),
      );
    case Routes.INSPECTION_FORM:
      return MaterialPageRoute(
        builder: (context) => InspectionFormView(),
      );
    case Routes.INSPECTION_LIST:
      final arguments = settings.arguments != null
          ? settings.arguments as List<TicketInspectionModel>
          : const <TicketInspectionModel>[];
      return MaterialPageRoute(
        builder: (context) => InspectionListView(listMyInspection: arguments),
      );
    case Routes.INSPECTION_ASSIGNMENT_DETAIL:
      final arguments = settings.arguments != null
          ? settings.arguments as TicketInspectionModel
          : const TicketInspectionModel();
      return MaterialPageRoute(
        builder: (context) => InspectionAssignmentDetailView(data: arguments),
      );
    case Routes.INSPECTION_DETAIL:
      final arguments = settings.arguments != null
          ? settings.arguments as TicketInspectionModel
          : const TicketInspectionModel();
      return MaterialPageRoute(
        builder: (context) => InspectionDetailView(data: arguments),
      );
    case Routes.INSPECTION_APPROVAL:
      final arguments = settings.arguments != null
          ? settings.arguments as TicketInspectionModel
          : const TicketInspectionModel();
      return MaterialPageRoute(
        builder: (context) => InspectionApprovalView(data: arguments),
      );
    case Routes.INSPECTION_USER:
      final arguments =
          settings.arguments != null ? settings.arguments as String : '';
      return MaterialPageRoute(
        builder: (context) => InspectionUserView(companyId: arguments),
      );
    case Routes.INSPECTION_LOCATION:
      final arguments =
          settings.arguments != null ? settings.arguments as Map : {};
      return MaterialPageRoute(
        builder: (context) => InspectionLocationView(
          latitude: arguments['latitude'],
          longitude: arguments['longitude'],
          company: arguments['company'],
        ),
      );
    default:
      return MaterialPageRoute(
        builder: (context) => Scaffold(
          body: Center(
            child: Text('Route not defined'),
          ),
        ),
      );
  }
}

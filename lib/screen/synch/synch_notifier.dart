import 'dart:convert';
import 'dart:developer';

import 'package:epms/base/common/locator.dart';
import 'package:epms/base/common/routes.dart';
import 'package:epms/base/constants/globals.dart' as globals;
import 'package:epms/common_manager/dialog_services.dart';
import 'package:epms/common_manager/navigator_service.dart';
import 'package:epms/common_manager/storage_manager.dart';
import 'package:epms/common_manager/time_manager.dart';
import 'package:epms/common_manager/value_service.dart';
import 'package:epms/database/service/database_action_inspection.dart';
import 'package:epms/database/service/database_activity.dart';
import 'package:epms/database/service/database_attachment_inspection.dart';
import 'package:epms/database/service/database_attendance.dart';
import 'package:epms/database/service/database_company_inspection.dart';
import 'package:epms/database/service/database_cost_control.dart';
import 'package:epms/database/service/database_destination.dart';
import 'package:epms/database/service/database_division_inspection.dart';
import 'package:epms/database/service/database_estate_inspection.dart';
import 'package:epms/database/service/database_harvesting_plan.dart';
import 'package:epms/database/service/database_laporan_panen_kemarin.dart';
import 'package:epms/database/service/database_laporan_restan.dart';
import 'package:epms/database/service/database_laporan_spb_kemarin.dart';
import 'package:epms/database/service/database_m_ancak_employee.dart';
import 'package:epms/database/service/database_m_attendance.dart';
import 'package:epms/database/service/database_m_block.dart';
import 'package:epms/database/service/database_m_config.dart';
import 'package:epms/database/service/database_m_customer_code.dart';
import 'package:epms/database/service/database_m_division.dart';
import 'package:epms/database/service/database_m_employee.dart';
import 'package:epms/database/service/database_m_estate.dart';
import 'package:epms/database/service/database_m_material.dart';
import 'package:epms/database/service/database_m_tph.dart';
import 'package:epms/database/service/database_m_vendor.dart';
import 'package:epms/database/service/database_m_vra.dart';
import 'package:epms/database/service/database_material.dart';
import 'package:epms/database/service/database_mc_oph.dart';
import 'package:epms/database/service/database_mc_spb.dart';
import 'package:epms/database/service/database_member_inspection.dart';
import 'package:epms/database/service/database_response_inspection.dart';
import 'package:epms/database/service/database_subordinate_inspection.dart';
import 'package:epms/database/service/database_supervisor.dart';
import 'package:epms/database/service/database_t_abw.dart';
import 'package:epms/database/service/database_t_auth.dart';
import 'package:epms/database/service/database_t_user_assignment.dart';
import 'package:epms/database/service/database_t_workplan_schema.dart';
import 'package:epms/database/service/database_tbs_luar.dart';
import 'package:epms/database/service/database_tbs_luar_one_month.dart';
import 'package:epms/database/service/database_team_inspection.dart';
import 'package:epms/database/service/database_ticket_inspection.dart';
import 'package:epms/database/service/database_todo_inspection.dart';
import 'package:epms/database/service/database_user_inspection.dart';
import 'package:epms/model/m_config_schema.dart';
import 'package:epms/model/sync_response_revamp.dart';
import 'package:epms/model/synch_inspection_data.dart';
import 'package:epms/screen/home/home_notifier.dart';
import 'package:epms/screen/home/logout_repository.dart';
import 'package:epms/screen/home_inspection/home_inspection_notifier.dart';
import 'package:epms/screen/inspection/inspection_repository.dart';
import 'package:epms/screen/synch/synch_repository.dart';
import 'package:flutter/material.dart';
import 'package:open_settings/open_settings.dart';

class SynchNotifier extends ChangeNotifier {
  NavigatorService _navigationService = locator<NavigatorService>();

  NavigatorService get navigationService => _navigationService;

  DialogService _dialogService = locator<DialogService>();

  DialogService get dialogService => _dialogService;

  String _dataText = "";

  String get dataText => _dataText;

  doSynchMasterData(BuildContext context) async {
    String? apiServer = await StorageManager.readData('apiServer');
    if (apiServer != null) {
      log('Synch Epms');
      final isLoginEpmsSuccess =
          await StorageManager.readData('is_login_epms_success');
      final isLoginInspectionSuccess =
          await StorageManager.readData('is_login_inspection_success');

      if (isLoginEpmsSuccess == true && isLoginInspectionSuccess == false) {
        MConfigSchema mConfigSchema = await DatabaseMConfig().selectMConfig();
        SynchRepository().synchEpms(context, mConfigSchema.estateCode!,
            onSuccessSynchEpms, onErrorSynchEpms);
      } else if (isLoginEpmsSuccess == false &&
          isLoginInspectionSuccess == true) {
        SynchRepository().synchInspection(
          context,
          onSuccessSynchInspectionWhenEpmsFailed,
          onErrorSynchInspection,
        );
      } else if (isLoginEpmsSuccess == true &&
          isLoginInspectionSuccess == true) {
        SynchRepository().synchInspection(
          context,
          onSuccessSynchInspectionWhenEpmsSuccess,
          onErrorSynchEpms,
        );
      }
    } else {
      log('Synch Inspection');
      SynchRepository().synchInspection(
        context,
        onSuccessSynchInspectionWhenEpmsFailed,
        onErrorSynchInspection,
      );
    }
  }

  onErrorSynchEpms(BuildContext context, String message) {
    log("Error Gagal Sync : $message");
    _dialogService.showOptionDialog(
      title: "Gagal Sync",
      subtitle: "$message",
      buttonTextYes: "Ulang",
      buttonTextNo: "Log Out",
      onPressYes: onClickReSynch,
      onPressNo: HomeNotifier().doLogOut,
    );
  }

  onSuccessSynchEpms(BuildContext context, SynchResponse synchResponse) {
    saveSynchEpmsToDatabase(context, synchResponse);
  }

  saveSynchEpmsToDatabase(
      BuildContext context, SynchResponse synchResponse) async {
    StorageManager.saveData(
      "userRoles",
      synchResponse.global!.rolesSchema![0].userRoles,
    );
    globals.globalRevamp = synchResponse.global!;
    try {
      _dataText = "Synch data vendor";
      notifyListeners();
      DatabaseMVendorSchema()
          .insertMVendorSchema(globals.globalRevamp.mVendorSchema ?? [])
          .then((value) {
        _dataText = "Sync data Estate";
        notifyListeners();
        DatabaseMEstateSchema()
            .insertMEstateSchema(globals.globalRevamp.mEstateSchema ?? [])
            .then((value) {
          _dataText = "Sync data Pekerja";
          notifyListeners();
          DatabaseMEmployeeSchema()
              .insertMEmployeeSchema(globals.globalRevamp.mEmployeeSchema ?? [])
              .then((value) {
            _dataText = "Sync data Activity";
            notifyListeners();
            DatabaseMActivitySchema()
                .insertMActivitySchema(
                    globals.globalRevamp.mActivitySchema ?? [])
                .then((value) {
              _dataText = "Sync data Cost Control";
              notifyListeners();
              DatabaseMCostControlSchema()
                  .insertMCostControlSchema(
                      globals.globalRevamp.mCostControlSchema ?? [])
                  .then((value) {
                _dataText = "Sync data Customer";
                notifyListeners();
                DatabaseMCustomerCodeSchema()
                    .insertMCustomerCodeSchema(
                        globals.globalRevamp.mCustomerCodeSchema ?? [])
                    .then((value) {
                  _dataText = "Sync data Divisi";
                  notifyListeners();
                  DatabaseMDivisionSchema()
                      .insertMDivisionSchema(
                          globals.globalRevamp.mDivisionSchema ?? [])
                      .then((value) {
                    _dataText = "Sync data Material";
                    notifyListeners();
                    DatabaseMMaterialSchema()
                        .insertMMaterialSchema(
                            globals.globalRevamp.mMaterialSchema ?? [])
                        .then((value) {
                      _dataText = "Sync data Blok";
                      notifyListeners();
                      DatabaseMBlockSchema()
                          .insertMBlockSchema(
                              globals.globalRevamp.mBlockSchema ?? [])
                          .then((value) {
                        _dataText = "Sync data Kartu OPH";
                        notifyListeners();
                        DatabaseMCOPHSchema()
                            .insertMCOPHSchema(
                                globals.globalRevamp.mCOPHCardSchema ?? [])
                            .then((value) {
                          _dataText = "Sync data TPH";
                          notifyListeners();
                          DatabaseMTPHSchema()
                              .insertMTPHSchema(
                                  globals.globalRevamp.mTPHSchema ?? [])
                              .then((value) {
                            _dataText = "Sync data Penugasan";
                            notifyListeners();
                            DatabaseTUserAssignment()
                                .insertTUserAssignment(globals
                                        .globalRevamp.tUserAssignmentSchema ??
                                    [])
                                .then((value) {
                              _dataText = "Sync data Kartu SPB";
                              notifyListeners();
                              DatabaseMCSPBCardSchema()
                                  .insertMCSPBCardSchema(
                                      globals.globalRevamp.mCSPBCardSchema ??
                                          [])
                                  .then((value) {
                                _dataText = "Sync data Absensi";
                                notifyListeners();
                                DatabaseMAttendance()
                                    .insertAttendance(globals
                                            .globalRevamp.mAttendanceSchema ??
                                        [])
                                    .then((value) {
                                  _dataText = "Sync data Tujuan";
                                  notifyListeners();
                                  DatabaseMDestinationSchema()
                                      .insertMDestinationSchema(globals
                                              .globalRevamp
                                              .mDestinationSchema ??
                                          [])
                                      .then((value) {
                                    _dataText = "Sync data Kehadiran";
                                    notifyListeners();
                                    DatabaseAttendance()
                                        .insertAttendance(globals.globalRevamp
                                                .tAttendanceSchema ??
                                            [])
                                        .then((value) {
                                      _dataText = "Sync data Kendaraan";
                                      notifyListeners();
                                      DatabaseMVRASchema()
                                          .insertMVRASchema(
                                              globals.globalRevamp.mVRASchema ??
                                                  [])
                                          .then((value) {
                                        if (synchResponse.keraniPanen != null) {
                                          _dataText =
                                              "Sync data Laporan Panen Kemarin";
                                          notifyListeners();
                                          DatabaseLaporanPanenKemarin()
                                              .insertLaporanPanenKemarin(
                                                  synchResponse.keraniPanen
                                                          ?.laporanPanenKemarin ??
                                                      []);
                                          _dataText =
                                              "Sync data Estimasi Berat";
                                          notifyListeners();
                                          DatabaseTABWSchema().insertTABWSchema(
                                              synchResponse.keraniPanen!
                                                      .tABWSchema ??
                                                  []);
                                          _dataText = "Sync data Rencana Panen";
                                          notifyListeners();
                                          DatabaseTHarvestingPlan()
                                              .insertTHarvestingPlan(synchResponse
                                                      .keraniPanen
                                                      ?.tHarvestingPlanSchema ??
                                                  []);
                                          _dataText =
                                              "Sync data Laporan Restan";
                                          notifyListeners();
                                          DatabaseLaporanRestan()
                                              .insertLaporanRestan(synchResponse
                                                      .keraniPanen
                                                      ?.laporanRestan ??
                                                  []);
                                        } else if (synchResponse.keraniKirim !=
                                            null) {
                                          _dataText =
                                              "Sync data Laporan Restan";
                                          notifyListeners();
                                          DatabaseLaporanRestan()
                                              .insertLaporanRestan(synchResponse
                                                      .keraniKirim
                                                      ?.laporanRestan ??
                                                  []);
                                          _dataText =
                                              "Sync data Laporan SPB Kemarin";
                                          notifyListeners();
                                          DatabaseLaporanSPBKemarin()
                                              .insertLaporanSPBKemarin(
                                                  synchResponse.keraniKirim
                                                          ?.laporanSPBKemarin ??
                                                      []);
                                        } else if (synchResponse.kerani !=
                                            null) {
                                          _dataText =
                                              "Sync data Laporan Panen Kemarin";
                                          notifyListeners();
                                          DatabaseLaporanPanenKemarin()
                                              .insertLaporanPanenKemarin(
                                                  synchResponse.kerani
                                                          ?.laporanPanenKemarin ??
                                                      []);
                                          _dataText =
                                              "Sync data Estimasi Berat";
                                          notifyListeners();
                                          DatabaseTABWSchema().insertTABWSchema(
                                              synchResponse
                                                      .kerani!.tAbwSchema ??
                                                  []);
                                          _dataText = "Sync data Rencana Panen";
                                          notifyListeners();
                                          DatabaseTHarvestingPlan()
                                              .insertTHarvestingPlan(synchResponse
                                                      .kerani
                                                      ?.tHarvestingPlanSchema ??
                                                  []);
                                          _dataText =
                                              "Sync data Laporan Restan";
                                          notifyListeners();
                                          DatabaseLaporanRestan()
                                              .insertLaporanRestan(synchResponse
                                                      .kerani?.laporanRestan ??
                                                  []);
                                          _dataText =
                                              "Sync data Laporan SPB Kemarin";
                                          notifyListeners();
                                          DatabaseLaporanSPBKemarin()
                                              .insertLaporanSPBKemarin(
                                                  synchResponse.kerani
                                                          ?.laporanSpbKemarin ??
                                                      []);
                                        } else if (synchResponse.supervisi !=
                                            null) {
                                          _dataText = "Sync data Pekerja Ancak";
                                          notifyListeners();
                                          DatabaseMAncakEmployee()
                                              .insertMAncakEmployeeSchema(
                                                  synchResponse.supervisi
                                                          ?.mAncakEmployee ??
                                                      []);
                                          _dataText = "Sync data Rencana Panen";
                                          notifyListeners();
                                          DatabaseTHarvestingPlan()
                                              .insertTHarvestingPlan(synchResponse
                                                      .supervisi
                                                      ?.tHarvestingPlanSchema ??
                                                  []);
                                          _dataText = "Sync data Rencana Kerja";
                                          notifyListeners();
                                          DatabaseTWorkplanSchema()
                                              .insertTWorkPlan(synchResponse
                                                      .supervisi
                                                      ?.tWorkplanSchema ??
                                                  []);
                                          _dataText =
                                              "Sync data Laporan Restan";
                                          notifyListeners();
                                          DatabaseLaporanRestan()
                                              .insertLaporanRestan(synchResponse
                                                      .supervisi
                                                      ?.laporanRestan ??
                                                  []);
                                          _dataText =
                                              "Sync data Laporan Panen Kemarin";
                                          notifyListeners();
                                          DatabaseLaporanPanenKemarin()
                                              .insertLaporanPanenKemarin(
                                                  synchResponse.supervisi
                                                          ?.laporanPanenKemarin ??
                                                      []);
                                          _dataText =
                                              "Sync data Supervisi Auth";
                                          notifyListeners();
                                          DatabaseTAuth.insertTAuth(
                                              synchResponse.supervisi!.auth ??
                                                  []);
                                        } else if (synchResponse
                                                .supervisi3rdParty !=
                                            null) {
                                          _dataText =
                                              "Sync data Grading TBS Luar";
                                          notifyListeners();
                                          DatabaseTBSLuarOneMonth()
                                              .insertTBSLuarOneMonth(
                                                  synchResponse
                                                          .supervisi3rdParty ??
                                                      []);
                                        }
                                        onSuccessSaveSynchEpms(
                                            context, synchResponse);
                                      });
                                    });
                                  });
                                });
                              });
                            });
                          });
                        });
                      });
                    });
                  });
                });
              });
            });
          });
        });
      });
    } catch (e) {
      log('Gagal Synch Epms catch : $e');
      _dialogService.showOptionDialog(
        title: "Gagal Sync",
        subtitle: "$e",
        buttonTextYes: "Ulang",
        buttonTextNo: "Log Out",
        onPressYes: onClickReSynch,
        onPressNo: HomeNotifier().doLogOut,
      );
    }
  }

  onSuccessSaveSynchEpms(BuildContext context, SynchResponse synchResponse) {
    final serverDateParse = DateTime.parse(synchResponse.serverDate!);
    final serverTimeParse = DateTime.parse(
        '${synchResponse.serverDate!} ${synchResponse.serverTime!}');
    final now = DateTime.now();
    final diff = now.difference(serverTimeParse);
    print('cek server date : $serverDateParse');
    print('cek server time : $serverTimeParse');
    StorageManager.saveData(
        "lastSynchTime", TimeManager.timeWithColon(serverTimeParse));
    StorageManager.saveData(
        "lastSynchDate", TimeManager.dateWithDash(serverDateParse));
    getEstateCode();
    saveOphHistory(
      synchResponse.global!.rolesSchema![0].userRoles!,
      synchResponse.ophHistory,
    );

    if (diff.inMinutes > 30) {
      LogOutRepository().doPostLogOut(onSuccessLogOut, onErrorLogOut);
      _dialogService.showNoOptionDialog(
        title: "Beda waktu dengan server",
        subtitle: "${diff.inHours} jam ${diff.inMinutes} menit",
        onPress: () {
          _dialogService.popDialog();
          OpenSettings.openDateSetting();
        },
      );
    } else {
      _navigationService.push(ValueService.getMenuFirst(
          synchResponse.global!.rolesSchema![0].userRoles!));
    }
  }

  onClickReSynch() {
    _dialogService.popDialog();
    _navigationService.push(Routes.SYNCH_PAGE);
  }

  onSuccessSynchInspectionWhenEpmsFailed(
      BuildContext context, SynchInspectionData data) async {
    await saveDatabaseSynchInspection(context, data);

    await InspectionRepository().getMyInspectionClose(
      context,
      (context, data) async {
        _dataText = "Sync data my inspection";
        notifyListeners();
        await DatabaseResponseInspection.addAllData(data.responses);
        await DatabaseTicketInspection.addAllDataNew(data.inspection);
        await DatabaseSubordinateInspection.addAllDataNew(data.inspection);
        await DatabaseAttachmentInspection.addAllData(data);

        await InspectionRepository().getMyInspectionNotClose(
          context,
          (context, data) async {
            _dataText = "Sync data my inspection";
            notifyListeners();
            await DatabaseResponseInspection.addAllData(data.responses);
            await DatabaseTicketInspection.addAllDataNew(data.inspection);
            await DatabaseSubordinateInspection.addAllDataNew(data.inspection);
            await DatabaseAttachmentInspection.addAllData(data);

            await InspectionRepository().getToDoInspection(
              context,
              (context, data) async {
                _dataText = "Sync data todo inspection";
                notifyListeners();
                await DatabaseResponseInspection.addAllData(data.responses);
                await DatabaseTodoInspection.addAllDataNew(data.inspection);
                await DatabaseAttachmentInspection.addAllData(data);

                await InspectionRepository().getOnGoingInspectionClose(
                  context,
                  (context, data) async {
                    _dataText = "Sync data on going inspection";
                    notifyListeners();
                    await DatabaseResponseInspection.addAllData(data.responses);
                    await DatabaseSubordinateInspection.addAllDataNew(
                        data.inspection);
                    await DatabaseAttachmentInspection.addAllData(data);

                    await InspectionRepository().getOnGoingInspectionNotClose(
                      context,
                      (context, data) async {
                        _dataText = "Sync data on going inspection";
                        notifyListeners();
                        await DatabaseResponseInspection.addAllData(
                            data.responses);
                        await DatabaseSubordinateInspection.addAllDataNew(
                            data.inspection);
                        await DatabaseAttachmentInspection.addAllData(data);

                        await InspectionRepository().getToDoInspectionClose(
                          context,
                          (context, data) async {
                            _dataText = "Sync data on going inspection";
                            notifyListeners();
                            await DatabaseResponseInspection.addAllData(
                                data.responses);
                            await DatabaseSubordinateInspection.addAllDataNew(
                                data.inspection);
                            await DatabaseAttachmentInspection.addAllData(data);

                            await InspectionRepository()
                                .getToDoInspectionNotClose(
                              context,
                              (context, data) async {
                                _dataText = "Sync data on going inspection";
                                notifyListeners();
                                await DatabaseResponseInspection.addAllData(
                                    data.responses);
                                await DatabaseSubordinateInspection
                                    .addAllDataNew(data.inspection);
                                await DatabaseAttachmentInspection.addAllData(
                                    data);

                                final now = DateTime.now();
                                await StorageManager.saveData(
                                    "lastSynchTimeInspection",
                                    TimeManager.timeWithColon(now));
                                await StorageManager.saveData(
                                    "lastSynchDateInspection",
                                    TimeManager.dateWithDash(now));

                                _navigationService
                                    .push(Routes.HOME_INSPECTION_PAGE);
                              },
                              (context, errorMessage) {
                                onErrorSynchInspection(context, errorMessage);
                              },
                            );
                          },
                          (context, errorMessage) {
                            onErrorSynchInspection(context, errorMessage);
                          },
                        );
                      },
                      (context, errorMessage) {
                        onErrorSynchInspection(context, errorMessage);
                      },
                    );
                  },
                  (context, errorMessage) {
                    onErrorSynchInspection(context, errorMessage);
                  },
                );
              },
              (context, errorMessage) {
                onErrorSynchInspection(context, errorMessage);
              },
            );
          },
          (context, errorMessage) {
            onErrorSynchInspection(context, errorMessage);
          },
        );
      },
      (context, errorMessage) {
        onErrorSynchInspection(context, errorMessage);
      },
    );
  }

  onErrorSynchInspection(BuildContext context, String message) {
    log("Gagal Sync Inspection : $message");
    _dialogService.showOptionDialog(
      title: "Gagal Sync",
      subtitle: "$message",
      buttonTextYes: "Ulang",
      buttonTextNo: "Log Out",
      onPressYes: onClickReSynch,
      onPressNo: () {
        HomeInspectionNotifier().logOut();
      },
    );
  }

  onSuccessSynchInspectionWhenEpmsSuccess(
      BuildContext context, SynchInspectionData data) async {
    await saveDatabaseSynchInspection(context, data);

    await InspectionRepository().getMyInspectionClose(
      context,
      (context, data) async {
        _dataText = "Sync data my inspection";
        notifyListeners();
        await DatabaseResponseInspection.addAllData(data.responses);
        await DatabaseTicketInspection.addAllDataNew(data.inspection);
        await DatabaseSubordinateInspection.addAllDataNew(data.inspection);
        await DatabaseAttachmentInspection.addAllData(data);

        await InspectionRepository().getMyInspectionNotClose(
          context,
          (context, data) async {
            _dataText = "Sync data my inspection";
            notifyListeners();
            await DatabaseResponseInspection.addAllData(data.responses);
            await DatabaseTicketInspection.addAllDataNew(data.inspection);
            await DatabaseSubordinateInspection.addAllDataNew(data.inspection);
            await DatabaseAttachmentInspection.addAllData(data);

            await InspectionRepository().getToDoInspection(
              context,
              (context, data) async {
                _dataText = "Sync data todo inspection";
                notifyListeners();
                await DatabaseResponseInspection.addAllData(data.responses);
                await DatabaseTodoInspection.addAllDataNew(data.inspection);
                await DatabaseAttachmentInspection.addAllData(data);

                await InspectionRepository().getOnGoingInspectionClose(
                  context,
                  (context, data) async {
                    _dataText = "Sync data on going inspection";
                    notifyListeners();
                    await DatabaseResponseInspection.addAllData(data.responses);
                    await DatabaseSubordinateInspection.addAllDataNew(
                        data.inspection);
                    await DatabaseAttachmentInspection.addAllData(data);

                    await InspectionRepository().getOnGoingInspectionNotClose(
                      context,
                      (context, data) async {
                        _dataText = "Sync data on going inspection";
                        notifyListeners();
                        await DatabaseResponseInspection.addAllData(
                            data.responses);
                        await DatabaseSubordinateInspection.addAllDataNew(
                            data.inspection);
                        await DatabaseAttachmentInspection.addAllData(data);

                        await InspectionRepository().getToDoInspectionClose(
                          context,
                          (context, data) async {
                            _dataText = "Sync data on going inspection";
                            notifyListeners();
                            await DatabaseResponseInspection.addAllData(
                                data.responses);
                            await DatabaseSubordinateInspection.addAllDataNew(
                                data.inspection);
                            await DatabaseAttachmentInspection.addAllData(data);

                            await InspectionRepository()
                                .getToDoInspectionNotClose(
                              context,
                              (context, data) async {
                                _dataText = "Sync data on going inspection";
                                notifyListeners();
                                await DatabaseResponseInspection.addAllData(
                                    data.responses);
                                await DatabaseSubordinateInspection
                                    .addAllDataNew(data.inspection);
                                await DatabaseAttachmentInspection.addAllData(
                                    data);

                                final now = DateTime.now();
                                await StorageManager.saveData(
                                    "lastSynchTimeInspection",
                                    TimeManager.timeWithColon(now));
                                await StorageManager.saveData(
                                    "lastSynchDateInspection",
                                    TimeManager.dateWithDash(now));

                                MConfigSchema mConfigSchema =
                                    await DatabaseMConfig().selectMConfig();
                                SynchRepository().synchEpms(
                                  context,
                                  mConfigSchema.estateCode!,
                                  onSuccessSynchEpms,
                                  onErrorSynchEpms,
                                );
                              },
                              (context, errorMessage) {
                                onErrorSynchEpms(context, errorMessage);
                              },
                            );
                          },
                          (context, errorMessage) {
                            onErrorSynchEpms(context, errorMessage);
                          },
                        );
                      },
                      (context, errorMessage) {
                        onErrorSynchEpms(context, errorMessage);
                      },
                    );
                  },
                  (context, errorMessage) {
                    onErrorSynchEpms(context, errorMessage);
                  },
                );
              },
              (context, errorMessage) {
                onErrorSynchEpms(context, errorMessage);
              },
            );
          },
          (context, errorMessage) {
            onErrorSynchEpms(context, errorMessage);
          },
        );
      },
      (context, errorMessage) {
        onErrorSynchEpms(context, errorMessage);
      },
    );
  }

  saveDatabaseSynchInspection(
      BuildContext context, SynchInspectionData data) async {
    try {
      _dataText = "Sync data user inspection";
      notifyListeners();
      await DatabaseUserInspection.insetData(data.user);

      _dataText = "Sync data team inspection";
      notifyListeners();
      await DatabaseTeamInspection.insetData(data.team);

      _dataText = "Sync data member inspection";
      notifyListeners();
      await DatabaseMemberInspection.insetData(data.team);

      _dataText = "Sync data action inspection";
      notifyListeners();
      await DatabaseActionInspection.insetData(data.action);

      _dataText = "Sync data company inspection";
      notifyListeners();
      await DatabaseCompanyInspection.insetData(data.company);

      _dataText = "Sync data division inspection";
      notifyListeners();
      await DatabaseDivisionInspection.insetData(data.division);

      _dataText = "Sync data estate inspection";
      notifyListeners();
      await DatabaseEstateInspection.insetData(data.estate);
    } catch (e) {
      log('Gagal Synch Inspection : $e');
      _dialogService.showOptionDialog(
        title: "Gagal Sync",
        subtitle: "$e",
        buttonTextYes: "Ulang",
        buttonTextNo: "Log Out",
        onPressYes: onClickReSynch,
        onPressNo: () {
          HomeInspectionNotifier().logOut();
        },
      );
    }
  }

  onSuccessLogOut() {
    // getEstateCode();
    deleteMasterData();
    StorageManager.deleteData('userId');
    StorageManager.deleteData('userToken');
    StorageManager.deleteData("setTime");
    _navigationService.push(Routes.LOGIN_PAGE);
  }

  deleteMasterData() async {
    StorageManager.deleteData("blockDefault");
    DatabaseMConfig().deleteMConfig();
    DatabaseTBSLuar().deleteTBSLuar();
    DatabaseLaporanRestan().deleteLaporanRestan();
    DatabaseLaporanPanenKemarin().deleteLaporanPanenKemarin();
    DatabaseLaporanSPBKemarin().deleteLaporanSPBKemarin();
    DatabaseTHarvestingPlan().deleteTHarvestingPlan();
    DatabaseAttendance().deleteEmployeeAttendance();
    DatabaseTWorkplanSchema().deleteTWorkPlan();
    DatabaseMaterial().deleteMaterial();
    DatabaseSupervisor().deleteSupervisor();
    DatabaseMAncakEmployee().deleteMAncakEmployeeSchema();
    DatabaseTABWSchema().deleteTABWSchema();
  }

  onErrorLogOut(String response) {
    _dialogService.popDialog();
    _dialogService.showNoOptionDialog(
      title: "Gagal Log Out",
      subtitle: "$response",
      onPress: _dialogService.popDialog,
    );
  }

  Future<void> saveOphHistory(String role, List? ophHistory) async {
    if (role == 'KR' || role == 'TP') {
      final data = jsonEncode(ophHistory != null ? ophHistory : []);
      StorageManager.saveData('ophHistory', data);
    }
  }

  getEstateCode() async {
    MConfigSchema mConfigSchema = await DatabaseMConfig().selectMConfig();
    StorageManager.saveData("estateCode", mConfigSchema.estateCode);
  }

  onSuccessSaveLocalBackground(
      BuildContext context, SynchResponse synchResponse) {
    _dialogService.popDialog();
    DateTime now = DateTime.now();
    StorageManager.saveData("lastSynchTime", TimeManager.timeWithColon(now));
    StorageManager.saveData("lastSynchDate", TimeManager.dateWithDash(now));
  }

  doSynchMasterDataBackground(BuildContext context) async {
    _dialogService.showLoadingDialog(title: "Synch Data");
    MConfigSchema mConfigSchema = await DatabaseMConfig().selectMConfig();
    SynchRepository().synchEpms(context, mConfigSchema.estateCode!,
        onSuccessSynchBackground, onErrorSynchBackground);
  }

  onSuccessSynchBackground(BuildContext context, SynchResponse synchResponse) {
    saveDatabaseBackground(context, synchResponse);
  }

  onErrorSynchBackground(BuildContext context, String message) {
    _dialogService.popDialog();
    _dialogService.showOptionDialog(
      title: "Gagal Sync",
      subtitle: "Gagal pada saat sinkronisasi $message",
      buttonTextYes: "Ulang",
      buttonTextNo: "Log Out",
      onPressYes: onClickReSynchBackground,
      onPressNo: HomeNotifier().doLogOut,
    );
  }

  saveDatabaseBackground(
      BuildContext context, SynchResponse synchResponse) async {
    DatabaseLaporanPanenKemarin().deleteLaporanPanenKemarin();
    // DatabaseTABWSchema().deleteTABWSchema();
    // DatabaseTHarvestingPlan().deleteTHarvestingPlan();
    // DatabaseLaporanRestan().deleteLaporanRestan();
    try {
      if (synchResponse.keraniPanen != null) {
        _dataText = "Sync data Laporan Panen Kemarin";
        await DatabaseLaporanPanenKemarin().insertLaporanPanenKemarin(
            synchResponse.keraniPanen?.laporanPanenKemarin ?? []);
        notifyListeners();
        // _dataText = "Synch data Estimasi Berat";
        // await DatabaseTABWSchema()
        //     .insertTABWSchema(synchResponse.keraniPanen!.tABWSchema ?? []);
        // notifyListeners();
        // _dataText = "Synch data Rencana Panen";
        // await DatabaseTHarvestingPlan().insertTHarvestingPlan(
        //     synchResponse.keraniPanen?.tHarvestingPlanSchema ?? []);
        // notifyListeners();
        // _dataText = "Synch data Laporan Restan";
        // await DatabaseLaporanRestan().insertLaporanRestan(
        //     synchResponse.keraniPanen?.laporanRestan ?? []);
        // notifyListeners();
      }
      onSuccessSaveLocalBackground(context, synchResponse);
    } catch (e) {
      print(e);
      _dialogService.showOptionDialog(
        title: "Gagal Sync",
        subtitle: "Gagal pada saat sinkronisasi $e",
        buttonTextYes: "Ulang",
        buttonTextNo: "Log Out",
        onPressYes: onClickReSynch,
        onPressNo: HomeNotifier().doLogOut,
      );
    }
  }

  onClickReSynchBackground() {
    _dialogService.popDialog();
    doSynchMasterDataBackground(
        _navigationService.navigatorKey.currentContext!);
  }
}

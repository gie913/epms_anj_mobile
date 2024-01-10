import 'dart:developer';

import 'package:epms/base/common/locator.dart';
import 'package:epms/base/ui/style.dart';
import 'package:epms/base/ui/theme_notifier.dart';
import 'package:epms/common_manager/navigator_service.dart';
import 'package:epms/database/service/database_user_inspection.dart';
import 'package:epms/model/user_inspection_model.dart';
import 'package:epms/screen/inspection/components/input_search.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:provider/provider.dart';

class InspectionUserView extends StatefulWidget {
  const InspectionUserView({super.key, this.companyId = ''});

  final String companyId;

  @override
  State<InspectionUserView> createState() => _InspectionUserViewState();
}

class _InspectionUserViewState extends State<InspectionUserView> {
  NavigatorService _navigationService = locator<NavigatorService>();
  final searchController = TextEditingController();

  List<UserInspectionModel> listUserInspection = const [];
  List<UserInspectionModel> listSearchUserInspection = const [];
  UserInspectionModel? selectedUserInspection;

  bool isLoading = false;

  Future<void> getUserInspection() async {
    isLoading = true;
    final data = await DatabaseUserInspection.selectData(widget.companyId);
    listUserInspection = data;
    listSearchUserInspection = listUserInspection;
    isLoading = false;
    log('cek list user inspection : $listUserInspection');
    setState(() {});
  }

  void searchUser(String keyword) {
    setState(() {
      final temp = <UserInspectionModel>[];

      if (keyword.isEmpty) {
        listSearchUserInspection.addAll(listUserInspection);
      }

      for (final item in listUserInspection) {
        if (item.name.toLowerCase().contains(keyword.toLowerCase())) {
          temp.add(item);
        }
      }

      listSearchUserInspection = temp;
    });
  }

  void clearSearchUser() {
    searchController.clear();
    listSearchUserInspection = listUserInspection;
    setState(() {});
  }

  void selectUser(UserInspectionModel value) {
    _navigationService.popNew(result: value);
  }

  @override
  void initState() {
    getUserInspection();
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, _) {
        return MediaQuery(
          data: Style.mediaQueryText(context),
          child: Scaffold(
            appBar: AppBar(title: Text("Search User Inspection")),
            body: Flex(
              direction: Axis.vertical,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: InputSearch(
                    controller: searchController,
                    onTapSuffixIcon: clearSearchUser,
                    onChanged: searchUser,
                  ),
                ),
                if (!isLoading)
                  Expanded(
                    child: listSearchUserInspection.isNotEmpty
                        ? ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: listSearchUserInspection.length,
                            itemBuilder: (context, index) {
                              final user = listSearchUserInspection[index];
                              return Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 0, 16, 12),
                                child: InkWell(
                                  onTap: () => selectUser(user),
                                  child: Card(
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    margin: EdgeInsets.zero,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 8,
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            FontAwesome5.user_alt,
                                            color: Colors.orange,
                                            size: 30,
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(user.name),
                                                Text(user.code),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.add,
                                              color: Colors.white,
                                            ),
                                            onPressed: () => selectUser(user),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                        : Center(child: Text('Data tidak ada')),
                  ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }
}

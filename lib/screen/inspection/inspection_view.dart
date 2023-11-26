import 'package:epms/base/common/locator.dart';
import 'package:epms/base/common/routes.dart';
import 'package:epms/base/ui/palette.dart';
import 'package:epms/base/ui/style.dart';
import 'package:epms/common_manager/navigator_service.dart';
import 'package:epms/screen/inspection/components/tab_to_do.dart';
import 'package:epms/screen/inspection/components/tab_my_inspection.dart';
import 'package:epms/screen/inspection/inspection_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InspectionView extends StatefulWidget {
  const InspectionView({super.key});

  @override
  State<InspectionView> createState() => _InspectionViewState();
}

class _InspectionViewState extends State<InspectionView> {
  NavigatorService _navigationService = locator<NavigatorService>();

  int tabBarIndex = 0;

  @override
  void initState() {
    context.read<InspectionNotifier>().initData(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<InspectionNotifier>(
      builder: (context, provider, _) {
        return DefaultTabController(
          initialIndex: 0,
          length: 2,
          child: MediaQuery(
            data: Style.mediaQueryText(context),
            child: Scaffold(
              appBar: AppBar(
                title: Text('Inspection'),
                bottom: TabBar(
                  enableFeedback: true,
                  onTap: (value) {
                    tabBarIndex = value;
                    setState(() {});
                  },
                  tabs: [
                    Tab(icon: Text("My Inspection")),
                    Tab(icon: Text("To Do")),
                  ],
                ),
              ),
              body: Flex(
                direction: Axis.vertical,
                children: [
                  Expanded(
                    child: TabBarView(
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        TabMyInspection(),
                        TabToDo(),
                      ],
                    ),
                  ),
                  if (tabBarIndex == 0)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: InkWell(
                        onTap: () async {
                          await _navigationService.push(Routes.INSPECTION_FORM);
                          await provider.updateMyInspectionFromLocal();
                        },
                        child: Card(
                          color: Palette.primaryColorProd,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Text(
                                "CREATE INSPECTION",
                                style: Style.whiteBold14,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    child: InkWell(
                      onTap: () {
                        provider.uploadAndSynch(context);
                      },
                      child: Card(
                        color: Colors.green,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Text(
                              "UPLOAD & SYNCH",
                              style: Style.whiteBold14,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

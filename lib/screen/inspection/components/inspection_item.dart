import 'package:epms/base/ui/palette.dart';
import 'package:epms/base/ui/style.dart';
import 'package:epms/database/helper/convert_helper.dart';
import 'package:epms/model/ticket_inspection_model.dart';
import 'package:flutter/material.dart';

class InspectionItem extends StatelessWidget {
  const InspectionItem({
    super.key,
    required this.onTap,
    required this.data,
    this.bgColor,
  });

  final Function() onTap;
  final TicketInspectionModel data;
  final Color? bgColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        color: bgColor ?? Palette.primaryColorProd,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.code,
                    style: Style.whiteBold12.copyWith(
                        color: Colors.white, fontWeight: FontWeight.normal),
                  ),
                  Divider(color: Colors.white24, height: 1),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        'Tanggal :',
                        style: Style.whiteBold12.copyWith(
                            color: Colors.white, fontWeight: FontWeight.normal),
                      ),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          data.trTime,
                          style: Style.whiteBold12.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.normal),
                        ),
                      )
                    ],
                  ),
                  Divider(color: Colors.white24, height: 1),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        'Status :',
                        style: Style.whiteBold12.copyWith(
                            color: Colors.white, fontWeight: FontWeight.normal),
                      ),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          ConvertHelper.titleCase(
                            data.status
                                .replaceAll(RegExp(r'_'), ' ')
                                .replaceAll(RegExp(r'-'), ' '),
                          ),
                          style: Style.whiteBold12.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.normal),
                        ),
                      )
                    ],
                  ),
                  Divider(color: Colors.white24, height: 1),
                  SizedBox(height: 4),
                  // Row(
                  //   children: [
                  //     Text(
                  //       'Kategori :',
                  //       style: Style.whiteBold12.copyWith(
                  //           color: Colors.white, fontWeight: FontWeight.normal),
                  //     ),
                  //     SizedBox(width: 4),
                  //     Expanded(
                  //       child: Text(
                  //         data.mTeamName,
                  //         style: Style.whiteBold12.copyWith(
                  //             color: Colors.white, fontWeight: FontWeight.normal),
                  //       ),
                  //     )
                  //   ],
                  // ),
                  // Row(
                  //   children: [
                  //     Text(
                  //       'Company :',
                  //       style: Style.whiteBold12.copyWith(
                  //           color: Colors.white, fontWeight: FontWeight.normal),
                  //     ),
                  //     SizedBox(width: 4),
                  //     Expanded(
                  //       child: Text(
                  //         data.mCompanyAlias,
                  //         style: Style.whiteBold12.copyWith(
                  //             color: Colors.white, fontWeight: FontWeight.normal),
                  //       ),
                  //     )
                  //   ],
                  // ),
                  // if (data.mDivisionEstateCode.isNotEmpty &&
                  //     data.mDivisionName.isNotEmpty)
                  //   Row(
                  //     children: [
                  //       Text(
                  //         'Divisi :',
                  //         style: Style.whiteBold12.copyWith(
                  //             color: Colors.white, fontWeight: FontWeight.normal),
                  //       ),
                  //       SizedBox(width: 4),
                  //       Expanded(
                  //         child: Text(
                  //           'Estate ${data.mDivisionEstateCode} | ${data.mDivisionName}',
                  //           style: Style.whiteBold12.copyWith(
                  //               color: Colors.white, fontWeight: FontWeight.normal),
                  //         ),
                  //       )
                  //     ],
                  //   ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'User Assign :',
                        style: Style.whiteBold12.copyWith(
                            color: Colors.white, fontWeight: FontWeight.normal),
                      ),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          data.assignee,
                          style: Style.whiteBold12.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.normal),
                        ),
                      )
                    ],
                  ),
                  Divider(color: Colors.white24, height: 1),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        'Tindakan Terakhir :',
                        style: Style.whiteBold12.copyWith(
                            color: Colors.white, fontWeight: FontWeight.normal),
                      ),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          data.responses.isNotEmpty
                              ? data.responses.last.trTime
                              : '-',
                          style: Style.whiteBold12.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.normal),
                        ),
                      )
                    ],
                  ),
                  Divider(color: Colors.white24, height: 1),
                  SizedBox(height: 4),
                  if (!ConvertHelper.intToBool(data.isSynchronize))
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        'Need Synch',
                        style: Style.whiteBold12.copyWith(
                            color: Colors.white, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    )
                ],
              ),
              if (data.isNewResponse == 1)
                Align(
                  alignment: Alignment.topRight,
                  child: Icon(
                    Icons.circle_notifications_outlined,
                    color: Colors.white,
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}

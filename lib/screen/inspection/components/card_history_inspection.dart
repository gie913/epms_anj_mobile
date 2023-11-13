import 'package:epms/base/ui/palette.dart';
import 'package:epms/base/ui/style.dart';
import 'package:epms/model/history_inspection_model.dart';
import 'package:flutter/material.dart';

class CardHistoryInspection extends StatelessWidget {
  const CardHistoryInspection({
    super.key,
    this.data = const HistoryInspectionModel(),
  });

  final HistoryInspectionModel data;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Palette.primaryColorProd,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.user,
                    style: Style.whiteBold14.copyWith(
                        color: Colors.white, fontWeight: FontWeight.normal),
                  ),
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
                          data.date,
                          style: Style.whiteBold12.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.normal),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Tindakan :',
                        style: Style.whiteBold12.copyWith(
                            color: Colors.white, fontWeight: FontWeight.normal),
                      ),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          data.response.isEmpty ? '-' : data.response,
                          style: Style.whiteBold12.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.normal),
                        ),
                      )
                    ],
                  ),
                  if (data.userReAssign.isNotEmpty)
                    Row(
                      children: [
                        Text(
                          'User Re-Assign :',
                          style: Style.whiteBold12.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.normal),
                        ),
                        SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            data.userReAssign,
                            style: Style.whiteBold12.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.normal),
                          ),
                        )
                      ],
                    ),
                  if (data.userConsultation.isNotEmpty)
                    Row(
                      children: [
                        Text(
                          'User Consultation :',
                          style: Style.whiteBold12.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.normal),
                        ),
                        SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            data.userConsultation,
                            style: Style.whiteBold12.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.normal),
                          ),
                        )
                      ],
                    ),
                ],
              ),
            ),
            SizedBox(width: 12),
            Text(
              data.status,
              style: Style.whiteBold12
                  .copyWith(color: Colors.white, fontWeight: FontWeight.normal),
            )
          ],
        ),
      ),
    );
  }
}

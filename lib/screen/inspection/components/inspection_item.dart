import 'package:epms/base/ui/palette.dart';
import 'package:epms/base/ui/style.dart';
import 'package:epms/model/ticket_inspection_model.dart';
import 'package:flutter/material.dart';

class InspectionItem extends StatelessWidget {
  const InspectionItem({
    super.key,
    required this.onTap,
    required this.data,
  });

  final Function() onTap;
  final TicketInspectionModel data;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
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
                      data.id,
                      style: Style.whiteBold12.copyWith(
                          color: Colors.white, fontWeight: FontWeight.normal),
                    ),
                    Row(
                      children: [
                        Text(
                          'Tanggal :',
                          style: Style.whiteBold12.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.normal),
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
                          'Kategori :',
                          style: Style.whiteBold12.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.normal),
                        ),
                        SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            data.category,
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
                          'Company :',
                          style: Style.whiteBold12.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.normal),
                        ),
                        SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            data.company,
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
                          'Divisi :',
                          style: Style.whiteBold12.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.normal),
                        ),
                        SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            data.division,
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
                          'User Assign :',
                          style: Style.whiteBold12.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.normal),
                        ),
                        SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            data.userAssign,
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
                style: Style.whiteBold12.copyWith(
                    color: Colors.white, fontWeight: FontWeight.normal),
              )
            ],
          ),
        ),
      ),
    );
  }
}

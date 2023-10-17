import 'package:epms/base/ui/palette.dart';
import 'package:epms/base/ui/style.dart';
import 'package:flutter/material.dart';

class InspectionItem extends StatelessWidget {
  const InspectionItem({super.key, required this.onTap});

  final Function() onTap;

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
                            'Kategori 1',
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
                            'Company 1',
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
                            'Divisi 1',
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
                'On Progress',
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

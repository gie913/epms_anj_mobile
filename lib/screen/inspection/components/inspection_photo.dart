import 'dart:io';

import 'package:flutter/material.dart';

class InspectionPhoto extends StatelessWidget {
  const InspectionPhoto({
    super.key,
    required this.imagePath,
    required this.onTapRemove,
    required this.onTapView,
  });

  final String imagePath;
  final Function() onTapRemove;
  final Function() onTapView;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapView,
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 4,
        height: MediaQuery.of(context).size.width / 4,
        child: Stack(
          children: [
            Image.file(
              File(imagePath),
              height: MediaQuery.of(context).size.width / 4,
              width: MediaQuery.of(context).size.width / 4,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 4, top: 4),
              child: InkWell(
                onTap: onTapRemove,
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.white),
                  child: Icon(Icons.cancel, color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

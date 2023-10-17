import 'dart:io';

import 'package:flutter/material.dart';

class InspectionPhoto extends StatelessWidget {
  const InspectionPhoto({
    super.key,
    required this.imagePath,
    required this.onTapRemove,
  });

  final String imagePath;
  final Function() onTapRemove;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 4,
      height: MediaQuery.of(context).size.width / 4,
      child: Stack(
        children: [
          Image.file(
            File(imagePath),
            height: MediaQuery.of(context).size.width / 4,
            width: MediaQuery.of(context).size.width / 4,
            fit: BoxFit.fill,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 4),
            child: InkWell(
              onTap: onTapRemove,
              child: Container(
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                child: Icon(Icons.cancel, color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

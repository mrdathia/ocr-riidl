import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:ocr_riidl/utils/appTools.dart';

class CopyInterests extends StatefulWidget {
  final XFile imageFile;
  CopyInterests(this.imageFile);

  @override
  _CopyInterestsState createState() => _CopyInterestsState();
}

class _CopyInterestsState extends State<CopyInterests> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: hexToColor("#121212"),
        body: Column(
          children: [
            SizedBox(
              width: 200.0,
              child: Image.file(File(widget.imageFile.path)),
            )
          ],
        ));
  }

  // Future<Uint8List> getImageBytes(imageFile) async {
  //   Uint8List = await imageFile.readAsBytes();
  // }
}

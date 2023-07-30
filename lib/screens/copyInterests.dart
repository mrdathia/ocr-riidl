import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ocr_riidl/models/history.dart';
import 'package:ocr_riidl/utils/appTools.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

//import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class CopyInterests extends StatefulWidget {
  final XFile imageFile;
  CopyInterests(this.imageFile, {super.key});

  @override
  _CopyInterestsState createState() => _CopyInterestsState();
}

class _CopyInterestsState extends State<CopyInterests> {
  String recognizedText = 'Recognizing...';
  final txt = TextRecognizer();
  History history = History();

  get text => null;

  _insertInDB() async {
    // Insert the Dog into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same dog is inserted twice.
    //
    // In this case, replace any previous data.
    final db = await openDatabase(await getDatabasesPath());
    db.insert(
      'ocrhistory',
      history.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  _getInterests() async {
    final imageFile = widget.imageFile.path;
    final inp = InputImage.fromFile(File(imageFile));
    RecognizedText recogTxt = await txt.processImage(inp);
    if (kDebugMode) {
      print(recogTxt.text);
    }

    setState(() {
      recognizedText = recogTxt.text;
      txt.close();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getInterests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: hexToColor("#121212"),
      body: Column(
        children: [
          SizedBox(
            width: 200.0,
            child: Image.file(File(widget.imageFile.path)),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
            ),
            child: Text(
              recognizedText,
              style: TextStyle(color: hexToColor("#f4f4f2")),
            ),
          ),
          // FutureBuilder(
          //     future: _getInterests(),
          //     builder: (context, snapshot) {
          //       return Container(
          //         padding: const EdgeInsets.all(10),
          //         decoration: BoxDecoration(
          //           border: Border.all(color: Colors.black),
          //         ),
          //         child: Text(
          //           recognizedText,
          //           style: TextStyle(color: hexToColor("#f4f4f2")),
          //         ),
          //       );
          //     }),
        ],
      ),
    );
  }

  // Future<Uint8List> getImageBytes(imageFile) async {
  //   Uint8List = await imageFile.readAsBytes();
  // }
}

import 'dart:io';

//import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ocr_riidl/models/history.dart';
import 'package:ocr_riidl/utils/actionTextButton.dart';
import 'package:ocr_riidl/utils/appColors.dart';
import 'package:ocr_riidl/utils/appTools.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:ocr_riidl/utils/textFormField.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../utils/styleConstants.dart';

//import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class CopyInterests extends StatefulWidget {
  final History tHistory;
  // final int id;
  const CopyInterests(this.tHistory, {super.key});
  // CopyInterests(this.imageFile,this.id {super.key});

  @override
  _CopyInterestsState createState() => _CopyInterestsState();
}

class _CopyInterestsState extends State<CopyInterests> {
  TextEditingController recognizedText =
      TextEditingController(text: 'Recognizing...');
  TextEditingController fileName = TextEditingController();
  final txt = TextRecognizer();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getInterests();
  }

  _insertInDB() async {
    widget.tHistory.createdAt =
        widget.tHistory.updatedAt = DateTime.timestamp().toString();
    widget.tHistory.imgPath = widget.tHistory.imgPath;
    widget.tHistory.saved = widget.tHistory.deleted = 0;
    widget.tHistory.fileName = fileName.text;
    final db = await openDatabase(
      join(await getDatabasesPath(), 'ocrriidl.db'),
    );
    widget.tHistory.id = await db.insert(
      'ocrhistory',
      widget.tHistory.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print("returned id: ${widget.tHistory.id}");
    // for (History his in await storedHistory()) {
    //   if (kDebugMode) {
    //     print(his.toJson().toString());
    //   }
    // }
  }

  Future<List<History>> storedHistory() async {
    final db =
        await openDatabase(join(await getDatabasesPath(), 'ocrriidl.db'));

    final List<Map<String, dynamic>> maps = await db.query('ocrhistory');
    return List.generate(maps.length, (i) {
      return History(
        id: maps[i]['id'],
        imgPath: maps[i]['imgpath'],
        fileName: maps[i]['filename'],
        saved: maps[i]['saved'],
        deleted: maps[i]['deleted'],
        createdAt: maps[i]['createdat'],
        updatedAt: maps[i]['updatedat'],
      );
    });
  }

  _updateInDB(BuildContext context) async {
    // Insert the Dog into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same dog is inserted twice.
    //
    // In this case, replace any previous data.
    widget.tHistory.updatedAt = DateTime.timestamp().toString();
    widget.tHistory.imgPath = widget.tHistory.imgPath;
    widget.tHistory.fileName = fileName.text;
    widget.tHistory.saved = 1;
    print("temp ${widget.tHistory.toJson().toString()}");
    final db = await openDatabase(
      join(await getDatabasesPath(), 'ocrriidl.db'),
    );
    await db.update(
      'ocrhistory',
      widget.tHistory.toJson(),
      // Ensure that the Dog has a matching id.
      where: 'id = ?',
      whereArgs: [widget.tHistory.id],
      // conflictAlgorithm: ConflictAlgorithm.replace,
    );
    // for (History his in await storedHistory()) {
    //   if (kDebugMode) {
    //     print(his.toJson().toString());
    //   }
    // }
    Navigator.of(context).pushReplacementNamed("historyPage");
  }

  _deleteInDB() async {
    final db = await openDatabase(
      join(await getDatabasesPath(), 'ocrriidl.db'),
    );
    await db.delete(
      'ocrhistory',
      where: 'id = ?',
      whereArgs: [widget.tHistory.id],
    );
    for (History his in await storedHistory()) {
      if (kDebugMode) {
        print(his.toJson().toString());
      }
    }
  }

  _getInterests() async {
    String? imageFilePath = widget.tHistory.imgPath;
    final inp = InputImage.fromFile(File(imageFilePath!));
    RecognizedText recogTxt = await txt.processImage(inp);
    if (kDebugMode) {
      print(recogTxt.text);
    }

    setState(() {
      fileName.text = widget.tHistory.fileName!;
      recognizedText.text = recogTxt.text;
      txt.close();
    });

    if (widget.tHistory.id == null) {
      await _insertInDB();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: const ScrollBehavior(),
      child: Scaffold(
        backgroundColor: hexToColor(AppColors.bgColor),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height % 0.1,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
                child: Image.file(File(widget.tHistory.imgPath.toString())),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  height: 20,
                  child: Text(
                    "File Name: ",
                    textAlign: TextAlign.end,
                    style: kGoogleStyleTexts.copyWith(
                        color: hexToColor("#ffffff"),
                        fontSize: 15,
                        fontWeight: FontWeight.normal),
                  ),
                ),
              ),
              TextField(
                controller: fileName,
                style: kGoogleStyleTexts.copyWith(
                    color: hexToColor("#ffffff"),
                    fontSize: 15,
                    fontWeight: FontWeight.normal),
                onChanged: (data) async {
                  widget.tHistory.fileName = data;
                },
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                child: CustomTextFormField(
                  context: context,
                  controller: recognizedText,
                  keyboardType: TextInputType.text,
                  hintText: '',
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ActionTextButton(
                      onPressed: () => {
                            _deleteInDB(),
                            Navigator.of(context).pop(),
                          },
                      context: context,
                      textToClick: "Re-Take",
                      fontSize: 20),
                  ActionTextButton(
                      onPressed: () => {
                            Clipboard.setData(
                                ClipboardData(text: recognizedText.text))
                          },
                      context: context,
                      textToClick: "CopyText",
                      fontSize: 20),
                  ActionTextButton(
                      onPressed: () {
                        _updateInDB(context);
                      },
                      context: context,
                      textToClick: "Save",
                      fontSize: 20),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

// Future<Uint8List> getImageBytes(imageFile) async {
//   Uint8List = await imageFile.readAsBytes();
// }
}

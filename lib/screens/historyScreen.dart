import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ocr_riidl/utils/appTools.dart';
import 'package:ocr_riidl/utils/styleConstants.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/history.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late List<History> histories;

  edit(BuildContext context, History history) {
    Navigator.of(context)
        .pushReplacementNamed("copyTextPage", arguments: history);
  }

  Future<List<History>> storedHistory() async {
    final db =
        await openDatabase(join(await getDatabasesPath(), 'ocrriidl.db'));

    final List<Map<String, dynamic>> maps = await db.query('ocrhistory');
    histories = List.generate(maps.length, (i) {
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
    histories.sort(
        (b, a) => a.updatedAt.toString().compareTo(b.updatedAt.toString()));
    return histories;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: hexToColor("#121212"),
        body: FutureBuilder(
          future: storedHistory(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              histories = snapshot.data!;
              return ListView.builder(
                itemCount: histories.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: edit(context, histories[index]),
                      child: ListTile(
                        tileColor: hexToColor("#1a1a1a"),
                        leading: Image.file(
                            File(histories[index].imgPath.toString())),
                        title: Text(
                          histories[index].fileName.toString(),
                          style: kGoogleStyleTexts.copyWith(
                            fontSize: 20,
                            color: hexToColor("#DDDDDD"),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }
            return SizedBox(
              child: Text(
                "Data is Coming...",
                style: kGoogleStyleTexts.copyWith(
                  fontSize: 20,
                  color: hexToColor("#DDDDDD"),
                ),
              ),
            );
          },
        ));
  }
}

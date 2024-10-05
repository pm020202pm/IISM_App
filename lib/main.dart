import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:iism/firebase_options.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:excel/excel.dart' as exl;
import 'package:iism/DashBoard/pages/dashboard.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  Future<void> loadExcelData() async {
    String category = 'teams';
    final ByteData data = await rootBundle.load('assets/files/$category.xlsx');

    final List<int> bytes = data.buffer.asUint8List();
    final exl.Excel excel = exl.Excel.decodeBytes(bytes);
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Iterate through each sheet
    for (var table in excel.tables.keys) {
      final sheet = excel.tables[table];
      if (sheet == null) continue;

      for (int rowIndex = 1; rowIndex < sheet.maxRows; rowIndex++) {
        Map<String, dynamic> dataMap = {};

        // Iterate through each column in the row
        for (int colIndex = 0; colIndex < sheet.maxColumns; colIndex++) {
          var cellValue = sheet.rows[rowIndex][colIndex]?.value;
          String header = sheet.rows[0][colIndex]?.value.toString() ?? 'Column_$colIndex';
          if(header!='Date') {
            dataMap[header] = cellValue.toString().toLowerCase();
          } else {
            dataMap[header] = cellValue.toString();
          }
        }
        await firestore.collection(category).add(dataMap);
      }
    }
  }
  @override
  void initState() {
    // loadExcelData();
    // fetchFieldData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const DashBoard(index: 0),
    );
  }
}



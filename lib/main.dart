import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:iism/firebase_options.dart';
import 'package:iism/pages/gallery_page.dart';
import 'package:iism/pages/home_page.dart';
import 'package:iism/pages/player_profile_page.dart';
import 'package:iism/pages/players_page.dart';
import 'package:iism/pages/schedule_page.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:excel/excel.dart' as exl;
import 'package:iism/pages/teams_page.dart';

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
    // final ByteData data = await rootBundle.load('assets/files/schedule.xlsx');
    // final ByteData data = await rootBundle.load('assets/files/players.xlsx');
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
          if(header!='Date') dataMap[header] = cellValue.toString().toLowerCase();
          else dataMap[header] = cellValue.toString();
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
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int index = 0;
  void setGalleryPage() {
    setState(() {
      index = 3;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (index == 0) ?
        HomePage(onTap: setGalleryPage,) :
      (index == 1)
          ? SchedulePage()
          : (index == 2)
          ? const PlayersPage()
          : (index == 3)
          ? const GalleryPage()
          : (index == 4)
          ? const TeamsPage()
          : (index == 5)
          ? ProfilePage()
          : Container(),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(6),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            gradient: LinearGradient(
              colors: [Colors.green.shade200, Colors.green.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(1),
                spreadRadius: 2,
                blurRadius: 9,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: GNav(
              gap: 4,
              activeColor: Colors.green.shade900,
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
              tabMargin: const EdgeInsets.only(top: 5, right: 5, left: 5, bottom: 5),
              duration: const Duration(milliseconds: 200),
              backgroundColor: Colors.grey.shade300,
              tabBackgroundColor: Colors.green.shade200,
              // tabActiveBorder: Border.all(color: Colors.green.shade400, width: 2),
              textStyle: TextStyle(
                color: Colors.green.shade900,
                fontWeight: FontWeight.bold,
              ),

              tabs: [
                GButton(
                  onPressed: (){
                    setState(() {
                      index = 0;
                      // item = HomePage();
                    });
                  },
                  icon: Icons.home,
                  text: 'Home',
                ),
                GButton(
                  onPressed: (){
                    setState(() {
                      index = 1;
                      // item = SchedulePage();
                    });
                  },
                  icon: Icons.schedule,
                  text: 'Matches',
                ),
                GButton(
                  onPressed: (){
                    setState(() {
                      index = 2;
                      // item = PlayersPage();
                    });
                  },
                  icon: Icons.sports_basketball,
                  text: 'Players',
                ),
                GButton(
                  onPressed: setGalleryPage,
                  icon: Icons.image,
                  text: 'Gallery',
                ),
                // GButton(
                //   onPressed: (){
                //
                //     setState(() {
                //       index = 4;
                //       // item = TeamsPage();
                //     });
                //   },
                //   icon: Icons.people,
                //   text: 'Teams',
                // ),
                GButton(
                  onPressed: (){

                    setState(() {
                      index = 5;
                      // item = TeamsPage();
                    });
                  },
                  icon: Icons.person,
                  text: 'Profile',
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

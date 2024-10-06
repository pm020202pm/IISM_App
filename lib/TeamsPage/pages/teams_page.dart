

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils.dart';
import '../../widgets/widgets.dart';
// import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:excel/excel.dart' as exl;

class TeamsPage extends StatefulWidget {
  const TeamsPage({super.key});

  @override
  _TeamsPageState createState() => _TeamsPageState();
}

class _TeamsPageState extends State<TeamsPage> {
   final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;
  List<Map<String, dynamic>> head=[];

  @override
  void initState() {
    super.initState();
    loadExcelData();
  }

  Future<void> loadExcelData() async {
    final ByteData data = await rootBundle.load('assets/files/heads.xlsx');

    final List<int> bytes = data.buffer.asUint8List();
    final exl.Excel excel = exl.Excel.decodeBytes(bytes);
    for (var table in excel.tables.keys) {
      final sheet = excel.tables[table];
      if (sheet == null) continue;
      for (int rowIndex = 1; rowIndex < sheet.maxRows; rowIndex++) {
        Map<String, dynamic> dataMap = {};
        for (int colIndex = 0; colIndex < 4; colIndex++) {
          var cellValue = sheet.rows[rowIndex][colIndex]?.value;
          String header = sheet.rows[0][colIndex]?.value.toString() ?? 'Column_$colIndex';
          if(header!='Date') {
            dataMap[header] = cellValue.toString().toLowerCase();
          } else {
            dataMap[header] = cellValue.toString();
          }
        }
        head.add(dataMap);
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: dark? Colors.black : Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70.0),
        child: AppBar(
          backgroundColor: Colors.transparent,
          title: null,
          flexibleSpace: Padding(
            padding: const EdgeInsets.only(top: 60.0, left: 16, right: 16),
            child: pageTitleText("Teams"),
          ),
        ),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 14.0,
          mainAxisSpacing: 18.0,
          childAspectRatio:0.75,
        ),
        padding: const EdgeInsets.all(16.0),
        itemCount: head.length,
        itemBuilder: (context, index) {
          if (index >= head.length) {
            return const Center(child: CircularProgressIndicator());
          }
          return TeamsCard(data: head[index]);
        },
      )
      ,
    );
  }
}


class TeamsCard extends StatelessWidget {
  const TeamsCard({super.key, this.data});
  final dynamic data;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){},
      child: ClipPath(
        clipper: OctagonClipper(padding: 30),
        child: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              border: Border.all(color: darkBlueColor, width: 1),
            ),
            child: Container(
              color: yellowColor.withOpacity(0.6),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipPath(
                      clipper: OctagonClipper(padding: 15),
                        child: Image.asset('assets/images/person.png', fit: BoxFit.cover,)
                    ),
                    const SizedBox(height: 10),
                    customText(formatName(data['Name']), 16, FontWeight.w700 , darkBlueColor, 1.3),
                    customText(formatName(data['Position']), 12, FontWeight.w600 , darkBlueColor.withOpacity(0.8), 1.3),
                  ],
                ),
              ),
            )
        ),
      ),
    );
  }
}

class OctagonClipper1 extends CustomClipper<Path> {
  final double padding;
  final double containerWidth;
  OctagonClipper1({required this.containerWidth, required this.padding});
  @override
  Path getClip(Size size) {
    final Path path = Path();
    final double width = size.width;
    // final double width = containerWidth;
    final double height = containerWidth;

    // const double padding = 20; // Adjust this value to modify the octagon cut

    path.moveTo(0, 0); // Top-left cut
    path.lineTo(width - padding, 0); // Top-right cut
    path.lineTo(width, padding); // Right-top cut
    path.lineTo(width, height); // Right-bottom cut
    path.lineTo(padding, height); // Bottom-left cut
    path.lineTo(0, height - padding); // Left-bottom cut
    path.close(); // Close the path

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}


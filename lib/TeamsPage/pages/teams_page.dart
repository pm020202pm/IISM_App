import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils.dart';
import '../../widgets/widgets.dart';
import 'package:excel/excel.dart' as exl;

import '../widgets/TeamsCard.dart';

class TeamsPage extends StatefulWidget {
  const TeamsPage({super.key});

  @override
  _TeamsPageState createState() => _TeamsPageState();
}

class _TeamsPageState extends State<TeamsPage> {

  @override
  void initState() {
    super.initState();
    if(head.isEmpty) loadExcelData();
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
        for (int colIndex = 0; colIndex < 7; colIndex++) {
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
    return SafeArea(
      child: Scaffold(
        backgroundColor: dark? Colors.black : Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: AppBar(
            backgroundColor: Colors.transparent,
            flexibleSpace: Container(
              alignment: Alignment.centerLeft,
              height: 80,
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: pageTitleText("Core Team"),
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(bottom: 50),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 14.0,
              mainAxisSpacing: 18.0,
              childAspectRatio:0.68,
            ),
            padding: const EdgeInsets.all(16.0),
            itemCount: head.length,
            itemBuilder: (context, index) {
              if (index >= head.length) {
                return const Center(child: CircularProgressIndicator());
              }
              return TeamsCard(data: head[index]);
            },
          ),
        )
        ,
      ),
    );
  }
}





List<String> splitName(String name) {
  List<String> names = name.split(' ');
  return names;
}
List<String> splitPosition(String name) {
  List<String> names = name.split(',');
  return names;
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


import 'package:flutter/material.dart';

import '../../widgets/widgets.dart';

class StandingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Dummy data for IITs and points
    final standings = [
      {'rank': 1, 'iit': 'IIT Kanpur', 'points': 120},
      {'rank': 2, 'iit': 'IIT Bombay', 'points': 110},
      {'rank': 3, 'iit': 'IIT Madras', 'points': 100},
      {'rank': 4, 'iit': 'IIT Delhi', 'points': 90},
      {'rank': 5, 'iit': 'IIT Kharagpur', 'points': 85},
      {'rank': 6, 'iit': 'IIT Roorkee', 'points': 80},
      {'rank': 7, 'iit': 'IIT Guwahati', 'points': 75},
      {'rank': 8, 'iit': 'IIT Hyderabad', 'points': 70},
      {'rank': 9, 'iit': 'IIT Indore', 'points': 65},
      {'rank': 10, 'iit': 'IIT Bhubaneswar', 'points': 60},
    ];

    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(66),
          child: AppBar(
            backgroundColor: Colors.transparent,
            flexibleSpace: Container(
              alignment: Alignment.center,
              height: 80,
              child: Row(
                children: [
                  const SizedBox(width: 52,),
                  pageTitleText("Standings"),
                ],
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Table(
            border: TableBorder.all(color: Colors.grey, width: 1),
            columnWidths: const {
              0: FlexColumnWidth(1.2),
              1: FlexColumnWidth(3),
              2: FlexColumnWidth(1.2),
            },
            children: [
              // Table header
              TableRow(
                decoration: BoxDecoration(color: Colors.blueAccent.withOpacity(0.2)),
                children: [
                  colHeading('Rank'),
                  colHeading('Institute'),
                  colHeading('Points'),
                ],
              ),

              // Table rows
              ...standings.map(
                    (entry) => TableRow(
                  decoration: BoxDecoration(
                    color: standings.indexOf(entry) % 2 == 0
                        ? Colors.grey[100]
                        : Colors.white,
                  ),
                  children: [
                    cellValue(entry['rank'].toString()),
                    iitValue(entry['iit'].toString()),
                    cellValue(entry['points'].toString()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget colHeading(String text){
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: Colors.blueAccent,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget cellValue(String text){
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14),
        textAlign: TextAlign.center,
      ),
    );
  }
  Widget iitValue(String text){
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          Image.asset('assets/logo/${text.toUpperCase()}.png', height: 25, fit: BoxFit.fitHeight,),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

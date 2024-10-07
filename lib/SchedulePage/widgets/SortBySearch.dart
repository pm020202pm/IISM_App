import 'package:flutter/material.dart';
class SortBySearch extends StatelessWidget {
  final Function(String newValue) changeSortCriteria;
  final TextEditingController searchController;
  final Function(String value) filterSchedule;
  final String sortCriteria;
  SortBySearch({super.key, required this.changeSortCriteria, required this.searchController, required this.filterSchedule, required this.sortCriteria});


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Sorting Dropdown
          // Container(
          //   decoration: BoxDecoration(
          //     color: Colors.transparent,
          //     borderRadius: BorderRadius.circular(30.0),
          //   ),
          //   child: DropdownButtonHideUnderline(
          //     child: DropdownButton<String>(
          //       value: sortCriteria,
          //       elevation: 10,
          //       onChanged: (String? newValue) {
          //         if (newValue != null) changeSortCriteria(newValue);
          //       },
          //       items: <String>['Sport', 'Time', 'Venue']
          //           .map<DropdownMenuItem<String>>((String value) {
          //         return DropdownMenuItem<String>(
          //           value: value,
          //           child: Container(
          //             width: 100,
          //             padding: const EdgeInsets.symmetric(vertical: 13.0, horizontal: 8.0),
          //             decoration: BoxDecoration(
          //               borderRadius: BorderRadius.circular(8.0),
          //               gradient: LinearGradient(
          //                 colors: [Colors.blue.shade200, Colors.blue.shade400],
          //                 begin: Alignment.topLeft,
          //                 end: Alignment.bottomRight,
          //               ),
          //             ),
          //             child: Row(
          //               children: [
          //                 Icon(
          //                   value == 'Date' ? Icons.date_range :
          //                   value == 'Sport' ? Icons.sports :
          //                   value == 'Time' ? Icons.access_time :
          //                   Icons.location_on,
          //                   color: Colors.white,
          //                 ),
          //                 const SizedBox(width: 10),
          //                 Text(
          //                   value,
          //                   style: const TextStyle(
          //                     color: Colors.white,
          //                     fontWeight: FontWeight.bold,
          //                   ),
          //                 ),
          //               ],
          //             ),
          //           ),
          //         );
          //       }).toList(),
          //     ),
          //   ),
          // ),
          // Search Bar
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: searchController,
                onChanged: filterSchedule,
                decoration: const InputDecoration(
                  hintText: "Search...",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(8.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

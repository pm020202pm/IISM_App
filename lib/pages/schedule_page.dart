import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iism/utils.dart';
import 'package:intl/intl.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  String _sortCriteria = 'Date'; // Default sort criteria
  final int _itemsPerPage = 7;
  DocumentSnapshot? _lastDocument;
  bool _hasMore = true;
  bool _isLoading = false;
  final List<QueryDocumentSnapshot> _scheduleDocs = [];

  @override
  void initState() {
    super.initState();
    _fetchMoreData();
  }

  void _filterSchedule(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
      _scheduleDocs.clear();
      _lastDocument = null;
      _hasMore = true;
      _fetchMoreData();
    });
  }

  Future<void> _fetchMoreData() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
    });

    Query query = FirebaseFirestore.instance
        .collection('schedule')
        .orderBy(_sortCriteria) // Adjust query to sort by selected criteria
        .limit(_itemsPerPage);

    if (_lastDocument != null) {
      query = query.startAfterDocument(_lastDocument!);
    }
    List<QueryDocumentSnapshot> mergedDocs = [];

    if (_searchQuery.isNotEmpty) {
      Query query1 = query.where('Sport', isGreaterThanOrEqualTo: _searchQuery).where('Sport', isLessThanOrEqualTo: '${_searchQuery}\uf8ff');
      Query query2 = query.where('Team1', isGreaterThanOrEqualTo: _searchQuery).where('Team1', isLessThanOrEqualTo: '${_searchQuery}\uf8ff');
      // Execute both queries
      QuerySnapshot querySnapshot1 = await query1.get();
      QuerySnapshot querySnapshot2 = await query2.get();

      // Merge results and remove duplicates
      Set<String> documentIds = Set();

      for (var doc in querySnapshot1.docs) {
        if (!documentIds.contains(doc.id)) {
          mergedDocs.add(doc);
          documentIds.add(doc.id);
        }
      }

      for (var doc in querySnapshot2.docs) {
        if (!documentIds.contains(doc.id)) {
          mergedDocs.add(doc);
          documentIds.add(doc.id);
        }
      }

      // query = query.where('Sport', isGreaterThanOrEqualTo: _searchQuery).where('Sport', isLessThanOrEqualTo: '${_searchQuery}\uf8ff');
    }
    if (mergedDocs.isNotEmpty) {
      _lastDocument = mergedDocs.last;
      _scheduleDocs.addAll(mergedDocs);
      if (mergedDocs.length < _itemsPerPage) {
        _hasMore = false;
      }
    }

    QuerySnapshot querySnapshot = await query.get();
    if (querySnapshot.docs.isNotEmpty) {
      _lastDocument = querySnapshot.docs.last;
      _scheduleDocs.addAll(querySnapshot.docs);
      if (querySnapshot.docs.length < _itemsPerPage) {
        _hasMore = false;
      }
    } else {
      _hasMore = false;
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120.0),
        child: AppBar(
          backgroundColor: Colors.transparent,
          title: null,
          flexibleSpace: Padding(
            padding: const EdgeInsets.only(top: 30.0, left: 16, right: 16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Schedule", style: TextStyle(fontSize: 40)),
                    TextButton(onPressed: () {}, child: Text("Fixture")),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // const SizedBox(width: 8),
                    Container(
                      width: 132,
                      // padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(30.0),
                        // border: Border.all(color: Colors.grey),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          menuWidth: 132,
                          value: _sortCriteria,
                          // icon: const Icon(Icons.arrow_downward, color: Colors.black),
                          // iconSize: 22,
                          // dropdownColor: Colors.transparent,
                          elevation: 10,
                          // style: const TextStyle(color: Colors.black, fontSize: 18),
                          onChanged: (String? newValue) {
                            setState(() {
                              _sortCriteria = newValue!;
                              _scheduleDocs.clear();
                              _lastDocument = null;
                              _hasMore = true;
                              _fetchMoreData();
                            });
                          },
                          items: <String>['Date', 'Sport', 'Time', 'Venue'].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Container(
                                width: 100,
                                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  gradient: LinearGradient(
                                    colors: [Colors.blue.shade200, Colors.blue.shade400],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      value == 'Date' ? Icons.date_range :
                                      value == 'Sport' ? Icons.sports :
                                      value == 'Time' ? Icons.access_time :
                                      Icons.location_on,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      value,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    Container(
                      width: 220,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: _filterSchedule,
                        decoration: const InputDecoration(
                          hintText: "Search...",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(8.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollInfo) {
          if (!_isLoading &&
              _hasMore &&
              scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            _fetchMoreData();
            return true;
          }
          return false;
        },
        child: ListView.builder(
          itemCount: _scheduleDocs.length + (_hasMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index >= _scheduleDocs.length) {
              return Center(child: CircularProgressIndicator());
            }
            var data = _scheduleDocs[index].data() as Map<String, dynamic>;
            DateTime date = DateTime.parse(data['Date']);
            String formattedDate = DateFormat('MMMM d, y').format(date);
            DateTime dateTime = DateFormat('HH:mm').parse(data['Time']);
            String formattedTime = DateFormat('h:mm a').format(dateTime);
            return Card(
              elevation: 4.0,
              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${formatName(data['Sport'])} - ${data['Team1'].toUpperCase()} vs ${data['Team2'].toUpperCase()}',
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text('Date: ${formattedDate}'),
                    Text('Time: ${formattedTime}'),
                    Text('Venue: ${data['Venue']}'),
                    if(data['Score1'] != '0' && data['Score2'] != '0')
                    const SizedBox(height: 8.0),
                    if(data['Score1'] != '0' && data['Score2'] != '0')
                    Row(
                      children: [
                        const Text('Score: '),
                        Text(
                          '${data['Score1']} - ${data['Score2']}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    if (data['Livelink'] != 'null' && data['Livelink'].isNotEmpty)
                      const SizedBox(height: 8.0),
                    if (data['Livelink'] != 'null' && data['Livelink'].isNotEmpty)
                      GestureDetector(
                        onTap: () {
                          // Handle live link tap
                        },
                        child: const Text(
                          'Watch Live',
                          style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

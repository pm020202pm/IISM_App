import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iism/utils.dart';

class PlayersPage extends StatefulWidget {
  const PlayersPage({super.key});

  @override
  _PlayersPageState createState() => _PlayersPageState();
}

class _PlayersPageState extends State<PlayersPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  String _sortCriteria = 'Name'; // Default sort criteria
  final int _itemsPerPage = 8;
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

    Query query = FirebaseFirestore.instance.collection('players').orderBy(_sortCriteria).limit(_itemsPerPage);
    if (_lastDocument != null) {
      query = query.startAfterDocument(_lastDocument!);
    }
    List<QueryDocumentSnapshot> mergedDocs = [];

    if (_searchQuery.isNotEmpty) {
      Query query1 = query.where('Name', isGreaterThanOrEqualTo: _searchQuery).where('Name', isLessThanOrEqualTo: '${_searchQuery}\uf8ff');
      Query query2 = query.where('College', isGreaterThanOrEqualTo: _searchQuery).where('College', isLessThanOrEqualTo: '${_searchQuery}\uf8ff');
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Players", style: TextStyle(fontSize: 40)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      // width: 115,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          menuWidth: 115,
                          value: _sortCriteria,
                          elevation: 10,
                          onChanged: (String? newValue) {
                            setState(() {
                              _sortCriteria = newValue!;
                              _scheduleDocs.clear();
                              _lastDocument = null;
                              _hasMore = true;
                              _fetchMoreData();
                            });
                          },
                          items: <String>['Name', 'Sport','Gender', 'RollNo', 'College'].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Container(
                                width: 85,
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
                    Expanded(
                      child: Container(
                        // width: 220,
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
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1, // 2 items per row
            crossAxisSpacing: 0.0, // Spacing between columns
            mainAxisSpacing: 5.0,  // Spacing between rows
            childAspectRatio: 4, // Adjust the aspect ratio as needed
          ),
          padding: const EdgeInsets.all(16.0),
          itemCount: _scheduleDocs.length + (_hasMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index >= _scheduleDocs.length) {
              return const Center(child: CircularProgressIndicator());
            }
            var data = _scheduleDocs[index].data() as Map<String, dynamic>;
            return Card(
              elevation: 2.0,
              margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.asset('assets/images/person.png', fit: BoxFit.cover)),
                    const SizedBox(width: 15.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          formatName(data['Name']),
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            height: 1
                          ),

                        ),
                        Text(formatName(data['Sport']),
                          style: TextStyle(
                              color: Colors.grey.shade800,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600,
                              height: 1
                          ),
                        ),
                        Text(data['College'][0].toUpperCase()+data['College'][1].toUpperCase()+data['College'][2].toUpperCase()+formatName(data['College'].substring(3)),
                          style: TextStyle(
                              color: Colors.grey.shade800,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600,
                              height: 1.1
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    // const SizedBox(height: 8.0),
                    // Text('${data['RollNo']}',
                    //   style: TextStyle(
                    //     color: Colors.grey.shade800,
                    //       fontSize: 14.0,
                    //       fontWeight: FontWeight.w600,
                    //       height: 1.1
                    //   ),
                    // ),


                    // Text('Email: ${data['Email']}'),
                    // Text('Gender: ${data['Gender']}'),
                    // Text('Phone No: ${data['PhoneNo']}'),
                    // Text('College: ${data['College']}'),
                    // Text('Sport: ${formatName(data['Department'])}'),
                  ],
                ),
              ),
            );
          },
        ),
      )
      ,
    );
  }
}

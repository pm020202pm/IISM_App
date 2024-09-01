import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  _GalleryPageState createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  String _sortCriteria = 'Sport'; // Default sort criteria
  final int _itemsPerPage = 15;
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

    Query query = FirebaseFirestore.instance.collection('gallery').orderBy(_sortCriteria).limit(_itemsPerPage);
    if (_lastDocument != null) {
      query = query.startAfterDocument(_lastDocument!);
    }
    List<QueryDocumentSnapshot> mergedDocs = [];

    if (_searchQuery.isNotEmpty) {
      Query query1 = query.where('Sport', isGreaterThanOrEqualTo: _searchQuery).where('Sport', isLessThanOrEqualTo: '${_searchQuery}\uf8ff');
      Query query2 = query.where('Caption', isGreaterThanOrEqualTo: _searchQuery).where('Caption', isLessThanOrEqualTo: '${_searchQuery}\uf8ff');
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
                const Text("Gallery", style: TextStyle(fontSize: 40)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Container(
                    //   width: 115,
                    //   decoration: BoxDecoration(
                    //     color: Colors.transparent,
                    //     borderRadius: BorderRadius.circular(30.0),
                    //   ),
                    //   child: DropdownButtonHideUnderline(
                    //     child: DropdownButton<String>(
                    //       menuWidth: 115,
                    //       value: _sortCriteria,
                    //       elevation: 10,
                    //       onChanged: (String? newValue) {
                    //         setState(() {
                    //           _sortCriteria = newValue!;
                    //           _scheduleDocs.clear();
                    //           _lastDocument = null;
                    //           _hasMore = true;
                    //           _fetchMoreData();
                    //         });
                    //       },
                    //       items: <String>['Sport','Gender', 'RollNo', 'College'].map<DropdownMenuItem<String>>((String value) {
                    //         return DropdownMenuItem<String>(
                    //           value: value,
                    //           child: Container(
                    //             width: 85,
                    //             padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
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
                    Container(
                      width: 320,
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
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // 2 items per row
            crossAxisSpacing: 10.0, // Spacing between columns
            mainAxisSpacing: 10.0,  // Spacing between rows
            childAspectRatio: 1, // Adjust the aspect ratio as needed
          ),
          padding: const EdgeInsets.all(16.0),
          itemCount: _scheduleDocs.length + (_hasMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index >= _scheduleDocs.length) {
              return const Center(child: CircularProgressIndicator());
            }
            var data = _scheduleDocs[index].data() as Map<String, dynamic>;
            return ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Container(
                // width: 200, // Set width
                // height: 200, // Set height (same as width for square)
                child: Image.network(
                  data['ImageUrl'],
                  fit: BoxFit.cover, // Ensure the image covers the container
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

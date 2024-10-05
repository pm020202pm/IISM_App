import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shimmer/shimmer.dart';
import '../../SchedulePage/widgets/widgets.dart';
import '../../utils.dart';
import '../../widgets/widgets.dart';
import 'full_screen_image_page.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  _GalleryPageState createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  // final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  int _itemsPerPage = 15;
  final String _sortCriteria = 'Sport';
  DocumentSnapshot? _lastDocument;
  bool _hasMore = true;
  bool _isLoading = false;
  final List<QueryDocumentSnapshot> _scheduleDocs = [];
  int gridCount = 3;

  @override
  void initState() {
    super.initState();
    _fetchMoreData();
  }

  void _openFullScreenImageViewer(int index) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FullScreenImageViewer(
          initialDocs: _scheduleDocs,
          initialIndex: index,
          sortCriteria: _sortCriteria,
        ),
      ),
    );
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

      QuerySnapshot querySnapshot1 = await query1.get();
      QuerySnapshot querySnapshot2 = await query2.get();

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
      backgroundColor: dark? Colors.black : Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(75.0),
        child: AppBar(
          backgroundColor: Colors.transparent,
          flexibleSpace: Padding(
            padding: const EdgeInsets.only(top: 60.0, left: 16, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    pageTitleText("Gallery"),
                    IconButton(
                      padding: const EdgeInsets.all(0),
                      icon: Icon(Icons.grid_3x3), onPressed: (){
                      setState(() {
                        gridCount = 3;
                      });
                    },),
                    IconButton(icon: Icon(Icons.grid_4x4), onPressed: (){
                      setState(() {
                        gridCount = 4;
                        _itemsPerPage = 30;
                        _fetchMoreData();
                      });
                    },),

                  ],
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Container(
                //       width: 320,
                //       decoration: BoxDecoration(
                //         border: Border.all(color: Colors.grey),
                //         borderRadius: BorderRadius.circular(12),
                //       ),
                //       child: TextField(
                //         controller: _searchController,
                //         onChanged: _filterSchedule,
                //         decoration: const InputDecoration(
                //           hintText: "Search...",
                //           border: InputBorder.none,
                //           contentPadding: EdgeInsets.all(8.0),
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollInfo) {
          if (!_isLoading && _hasMore && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            _fetchMoreData();
            return true;
          }
          return false;
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: MasonryGridView.count(
            crossAxisCount: gridCount,
            itemCount: _scheduleDocs.length + (_hasMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= _scheduleDocs.length) {
                return const Center(child: CircularProgressIndicator());
              }
              var data = _scheduleDocs[index].data() as Map<String, dynamic>;
              return GestureDetector(
                onTap: () => _openFullScreenImageViewer(index),
                child: Container(
                  height: (index % 3+1) * 70,
                  // width: 100,
                  margin: const EdgeInsets.all(1.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.grey.shade200,
                    image: DecorationImage(
                      image: NetworkImage(data['ImageUrl']),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
    ));

  }
}

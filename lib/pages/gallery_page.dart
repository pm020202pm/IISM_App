import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'full_screen_image_page.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  _GalleryPageState createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  final int _itemsPerPage = 15;
  String _sortCriteria = 'Sport';
  DocumentSnapshot? _lastDocument;
  bool _hasMore = true;
  bool _isLoading = false;
  final List<QueryDocumentSnapshot> _scheduleDocs = [];

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
            crossAxisCount: 3, // 3 items per row
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
            bool _isImageLoaded = false;

            return GestureDetector(
              onTap: () => _openFullScreenImageViewer(index),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Stack(
                  children: [
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        color: Colors.grey[300],
                      ),
                    ),
                    Image.network(
                      data['ImageUrl'],
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) {
                          // Image is fully loaded
                          _isImageLoaded = true;
                          return child;
                        } else {
                          return const SizedBox(); // Return an empty widget to keep the shimmer visible while loading
                        }
                      },
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

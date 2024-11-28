import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
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
  final String _searchQuery = "";
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
      Query query1 = query.where('Sport', isGreaterThanOrEqualTo: _searchQuery).where('Sport', isLessThanOrEqualTo: '$_searchQuery\uf8ff');
      Query query2 = query.where('Caption', isGreaterThanOrEqualTo: _searchQuery).where('Caption', isLessThanOrEqualTo: '$_searchQuery\uf8ff');

      QuerySnapshot querySnapshot1 = await query1.get();
      QuerySnapshot querySnapshot2 = await query2.get();

      Set<String> documentIds = {};

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
    return SafeArea(
      child: Scaffold(
        backgroundColor: dark? Colors.black : Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: AppBar(
            backgroundColor: Colors.transparent,
            flexibleSpace: Container(
              alignment: Alignment.center,
              height: 80,
              child: Row(
                children: [
                  const SizedBox(width: 16,),
                  pageTitleText("Gallery"),
                  const Spacer(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: (){
                          setState(() {
                            gridCount = 3;
                          });
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                // color: Colors.red,
                                borderRadius: BorderRadius.circular(3),
                                border: Border.all(color: gridCount==3? blueColor: Colors.grey, width: 2),
                              ),
                            ),
                            Icon(Icons.grid_3x3, color: gridCount==3? blueColor: Colors.grey,),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      InkWell(
                        onTap: (){
                          setState(() {
                            gridCount = 4;
                            _itemsPerPage = 30;
                            _fetchMoreData();
                          });
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              height: 24,
                              width: 24,
                              decoration: BoxDecoration(
                                // color: Colors.red,
                                borderRadius: BorderRadius.circular(3),
                                border: Border.all(color: gridCount==4? blueColor: Colors.grey, width: 2),
                              ),
                            ),
                            Icon(Icons.grid_4x4, color: gridCount==4? blueColor: Colors.grey, ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16,),
                ],
              ),
            ),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            _lastDocument = null;
            _hasMore = true;
            _scheduleDocs.clear();
            await _fetchMoreData();
          },
          child: NotificationListener<ScrollNotification>(
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
                      margin: const EdgeInsets.all(3.0),
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
              ),
        )),
    );

  }
}

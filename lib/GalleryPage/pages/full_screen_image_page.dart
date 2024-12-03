import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FullScreenImageViewer extends StatefulWidget {
  final List<QueryDocumentSnapshot> initialDocs;
  final int initialIndex;

  const FullScreenImageViewer({
    super.key,
    required this.initialDocs,
    required this.initialIndex
  });

  @override
  _FullScreenImageViewerState createState() => _FullScreenImageViewerState();
}

class _FullScreenImageViewerState extends State<FullScreenImageViewer> {
  late int _currentIndex;
  late List<QueryDocumentSnapshot> _imageDocs;
  bool _isLoadingMore = false;
  DocumentSnapshot? _lastDocument;
  bool _hasMoreImages = true;

  @override
  void initState() {
    super.initState();
    _imageDocs = widget.initialDocs;
    _currentIndex = widget.initialIndex;
    _lastDocument = _imageDocs.isNotEmpty ? _imageDocs.last : null;
  }

  Future<void> _loadMoreImages() async {
    if (_isLoadingMore || !_hasMoreImages) return;

    setState(() {
      _isLoadingMore = true;
    });

    Query query = FirebaseFirestore.instance
        .collection('gallery')
        .startAfterDocument(_lastDocument!)
        .limit(15);

    QuerySnapshot querySnapshot = await query.get();

    if (querySnapshot.docs.isNotEmpty) {
      setState(() {
        _lastDocument = querySnapshot.docs.last;
        _imageDocs.addAll(querySnapshot.docs);
        if (querySnapshot.docs.length < 15) {
          _hasMoreImages = false;
        }
      });
    } else {
      setState(() {
        _hasMoreImages = false;
      });
    }

    setState(() {
      _isLoadingMore = false;
    });
  }

  void _nextImage() {
    if (_currentIndex < _imageDocs.length - 1) {
      setState(() {
        _currentIndex++;
      });
    } else if (_hasMoreImages) {
      _loadMoreImages().then((_) {
        if (_currentIndex < _imageDocs.length - 1) {
          setState(() {
            _currentIndex++;
          });
        }
      });
    }
  }

  void _previousImage() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var currentData = _imageDocs[_currentIndex].data() as Map<String, dynamic>;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment.center,
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Center(
              child: Stack(
                children: [
                  Image.network(
                    currentData['ImageUrl'],
                    fit: BoxFit.contain,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 16.0,
            child: IconButton(
              color: Colors.white,
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: _currentIndex > 0 ? _previousImage : null,
            ),
          ),
          Positioned(
            right: 16.0,
            child: IconButton(
              icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
              onPressed: _currentIndex < _imageDocs.length - 1 || _hasMoreImages
                  ? _nextImage
                  : null,
            ),
          ),
          Positioned(
            bottom: 80.0, // Adjust this value to position the caption higher or lower
            left: 16.0,
            right: 16.0,
            child: Text(
              currentData['Caption'] ?? '', // Display caption or an empty string if null
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
              maxLines: 2, // Adjust the number of lines according to your needs
              overflow: TextOverflow.ellipsis, // Handle overflow if caption is too long
            ),
          ),
        ],
      ),
    );
  }
}

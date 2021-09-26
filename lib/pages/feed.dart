import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feedly/pages/create.dart';
import 'package:flutter_feedly/widgets/compose_box.dart';
import 'package:simple_moment/simple_moment.dart';
import 'package:transparent_image/transparent_image.dart';

class FeedPage extends StatefulWidget {
  FeedPage({Key? key}) : super(key: key);

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  List<Widget> _posts = [];
  List<DocumentSnapshot> _postDocuments = [];
  Future? _getFeedFuture;

  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  ScrollController _scrollController = ScrollController();

  bool _loadingMorePosts = false;

  bool _canLoadMorePost = true;

  DocumentSnapshot? _lastDocument;

  _navigateToCreatePage() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext ctx) {
          return CreatePage();
        },
      ),
    );

    // Refresh the feed
    _getFeedFuture = _getFeed();
  }

  Future _getFeed() async {
    _posts = [];

    Query _query = _firestore
        .collection('posts')
        .orderBy('created', descending: true)
        .limit(10);

    QuerySnapshot _querySnapshot = await _query.get();
    print('*************************************');
    print(_querySnapshot.docs.length);
    print('*************************************');
    _postDocuments = _querySnapshot.docs;

    _lastDocument = _postDocuments[_postDocuments.length - 1];

    for (int i = 0; i < _postDocuments.length; ++i) {
      Widget w = _makeCard(_postDocuments[i]);
      //  ListTile(
      //   title: Text(_postDocuments[i]['text']),
      //   // subtitle: Text(_postDocuments[i]['owner_name']),
      // );

      _posts.add(w);
    }
    return _postDocuments;
  }

  Future _getMoreFeed() async {
    if (_loadingMorePosts == true) {
      print('Already loading more posts ... ');
      return null;
    }
    // print('Loading more data');

    if (_canLoadMorePost == false) {
      print('No more data to load ... ');
      return null;
    }

    _loadingMorePosts = true;

    Query _query = _firestore
        .collection('posts')
        .orderBy('created', descending: true)
        .limit(10)
        .startAfter([_lastDocument!['created']]);

    QuerySnapshot _querySnapshot = await _query.get();
    print('*************************************');
    print(_querySnapshot.docs.length);
    print('*************************************');

    if (_querySnapshot.docs.length < 10) {
      print('Loaded all posts ... ');
      _canLoadMorePost = false;
    }

    _postDocuments = _querySnapshot.docs;

    _lastDocument = _postDocuments[_postDocuments.length - 1];

    for (int i = 0; i < _postDocuments.length; ++i) {
      Widget w = _makeCard(_postDocuments[i]);
      //  ListTile(
      //   title: Text(_postDocuments[i]['text']),
      //   // subtitle: Text(_postDocuments[i]['owner_name']),
      // );

      _posts.add(w);
    }

    setState(() {
      _loadingMorePosts = false;
    });

    return _postDocuments;
  }

  _getItems() {
    List<Widget> _items = [];
    Widget _composeBox = GestureDetector(
      child: const ComposeBox(),
      onTap: () {
        _navigateToCreatePage();
        debugPrintStack();
        debugPrint('onTap is called');
      },
    );
    _items.add(_composeBox);

    Widget separator = Container(
      padding: const EdgeInsets.all(10.0),
      child: Text(
        'Recent Posts',
        style: TextStyle(color: Colors.black54),
      ),
    );
    _items.add(separator);

    Widget feed = FutureBuilder(
        future: _getFeed(),
        builder: (BuildContext ctx, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.data == null) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                CircularProgressIndicator(),
                SizedBox(
                  height: 16.0,
                ),
                Text('Loading...'),
              ],
            );
          } else if (snapshot.data.length == 0) {
            return Text('No data to display');
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: _posts,
            );
          }
        });
    _items.add(feed);
    return _items;
  }

// this initstate function gets executed as soon as the state of this widget is initilized
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.25;

      if (maxScroll - currentScroll <= delta) {
        // load more posts
        _getMoreFeed();
      }
    });

    _getFeedFuture = _getFeed();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.rss_feed),
        title: const Text('Your Feed'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: ListView(
        controller: _scrollController,
        children: _getItems(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToCreatePage,
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _makeCard(DocumentSnapshot postDocument) {
    return Card(
      margin: EdgeInsets.all(8.0),
      elevation: 5.0,
      child: Column(
        children: [
          ListTile(
            title: Text(
              postDocument['text'],
            ),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.watch_later,
                  size: 14.0,
                ),
                SizedBox(
                  width: 4.0,
                ),
                Text(
                  Moment.now().from(
                    (postDocument['created'] as Timestamp).toDate(),
                  ),
                ),
              ],
            ),
          ),
          postDocument['image'] == null
              ? Container()
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: postDocument['image'],
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(postDocument['text']),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: TextButton(
                  child: Text(
                    '4 likes',
                    style: TextStyle(fontSize: 12),
                  ),
                  onPressed: () {},
                ),
              ),
              Expanded(
                child: TextButton(
                  child: Text(
                    '2 comments',
                    style: TextStyle(fontSize: 12),
                  ),
                  onPressed: () {},
                ),
              ),
              Expanded(
                child: TextButton(
                  child: Text(
                    'Share',
                    style: TextStyle(fontSize: 12),
                  ),
                  onPressed: () {},
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

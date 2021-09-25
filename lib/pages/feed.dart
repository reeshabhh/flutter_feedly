import 'package:flutter/material.dart';
import 'package:flutter_feedly/pages/create.dart';
import 'package:flutter_feedly/widgets/compose_box.dart';

class FeedPage extends StatefulWidget {
  FeedPage({Key? key}) : super(key: key);

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  _navigateToCreatePage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext ctx) {
          return CreatePage();
        },
      ),
    );
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
    return _items;
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
        children: _getItems(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToCreatePage,
        child: Icon(Icons.add),
      ),
    );
  }
}

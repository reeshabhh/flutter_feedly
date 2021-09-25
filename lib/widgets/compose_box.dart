import 'package:flutter/material.dart';

class ComposeBox extends StatelessWidget {
  const ComposeBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.deepOrange.withOpacity(0.1),
      padding: const EdgeInsets.only(right: 16.0, top: 6.0, bottom: 12.0),
      margin: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 16.0, top: 16.0),
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(40.0),
                  border: Border.all(
                    width: 1.0,
                    color: Colors.deepOrange,
                  )),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Text('Write something here ...'),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(
              top: 12.0,
              left: 8.0,
            ),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.send,
                color: Colors.deepOrange,
              ),
            ),
          )
        ],
      ),
    );
  }
}

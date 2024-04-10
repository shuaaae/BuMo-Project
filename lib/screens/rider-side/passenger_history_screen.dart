import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PassengerHistoryScreen extends ConsumerWidget {
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Center(
            child: Text(
          "History",
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        )),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(10),
            width: 350,
            height: 90,
          )
        ],
      ),
    );
  }
}

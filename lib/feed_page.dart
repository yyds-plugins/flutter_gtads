import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gtads/flutter_gtads.dart';

import 'feed_view.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  @override
  void initState() {
// TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final codes = FlutterGTAds.bannerCodes();
    for (var action in codes) {
      debugPrint("androidId ${action.androidId} iosId ${action.iosId}");
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("FeedView"),
      ),
      body: FeedView(),
    );
  }
}

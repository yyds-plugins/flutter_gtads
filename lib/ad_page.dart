import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gtads/flutter_gtads.dart';
import 'package:flutter_gtads/splash_page.dart';

import 'feed_page.dart';
import 'feed_view.dart';

class AdPage extends StatefulWidget {
  const AdPage({Key? key}) : super(key: key);

  @override
  State<AdPage> createState() => _AdPageState();
}

class _AdPageState extends State<AdPage> {
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
          title: const Text("Demo"),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FlutterGTAds.bannerView(),
                Text("banner广告"),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const SplashPage(nextPage: FeedPage())));
                  },
                  child: Text("开屏广告"),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    FlutterGTAds.showInsertAd();
                  },
                  child: Text("插屏广告"),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    FlutterGTAds.showRewardAd(onVerifyClose: (c, v) {});
                  },
                  child: Text("激励视频广告"),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                    child: Text("信息流广告"),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const FeedPage()));
                    }),
              ],
            ),
          ),
        ));
  }
}

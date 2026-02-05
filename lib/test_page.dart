import 'package:flutter/material.dart';
import 'package:flutter_gtads/flutter_gtads.dart';

import 'feed_page.dart';

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
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
                FlutterGTAds.bannerView(w: MediaQuery.of(context).size.width, h: 50),
                Text("banner广告"),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => FlutterGTAds.splashWidget(
                                w: MediaQuery.of(context).size.width,
                                h: MediaQuery.of(context).size.height,
                                dismiss: () {})));
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

import 'package:flutter/material.dart';
import 'package:gtads/gtads.dart';

import 'flutter_gtads.dart';

class AdSplashPage extends StatefulWidget {
  final void Function() dismiss;
  const AdSplashPage({required this.dismiss, super.key});

  @override
  State<AdSplashPage> createState() => _AdSplashPageState();
}

class _AdSplashPageState extends State<AdSplashPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GTAdsSplashWidget(
      codes: FlutterGTAds.splashCodes(),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      //超时时间 当广告失败后会依次重试其他广告 直至所有广告均加载失败 设置超时时间可提前取消
      timeout: 10,
      callBack: GTAdsCallBack(
        onShow: (code) {
          debugPrint("开屏显示 ${code.toJson()}");
        },
        onClick: (code) {
          debugPrint("开屏点击 ${code.toJson()}");
        },
        onFail: (code, message) {
          debugPrint("开屏错误 ${code?.toJson()} $message");
          widget.dismiss();
        },
        onClose: (code) {
          debugPrint("开屏关闭 ${code.toJson()}");
          widget.dismiss();
        },
        onTimeout: () {
          debugPrint("开屏加载超时");
          widget.dismiss();
        },
        onEnd: () {
          debugPrint("开屏所有广告位都加载失败");
          widget.dismiss();
        },
      ),
    ));
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gtads/gtads.dart';

import 'flutter_gtads.dart';
import 'log_util.dart';

class AdSplashPage extends StatefulWidget {
  final void Function() dismiss;
  const AdSplashPage({required this.dismiss, super.key});

  @override
  State<AdSplashPage> createState() => _AdSplashPageState();
}

class _AdSplashPageState extends State<AdSplashPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FlutterUnionad.requestPermissionIfNecessary(
      callBack: FlutterUnionadPermissionCallBack(
        notDetermined: () {
          LogUtil.dp("权限未确定");
        },
        restricted: () {
          LogUtil.dp("权限限制");
        },
        denied: () {
          LogUtil.dp("权限拒绝");
        },
        authorized: () {
          LogUtil.dp("权限同意");
        },
      ),
    );
  }

  static Future<void> showCustomTrackingDialog(BuildContext context) async => await showCupertinoDialog<void>(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('万源阅读'),
          content: const Text(
            '我们通过显示广告来保持这个应用程序免费\n'
            '为了向您提供更优质、安全的个性化服务及内容，需要您允许使用广告相关权限',
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.pop(context),
              child: const Text('确定'),
            ),
          ],
        ),
      );

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
          LogUtil.dp("开屏显示 ${code.toJson()}");
        },
        onClick: (code) {
          LogUtil.dp("开屏点击 ${code.toJson()}");
        },
        onFail: (code, message) {
          LogUtil.dp("开屏错误 ${code?.toJson()} $message");
          widget.dismiss();
        },
        onClose: (code) {
          LogUtil.dp("开屏关闭 ${code.toJson()}");
          widget.dismiss();
        },
        onTimeout: () {
          LogUtil.dp("开屏加载超时");
          widget.dismiss();
        },
        onEnd: () {
          LogUtil.dp("开屏所有广告位都加载失败");
          widget.dismiss();
        },
      ),
    ));
  }
}

import 'package:flutter/material.dart';
import 'package:gtads/gtads.dart';

import 'flutter_gtads.dart';

class SplashPage extends StatefulWidget {
  final Widget nextPage;

  const SplashPage({required this.nextPage, super.key});

  @override
  State<StatefulWidget> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    // TODO: implement initState
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: GTAdsSplashWidget(
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
              _nextPage();
            },
            onClose: (code) {
              debugPrint("开屏关闭 ${code.toJson()}");
              _nextPage();
            },
            onTimeout: () {
              debugPrint("开屏加载超时");
              _nextPage();
            },
            onEnd: () {
              debugPrint("开屏所有广告位都加载失败");
              _nextPage();
            },
          ),
        ));
  }

  /// 下个页面
  void _nextPage() {
    _animationController.reverse().then((_) {
      final route = PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => widget.nextPage,
        transitionDuration: Duration.zero, // 设置过渡动画时间为零
        reverseTransitionDuration: Duration.zero, // 设置反向过渡动画时间为零
      );
      Navigator.pushReplacement(context, route);
    });
  }
}

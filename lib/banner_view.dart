import 'package:flutter/material.dart';
import 'package:gtads/gtads.dart';

import 'flutter_gtads.dart';

class BannerView extends StatefulWidget {
  final double w;
  final double h;
  const BannerView({super.key, this.w = 0, this.h = 0});

  @override
  State<BannerView> createState() => _BannerViewState();
}

class _BannerViewState extends State<BannerView> with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GTAdsBannerWidget(
        codes: FlutterGTAds.bannerCodes(),
        width: widget.w,
        height: widget.h,
        //超时时间 当广告失败后会依次重试其他广告 直至所有广告均加载失败 设置超时时间可提前取消
        timeout: 10,
        model: GTAdsModel.RANDOM,
        //回调
        callBack: GTAdsCallBack(
          onShow: (code) {
            debugPrint("Banner显示 ${code.toJson()}");
          },
          onClick: (code) {
            debugPrint("Banner点击 ${code.toJson()}");
          },
          onFail: (code, message) {
            debugPrint("Banner错误 ${code?.toJson()} $message");
          },
          onClose: (code) {
            debugPrint("Banner关闭 ${code.toJson()}");
          },
          onTimeout: () {
            debugPrint("Banner加载超时");
          },
          onEnd: () {
            debugPrint("Banner所有广告位都加载失败");
          },
        ));
  }

  @override
  bool get wantKeepAlive => true;
}

import 'package:flutter/material.dart';
import 'package:gtads/gtads.dart';

import 'flutter_gtads.dart';
import 'log_util.dart';

class BannerView extends StatefulWidget {
  final double h;
  const BannerView({super.key, this.h = 10});

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
        codes: FlutterGTAds.bannerCodes().where((element) => (element.iosId!.isNotEmpty || element.androidId!.isNotEmpty)).toList(),
        width: MediaQuery.of(context).size.width,
        height: 75,
        //超时时间 当广告失败后会依次重试其他广告 直至所有广告均加载失败 设置超时时间可提前取消
        timeout: 1000,
        model: GTAdsModel.RANDOM,
        //回调
        callBack: GTAdsCallBack(
          onShow: (code) {
            LogUtil.dp("Banner显示 ${code.toJson()}");
          },
          onClick: (code) {
            LogUtil.dp("Banner点击 ${code.toJson()}");
          },
          onFail: (code, message) {
            LogUtil.dp("Banner错误 ${code?.toJson()} $message");
          },
          onClose: (code) {
            LogUtil.dp("Banner关闭 ${code.toJson()}");
          },
          onTimeout: () {
            LogUtil.dp("Banner加载超时");
          },
          onEnd: () {
            LogUtil.dp("Banner所有广告位都加载失败");
          },
        ));
  }

  @override
  bool get wantKeepAlive => true;
}

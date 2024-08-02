import 'package:flutter/material.dart';
import 'package:gtads/gtads.dart';

import 'flutter_gtads.dart';

class FeedView extends StatefulWidget {
  final void Function()? onRenderSuccess;

  const FeedView({Key? key, this.onRenderSuccess}) : super(key: key);

  @override
  State<FeedView> createState() => _FeedViewState();
}

class _FeedViewState extends State<FeedView> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return GTAdsNativeWidget(
      //需要的广告位组
      codes: FlutterGTAds.nativeCodes(),
      width: MediaQuery.of(context).size.width,
      height: 0,
      //超时时间 当广告失败后会依次重试其他广告 直至所有广告均加载失败 设置超时时间可提前取消
      timeout: 1000,
      //广告加载模式 [GTAdsModel.PRIORITY]优先级模式 [GTAdsModel.RANDOM]随机模式
      //默认随机模式
      model: GTAdsModel.RANDOM,
      callBack: GTAdsCallBack(
        onShow: (code) {
          debugPrint("信息流显示 ${code.toJson()}");
        },
        onClick: (code) {
          debugPrint("信息流点击 ${code.toJson()}");
        },
        onFail: (code, message) {
          debugPrint("信息流错误 ${code?.toJson()} $message");
        },
        onClose: (code) {
          debugPrint("信息流关闭 ${code.toJson()}");
        },
        onTimeout: () {
          debugPrint("信息流加载超时");
        },
        onEnd: () {
          debugPrint("信息流所有广告位都加载失败");
        },
      ),
    );
  }
}

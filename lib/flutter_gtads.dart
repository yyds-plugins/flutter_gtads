library flutter_gtads;

import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:gtads/gtads.dart';
import 'package:gtads_bqt/gtads_bqt.dart';
import 'package:gtads_csj/gtads_csj.dart';
import 'package:gtads_ks/gtads_ks.dart';
import 'package:gtads_ylh/gtads_ylh.dart';

import 'adid.dart';
import 'banner_view.dart';
import 'feed_view.dart';

export 'package:gtads_csj/gtads_csj.dart';
export 'package:flutter_gtads/test_page.dart';

export 'package:gtads/gtads.dart';

class FlutterGTAds {
  static bool get isDebug {
    bool inDebugMode = false;
    assert(inDebugMode = true); //如果debug模式下会触发赋值
    return inDebugMode;
  }

  static List<AdID> get configs => _configs;

  static List<AdID> _configs = [];

  /// 初始化
  static Future<void> initSDK({List<AdID> configs = const []}) async {
    _configs = configs;

    if (!_configs.isNotEmpty) return;

    List<GTAdsProvider> providers = [];
    for (var e in configs) {
      debugPrint("alias=${e.alias}");

      if (e.alias == Alias.csj || e.alias == Alias.gromore) {
        final provider =
            GTAdsCsjProvider(e.alias.code, e.androidId, e.iosId, useMediation: e.alias == Alias.gromore, appName: 'X');
        providers.add(provider);
      }

      if (e.alias == Alias.ylh) providers.add(GTAdsYlhProvider(e.alias.code, e.androidId, e.iosId));
      if (e.alias == Alias.ks) providers.add(GTAdsKSProvider(e.alias.code, e.androidId, e.iosId));
      if (e.alias == Alias.bqt) providers.add(GTAdsBqtProvider(e.alias.code, e.androidId, e.iosId));
    }

    //添加广告支持
    GTAds.addProviders(providers);
    //初始化广告
    List<Map<String, bool>> initAd = await GTAds.init(isDebug: kDebugMode);
    debugPrint("广告初始化结果$initAd");
  }

  //横幅广告位
  static List<GTAdsCode> bannerCodes() {
    return _configs
        .map((e) => GTAdsCode(alias: e.alias.code, probability: 1, androidId: e.androidBannerId, iosId: e.iosBannerId))
        .toList()
        .where((element) =>
            (element.iosId!.isNotEmpty || element.androidId!.isNotEmpty) && element.alias != Alias.ylh.code)
        .toList();
  }

  //信息流广告位
  static List<GTAdsCode> nativeCodes() {
    var list = _configs
        .map((e) => GTAdsCode(alias: e.alias.code, probability: 1, androidId: e.androidNativeId, iosId: e.iosNativeId))
        .toList();
    list = list.where((e) => e.alias != Alias.ks.code).toList();
    return list;
  }

  //开屏广告位
  static List<GTAdsCode> splashCodes() {
    return _configs
        .map((e) => GTAdsCode(alias: e.alias.code, probability: 1, androidId: e.androidSplashId, iosId: e.iosSplashId))
        .toList();
  }

  //激励广告位
  static List<GTAdsCode> rewardCodes() {
    return _configs
        .map((e) => GTAdsCode(alias: e.alias.code, probability: 1, androidId: e.androidRewardId, iosId: e.iosRewardId))
        .toList();
  }

  //插屏广告位
  static List<GTAdsCode> insertCodes() {
    return _configs
        .map((e) => GTAdsCode(alias: e.alias.code, probability: 1, androidId: e.androidInsertId, iosId: e.iosInsertId))
        .toList();
  }

  /// 开屏
  static Widget splashWidget({double w = 0, double h = 0, required void Function() dismiss}) {
    if (!_configs.isNotEmpty) {
      dismiss();
      return Container();
    }

    /// [onShow] 广告加载成功
    /// [onFail] 广告加载失败（单广告位）
    /// [onClick] 广告加载点击
    /// [onVerify] 广告验证
    /// [onClose] 广告关闭
    /// [onTimeout] 广告加载超时
    /// [onEnd] 广告加载结束（所有广告均加载失败）
    /// [onExpand] 广告扩展回调
    return GTAdsSplashWidget(
      codes: FlutterGTAds.splashCodes(),
      width: w,
      height: h,
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
          debugPrint(" 广告加载失败（单广告位） ${code?.toJson()} $message");
        },
        onClose: (code) {
          debugPrint("开屏关闭 ${code.toJson()}");
          dismiss();
        },
        onTimeout: () {
          debugPrint("开屏加载超时");
          dismiss();
        },
        onEnd: () {
          debugPrint("开屏所有广告位都加载失败");
          dismiss();
        },
      ),
    );
  }

  /// 显示信息流
  static Widget feedView({required double w, required double h}) {
    if (!_configs.isNotEmpty) return Container();
    return FeedView(
      w: w,
      h: h,
    );
  }

  /// 显示横幅广告
  static Widget bannerView({required double w, required double h}) {
    if (!_configs.isNotEmpty) return Container();
    return BannerView(w: w, h: h);
  }

  /// 插屏广告
  static Future<bool> showInsertAd() async {
    if (!_configs.isNotEmpty) return true;
    Completer<bool> completer = Completer();
    var b = await GTAds.insertAd(
        codes: insertCodes(),
        isFull: false,
        //超时时间 当广告失败后会依次重试其他广告 直至所有广告均加载失败 设置超时时间可提前取消
        timeout: 10,
        model: GTAdsModel.RANDOM,
        callBack: GTAdsCallBack(
          onShow: (code) {
            debugPrint("插屏广告显示 ${code.toJson()}");
          },
          onFail: (code, message) {
            debugPrint("插屏广告失败 ${code?.toJson()} $message");
            if (!completer.isCompleted) completer.complete(true);
          },
          onClick: (code) {
            debugPrint("插屏广告点击 ${code.toJson()}");
          },
          onClose: (code) {
            debugPrint("插屏广告关闭 ${code.toJson()}");
            if (!completer.isCompleted) completer.complete(true);
          },
          onTimeout: () {
            debugPrint("插屏广告加载超时");
            if (!completer.isCompleted) completer.complete(true);
          },
          onEnd: () {
            debugPrint("插屏广告所有广告位都加载失败");
            if (!completer.isCompleted) completer.complete(true);
          },
        ));
    if (b) {
      debugPrint("插屏广告开始请求");
    }
    return await completer.future;
  }

  static showRewardAd({required Function(GTAdsCode, bool) onVerifyClose}) async {
    var adVerify = false;
    var b = await GTAds.rewardAd(
      codes: rewardCodes(),
      //奖励名称
      rewardName: "100金币",
      //奖励数量
      rewardAmount: 100,
      //用户id
      userId: "user100",
      //扩展参数
      customData: "123",
      //超时时间 当广告失败后会依次重试其他广告 直至所有广告均加载失败 设置超时时间可提前取消
      timeout: 10,
      model: GTAdsModel.RANDOM,
      callBack: GTAdsCallBack(
        onShow: (code) {
          debugPrint("激励广告显示 ${code.toJson()}");
        },
        onFail: (code, message) {
          debugPrint("激励广告失败 ${code?.toJson()} $message");
        },
        onClick: (code) {
          debugPrint("激励广告点击 ${code.toJson()}");
        },
        onClose: (code) {
          onVerifyClose(code, adVerify);
          debugPrint("激励广告严重关闭 ${code.toJson()}");
        },
        onVerify: (code, verify, transId, rewardName, rewardAmount) {
          adVerify = verify;
          debugPrint("激励广告奖励验证 ${code.toJson()} $verify $transId $rewardName $rewardAmount");
        },
        onExpand: (code, param) {
          debugPrint("激励广告自定义参数 ${code.toJson()} $param");
        },
        onTimeout: () {
          debugPrint("激励广告加载超时");
        },
        onEnd: () {
          debugPrint("激励广告所有广告位都加载失败");
        },
      ),
    );
    if (b) {
      debugPrint("激励广告开始请求");
    } else {
      debugPrint("激励广告开始请求失败");
    }
  }
}

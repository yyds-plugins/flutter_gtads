import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_gtads/admob_ads/widgets/AppLifecycleReactor.dart';
import 'package:flutter_gtads/admob_ads/widgets/AppOpenAdManager.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../log_util.dart';

class AdmobAd {
  static initSDK() async {
    MobileAds.instance.initialize();
  }

  static showSplashAd() {
    AppOpenAdManager appOpenAdManager = AppOpenAdManager()..loadAd('');
    AppLifecycleReactor appLifecycleReactor = AppLifecycleReactor(appOpenAdManager: appOpenAdManager);
    appLifecycleReactor.listenToAppStateChanges();
  }

  static showInterstitialAd() {
    InterstitialAd.load(
        adUnitId: '',
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd interstitialAd) {
            LogUtil.dp('$interstitialAd loaded');
            interstitialAd.setImmersiveMode(true);
            interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
              onAdShowedFullScreenContent: (InterstitialAd ad) => LogUtil.dp('ad onAdShowedFullScreenContent.'),
              onAdDismissedFullScreenContent: (InterstitialAd ad) {
                LogUtil.dp('$ad onAdDismissedFullScreenContent.');
                ad.dispose();
              },
              onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
                LogUtil.dp('$ad onAdFailedToShowFullScreenContent: $error');
                ad.dispose();
              },
            );
            interstitialAd.show();
          },
          onAdFailedToLoad: (LoadAdError error) {
            LogUtil.dp('InterstitialAd failed to load: $error.');
          },
        ));
  }

  static showRewarded({void Function(bool)? onRewardVerify, void Function()? onAdClose}) {
    RewardedAd.load(
        adUnitId: '',
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd rewardedAd) {
            LogUtil.dp('$rewardedAd loaded.');

            rewardedAd.fullScreenContentCallback = FullScreenContentCallback(
              onAdShowedFullScreenContent: (RewardedAd ad) => LogUtil.dp('ad onAdShowedFullScreenContent.'),
              onAdDismissedFullScreenContent: (RewardedAd ad) {
                LogUtil.dp('$ad onAdDismissedFullScreenContent.');
                ad.dispose();
              },
              onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
                LogUtil.dp('$ad onAdFailedToShowFullScreenContent: $error');
                ad.dispose();
              },
            );

            rewardedAd.setImmersiveMode(true);
            rewardedAd.show(onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
              LogUtil.dp('$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
            });
          },
          onAdFailedToLoad: (LoadAdError error) {
            LogUtil.dp('RewardedAd failed to load: $error');
          },
        ));
  }

  void showRewardedInterstitialAd(String adUnitId) {
    RewardedInterstitialAd.load(
        adUnitId: '',
        request: const AdRequest(),
        rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
          onAdLoaded: (RewardedInterstitialAd ad) {
            LogUtil.dp('$ad loaded.');
            ad.fullScreenContentCallback = FullScreenContentCallback(
              onAdShowedFullScreenContent: (RewardedInterstitialAd ad) => LogUtil.dp('$ad onAdShowedFullScreenContent.'),
              onAdDismissedFullScreenContent: (RewardedInterstitialAd ad) {
                LogUtil.dp('$ad onAdDismissedFullScreenContent.');
                ad.dispose();
              },
              onAdFailedToShowFullScreenContent: (RewardedInterstitialAd ad, AdError error) {
                LogUtil.dp('$ad onAdFailedToShowFullScreenContent: $error');
                ad.dispose();
              },
            );

            ad.setImmersiveMode(true);
            ad.show(onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
              LogUtil.dp('$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
            });
          },
          onAdFailedToLoad: (LoadAdError error) {
            LogUtil.dp('RewardedInterstitialAd failed to load: $error');
          },
        ));
  }

  static Widget feedView() {
    NativeAd nativeAd = NativeAd(
        adUnitId: Platform.isAndroid ? 'ca-app-pub-4418360710854068/4725061102' : 'ca-app-pub-4418360710854068/1631993903',
        // adUnitId: Platform.isAndroid ? 'ca-app-pub-3940256099942544/1044960115' : 'ca-app-pub-3940256099942544/2521693316', 测试
        request: const AdRequest(),
        factoryId: '',
        listener: NativeAdListener(
          onAdLoaded: (Ad ad) {
            LogUtil.dp('$NativeAd loaded.');
          },
          onAdFailedToLoad: (Ad ad, LoadAdError error) {
            LogUtil.dp('$NativeAd failedToLoad: $error');
            ad.dispose();
          },
          onAdOpened: (Ad ad) => LogUtil.dp('$NativeAd onAdOpened.'),
          onAdClosed: (Ad ad) => LogUtil.dp('$NativeAd onAdClosed.'),
        ))
      ..load();

    return AdWidget(ad: nativeAd);
  }
}

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../utils/ad_helper.dart';

class AdsProvider extends ChangeNotifier {
  BannerAd? bannerAd;
  bool isBannerAdReady = false;
  InterstitialAd? interstitialAd;

  loadBannerAd() {
    bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.largeBanner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          // setState(() {
          isBannerAdReady = true;
          notifyListeners();
          // });
        },
        onAdFailedToLoad: (ad, err) {
          isBannerAdReady = false;
          print("onAdFailedToLoad:::: ${ad} err:: ${err}");
          ad.dispose();
          notifyListeners();
        },
      ),
    );
    bannerAd!.load();
  }

  void createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: AdHelper.interstitialAdUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            print('$ad loaded');
            interstitialAd = ad;
            interstitialAd!.setImmersiveMode(true);
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error.');
            interstitialAd = null;
            createInterstitialAd();
          },
        ));
  }

  void showInterstitialAd() {
    if (interstitialAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }
    interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        createInterstitialAd();
      },
    );
    interstitialAd!.show();
    interstitialAd = null;
  }
}
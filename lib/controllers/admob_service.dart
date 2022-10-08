import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMobService {

  //Real
  // static String get bannerAdUnitId => Platform.isAndroid
  //     ? 'ca-app-pub-9877340673993645/3844079616'
  //     : 'ca-app-pub-3940256099942544/6300978111';
  //
  // static String get settingBannerAdUnitId => Platform.isAndroid
  //     ? 'ca-app-pub-9877340673993645/2072080366'
  //     : 'ca-app-pub-3940256099942544/6300978111';
  //
  // static String get interstitialUnitId => Platform.isAndroid
  //     ? 'ca-app-pub-9877340673993645/5616094775'
  //     : 'ca-app-pub-3940256099942544/1033173712';


  //test
  static String get bannerAdUnitId => Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/6300978111'
      : 'ca-app-pub-3940256099942544/6300978111';

  static String get settingBannerAdUnitId => Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/6300978111'
      : 'ca-app-pub-3940256099942544/6300978111';

  static String get interstitialUnitId => Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/1033173712'
      : 'ca-app-pub-3940256099942544/1033173712';

  static String get interstitialNoteUnitId => Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/1033173712'
      : 'ca-app-pub-3940256099942544/1033173712';

  InterstitialAd? _interstitialAd;
  InterstitialAd? _interstitialAdNote;
  int numOfAttempts = 0;
  int numOfAttemptsNote = 0;

  static initialize() {
    if (MobileAds.instance == null) {
      MobileAds.instance.initialize();
    }
  }

  static BannerAd createBannerAd() {
    BannerAd ad = new BannerAd(
      size: AdSize.banner,
      adUnitId: bannerAdUnitId,
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) => print("Ad opened"),
        onAdFailedToLoad: (Ad ad, error) {
          ad.dispose();
        },
        onAdOpened: (Ad ad) => print('Ad Opened'),
        onAdClosed: (Ad ad) => print('On Ad Closed'),
      ),
      request: AdRequest(),
    );
    return ad;
  }

  static BannerAd createSettingBannerAd() {
    BannerAd ad = new BannerAd(
      size: AdSize.banner,
      adUnitId: settingBannerAdUnitId,
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) => print("Ad opened"),
        onAdFailedToLoad: (Ad ad, error) {
          ad.dispose();
        },
        onAdOpened: (Ad ad) => print('Ad Opened'),
        onAdClosed: (Ad ad) => print('On Ad Closed'),
      ),
      request: AdRequest(),
    );
    return ad;
  }

  // create interstitial ads
  void createInterstitial() {
    InterstitialAd.load(
      adUnitId: interstitialUnitId,
      request: AdRequest(),
      adLoadCallback:
          InterstitialAdLoadCallback(onAdLoaded: (InterstitialAd ad) {
        _interstitialAd = ad;
        numOfAttempts = 0;
      }, onAdFailedToLoad: (LoadAdError error) {
        numOfAttempts + 1;
        _interstitialAd = null;
        if (numOfAttempts <= 2) {
          createInterstitial();
        }
      }),
    );
  }

// show interstitial ads to user
  void showInterstitial() {
    if (_interstitialAd == null) {
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (InterstitialAd ad) {
      print("ad onAdshowedFullscreen");
    }, onAdDismissedFullScreenContent: (InterstitialAd ad) {
      print("ad Disposed");
      ad.dispose();
    }, onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError aderror) {
      print('$ad OnAdFailed $aderror');
      ad.dispose();
      createInterstitial();
    });
    _interstitialAd!.show();
    _interstitialAd = null;
  }

  // create interstitial ads
  void createInterstitialForNote() {
    InterstitialAd.load(
      adUnitId: interstitialNoteUnitId,
      request: AdRequest(),
      adLoadCallback:
          InterstitialAdLoadCallback(onAdLoaded: (InterstitialAd ad) {
        _interstitialAdNote = ad;
        numOfAttemptsNote = 0;
      }, onAdFailedToLoad: (LoadAdError error) {
        numOfAttemptsNote + 1;
        _interstitialAdNote = null;
        if (numOfAttemptsNote <= 2) {
          createInterstitialForNote();
        }
      }),
    );
  }

// show interstitial ads to user
  void showInterstitialFroNote() {
    print('Show Clicked');
    if (_interstitialAdNote == null) {
      return;
    }
    _interstitialAdNote!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (InterstitialAd ad) {
      print("ad onAdshowedFullscreen");
    }, onAdDismissedFullScreenContent: (InterstitialAd ad) {
      print("ad Disposed");
      ad.dispose();
    }, onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError aderror) {
      print('$ad OnAdFailed $aderror');
      ad.dispose();
      createInterstitialForNote();
    });
    _interstitialAdNote!.show();
    _interstitialAdNote = null;
  }
}

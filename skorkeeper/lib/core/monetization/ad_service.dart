import 'dart:io';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

abstract class _AdUnitIds {
  static String get banner => Platform.isAndroid
      ? 'ca-app-pub-2153308244657091/4552979321'
      : 'ca-app-pub-2153308244657091/6963520242';

  static String get interstitial => Platform.isAndroid
      ? 'ca-app-pub-2153308244657091/7886940865'
      : 'ca-app-pub-2153308244657091/3239897657';
}

class AdService {
  AdService._();

  static final AdService instance = AdService._();

  bool _initialized = false;

  bool get isSupportedPlatform =>
      !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  Future<void> initialize() async {
    if (_initialized || !isSupportedPlatform) {
      return;
    }
    // Request App Tracking Transparency on iOS 14+ before loading ads.
    // AdMob loads non-personalized ads if the user declines — no crash.
    if (Platform.isIOS) {
      final status =
          await AppTrackingTransparency.trackingAuthorizationStatus;
      if (status == TrackingStatus.notDetermined) {
        await AppTrackingTransparency.requestTrackingAuthorization();
      }
    }
    await MobileAds.instance.initialize();
    _initialized = true;
  }

  BannerAd createBannerAd({required BannerAdListener listener}) {
    return BannerAd(
      adUnitId: _AdUnitIds.banner,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: listener,
    );
  }

  Future<InterstitialAd?> loadInterstitial() async {
    if (!_initialized || !isSupportedPlatform) {
      return null;
    }
    InterstitialAd? ad;
    await InterstitialAd.load(
      adUnitId: _AdUnitIds.interstitial,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (loaded) => ad = loaded,
        onAdFailedToLoad: (error) {
          if (kDebugMode) {
            debugPrint('Interstitial failed: $error');
          }
        },
      ),
    );
    return ad;
  }
}

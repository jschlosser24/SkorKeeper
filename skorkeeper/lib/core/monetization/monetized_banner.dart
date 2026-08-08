import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../providers/pro_state_provider.dart';
import 'ad_service.dart';

class MonetizedBanner extends ConsumerStatefulWidget {
  const MonetizedBanner({super.key});

  @override
  ConsumerState<MonetizedBanner> createState() => _MonetizedBannerState();
}

class _MonetizedBannerState extends ConsumerState<MonetizedBanner> {
  BannerAd? _bannerAd;
  bool _loadStarted = false;

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPro = ref.watch(proStateNotifierProvider).valueOrNull ?? false;
    if (isPro || !AdService.instance.isSupportedPlatform) {
      _bannerAd?.dispose();
      _bannerAd = null;
      return const SizedBox.shrink();
    }
    if (!_loadStarted) {
      _loadStarted = true;
      _loadBanner();
    }
    final bannerAd = _bannerAd;
    if (bannerAd == null) {
      return const SizedBox.shrink();
    }
    return SafeArea(
      top: false,
      child: SizedBox(
        height: bannerAd.size.height.toDouble(),
        width: bannerAd.size.width.toDouble(),
        child: AdWidget(ad: bannerAd),
      ),
    );
  }

  void _loadBanner() {
    final banner = AdService.instance.createBannerAd(
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (!mounted) {
            ad.dispose();
            return;
          }
          setState(() => _bannerAd = ad as BannerAd);
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    );
    banner.load();
  }
}

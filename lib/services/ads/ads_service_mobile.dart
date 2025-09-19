import 'dart:io' show Platform;
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdsService {
  int adGraceRemainingMs = 40 * 60 * 1000;
  bool proEntitlement = false;
  DateTime? _sessionStart;

  InterstitialAd? _interstitial;
  bool _initialized = false;

  void _ensureInit() {
    if (_initialized) return;
    MobileAds.instance.initialize();
    _initialized = true;
  }

  void startSession() {
    _ensureInit();
    _sessionStart = DateTime.now();
    _preloadInterstitial();
  }

  void endSession() {
    if (_sessionStart != null) {
      final elapsed = DateTime.now().difference(_sessionStart!);
      adGraceRemainingMs = (adGraceRemainingMs - elapsed.inMilliseconds).clamp(0, adGraceRemainingMs);
      _sessionStart = null;
    }
  }

  bool get adGraceConsumed => adGraceRemainingMs <= 0;
  bool shouldShowAd() => adGraceConsumed && !proEntitlement;

  String get _testInterstitialUnitId {
    if (Platform.isAndroid) {
      // Android interstitial test unit
      return 'ca-app-pub-3940256099942544/1033173712';
    } else if (Platform.isIOS) {
      // iOS interstitial test unit
      return 'ca-app-pub-3940256099942544/4411468910';
    }
    // Fallback (shouldn't reach for web/desktop due to conditional import)
    return '';
  }

  void _preloadInterstitial() {
    if (_interstitial != null) return;
    InterstitialAd.load(
      adUnitId: _testInterstitialUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitial = ad;
        },
        onAdFailedToLoad: (error) {
          _interstitial = null;
        },
      ),
    );
  }

  Future<bool> showInterstitial() async {
    if (!shouldShowAd()) return false;
    if (_interstitial == null) {
      _preloadInterstitial();
      return false;
    }
    var shown = false;
    _interstitial!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        shown = true;
      },
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _interstitial = null;
        _preloadInterstitial();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _interstitial = null;
      },
    );
    await _interstitial!.show();
    return shown;
  }
}
/// A very simple stub of an advertising service. In a real
/// implementation this would wrap `google_mobile_ads` to preload
/// and show interstitials. Here we just expose variables to
/// simulate a post‑grace period and track whether ads are
/// permitted.
class AdsService {
  // Remaining milliseconds before ads become active. On first
  // install this is set to 40 minutes worth of milliseconds.
  int adGraceRemainingMs = 40 * 60 * 1000;

  // Whether the user has purchased the premium tier (no ads).
  bool proEntitlement = false;

  // Timestamp when the current session started. Used to update
  // adGraceRemainingMs when the app is in use.
  DateTime? _sessionStart;

  void startSession() {
    _sessionStart = DateTime.now();
  }

  void endSession() {
    if (_sessionStart != null) {
      final now = DateTime.now();
      final elapsed = now.difference(_sessionStart!);
      adGraceRemainingMs = (adGraceRemainingMs - elapsed.inMilliseconds).clamp(0, adGraceRemainingMs);
      _sessionStart = null;
    }
  }

  bool get adGraceConsumed => adGraceRemainingMs <= 0;

  /// Determines whether an interstitial ad should be shown at this
  /// moment. In this stub we allow it if the grace period is
  /// consumed and the user has not purchased premium.
  bool shouldShowAd() {
    return adGraceConsumed && !proEntitlement;
  }

  /// Pretend to show an interstitial. In the real app this would
  /// call `InterstitialAd.load` and `show`. Returns true if an
  /// ad was actually shown.
  Future<bool> showInterstitial() async {
    // For demonstration, always return false (no ad shown).
    // Replace with real implementation when integrating
    // google_mobile_ads.
    return false;
  }
}

// Create a singleton instance of AdsService for the app. In a real
// application you might use a provider or dependency injection.
final adsService = AdsService();
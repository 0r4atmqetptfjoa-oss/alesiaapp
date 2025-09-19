class AdsService {
  int adGraceRemainingMs = 40 * 60 * 1000;
  bool proEntitlement = false;
  DateTime? _sessionStart;

  void startSession() {
    _sessionStart = DateTime.now();
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
  Future<bool> showInterstitial() async => false; // no-op on web/desktop
}
class IapService {
  bool proEntitlement = false;

  /// Simulate a successful purchase in non-mobile environments.
  Future<bool> purchaseRemoveAds() async {
    proEntitlement = true;
    return true;
  }
}
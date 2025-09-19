import 'dart:async';
import 'package:in_app_purchase/in_app_purchase.dart';

class IapService {
  bool proEntitlement = false;
  static const String _productId = 'remove_ads';

  Future<bool> purchaseRemoveAds() async {
    final bool available = await InAppPurchase.instance.isAvailable();
    if (!available) return false;

    // Query product details
    final ProductDetailsResponse response =
        await InAppPurchase.instance.queryProductDetails({_productId});
    if (response.notFoundIDs.isNotEmpty || response.productDetails.isEmpty) {
      return false;
    }
    final product = response.productDetails.first;

    // Listen for purchases
    final completer = Completer<bool>();
    late final StreamSubscription subscription;
    subscription = InAppPurchase.instance.purchaseStream.listen((purchases) async {
      for (final purchase in purchases) {
        if (purchase.productID == _productId) {
          switch (purchase.status) {
            case PurchaseStatus.purchased:
            case PurchaseStatus.restored:
              proEntitlement = true;
              // In production, verify the purchase on server here.
              await InAppPurchase.instance.completePurchase(purchase);
              if (!completer.isCompleted) completer.complete(true);
              break;
            case PurchaseStatus.pending:
              // ignore
              break;
            case PurchaseStatus.error:
            case PurchaseStatus.canceled:
              if (!completer.isCompleted) completer.complete(false);
              break;
          }
        }
      }
    });

    // Start purchase flow
    final PurchaseParam param = PurchaseParam(productDetails: product);
    await InAppPurchase.instance.buyNonConsumable(purchaseParam: param);

    final result = await completer.future.timeout(const Duration(minutes: 2), onTimeout: () => false);
    await subscription.cancel();
    return result;
  }
}
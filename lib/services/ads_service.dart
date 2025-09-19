// Platform-aware AdsService. Uses a stub on web/desktop and the real
// google_mobile_ads implementation on Android/iOS.
import 'ads/ads_service_stub.dart'
  if (dart.library.io) 'ads/ads_service_mobile.dart';

export 'ads/ads_service_stub.dart' if (dart.library.io) 'ads/ads_service_mobile.dart';

final adsService = AdsService();
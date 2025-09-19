// Platform-aware IapService. Uses a stub on web/desktop and the real
// in_app_purchase implementation on Android/iOS.
import 'iap/iap_service_stub.dart'
  if (dart.library.io) 'iap/iap_service_mobile.dart';

export 'iap/iap_service_stub.dart' if (dart.library.io) 'iap/iap_service_mobile.dart';

final iapService = IapService();
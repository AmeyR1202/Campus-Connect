import 'dart:io';

import 'package:url_launcher/url_launcher.dart';

/// Centralized external app & URL launching utilities.
class AppLauncher {
  const AppLauncher._();

  /// Opens the device's default mail app (`message://` on iOS, `mailto:` on Android).
  ///
  /// Returns `true` if a mail client was launched, or `false` if unavailable
  /// (e.g., on simulators without a configured mail app).
  static Future<bool> openMailApp() async {
    final Uri mailUri = Platform.isIOS
        ? Uri(scheme: 'message')
        : Uri(scheme: 'mailto');

    try {
      return await launchUrl(mailUri, mode: LaunchMode.externalApplication);
    } catch (_) {
      return false;
    }
  }
}

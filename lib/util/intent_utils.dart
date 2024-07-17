import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';

class IntentUtils {
  IntentUtils._();

  static Future<void> launchGoogleMaps(double lat, double long) async {
    final uri = Uri(
        scheme: "google.navigation",
        // host: '"0,0"',  {here we can put host}
        queryParameters: {'q': '$lat, $long'});
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      debugPrint('An error occurred');
    }
  }
}

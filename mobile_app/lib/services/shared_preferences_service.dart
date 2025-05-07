import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static const String _privacyPolicyAcceptedKey = 'privacy_policy_accepted';

  static Future<bool> hasAcceptedPrivacyPolicy() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_privacyPolicyAcceptedKey) ?? false;
  }

  static Future<void> setPrivacyPolicyAccepted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_privacyPolicyAcceptedKey, true);
  }
}

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static const _kHasSeenWelcome = 'has_seen_welcome';

  Future<bool> get hasSeenWelcome async {
    final sp = await SharedPreferences.getInstance();
    return sp.getBool(_kHasSeenWelcome) ?? false;
  }

  Future<void> setHasSeenWelcome() async {
    final sp = await SharedPreferences.getInstance();
    await sp.setBool(_kHasSeenWelcome, true);
  }
}

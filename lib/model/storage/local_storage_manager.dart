
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageManager {

  static final Future<SharedPreferences> _storage = SharedPreferences
      .getInstance();

}

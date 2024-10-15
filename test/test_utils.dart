import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> setUpTestSharedPreferences() async {
  SharedPreferences.setMockInitialValues({});
  await SharedPreferences.getInstance();
}

Future<void> setUpTestEasyLocalization() async {
  await EasyLocalization.ensureInitialized();
}

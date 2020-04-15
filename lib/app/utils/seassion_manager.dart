import 'package:furnitureshopping/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static final String IS_LOGIN = "IsLoggedIn";
  static final String KEY_USER_NAME = "username";
  static final String KEY_NAME = "name";
  static final String KEY_EMAIL = "email";
  static final String KEY_PHONE = "phone";
  static final String KEY_PASSWORD = "password";
  static final String KEY_ADDRESS = "address";
  static final String KEY_ROLE = "role";

  Future<bool> isLoggedIn() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getBool(IS_LOGIN) ?? false;
  }

  void createLoginSession(User user) async {
    final pref = await SharedPreferences.getInstance();
    pref.setBool(IS_LOGIN, true);
    pref.setString(KEY_USER_NAME, user.userName);
    pref.setString(KEY_NAME, user.fullName);
    pref.setString(KEY_ADDRESS, user.address);
    pref.setString(KEY_EMAIL, user.email);
    pref.setString(KEY_PHONE, user.contactNumber);
    pref.setString(KEY_PASSWORD, user.userPassword);
    pref.setString(KEY_ROLE, user.role);
  }

  Future<User> getUserDetails() async {
    final pref = await SharedPreferences.getInstance();
    var username = pref.getString(KEY_USER_NAME) ?? null;
    var name = pref.getString(
          KEY_NAME,
        ) ??
        null;
    var address = pref.getString(KEY_ADDRESS) ?? null;
    var email = pref.getString(KEY_EMAIL) ?? null;
    var phone = pref.getString(KEY_PHONE) ?? null;
    var password = pref.getString(KEY_PASSWORD) ?? null;
    var role = pref.getString(KEY_ROLE) ?? null;
    User user = User(
        address: address,
        contactNumber: phone,
        email: email,
        fullName: name,
        role: role,
        userName: username,
        userPassword: password);
    return user;
  }

  void logoutUser() async {
    final pref = await SharedPreferences.getInstance();
    await pref.clear();
  }
}

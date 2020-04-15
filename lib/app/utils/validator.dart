import 'package:string_validator/string_validator.dart';

class Validator {
  static String validatePassword(String value) {
    return isNull(value) ? 'Password can\'t be empty' : null;
  }

  static String validateUsername(String value) {
    return isNull(value) ? 'Username can\'t be empty' : null;
  }

  static String validateEmail(String value) {
    if (isNull(value))
      return 'Email can\'t be empty';
    else if (!isEmail(value))
      return 'Invalid email';
    else
      return null;
  }

  static String validateName(String value) {
    Pattern pattern = r'^[A-Za-z0-9]+(?:[ _-][A-Za-z0-9]+)*$';
    RegExp regex = new RegExp(pattern);
    if (isNull(value))
      return 'Name Can\'t be empty';
    else if (!regex.hasMatch(value.trim()))
      return 'Invalid name';
    else
      return null;
  }

  static String validateAddress(String value) {
    Pattern pattern = r'^[A-Za-z0-9]+(?:[ _-][A-Za-z0-9]+)*$';
    RegExp regex = new RegExp(pattern);
    if (isNull(value))
      return 'Address Can\'t be empty';
    else if (!regex.hasMatch(value.trim()))
      return 'Invalid address';
    else
      return null;
  }

  static String validatePhoneNumber(String value) {
    if (isNull(value))
      return 'Number Can\'t be empty';
    else if ((value.trim().startsWith("017") ||
            value.trim().startsWith("018") ||
            value.trim().startsWith("016") ||
            value.trim().startsWith("015") ||
            value.trim().startsWith("019") ||
            value.trim().startsWith("013")) &&
        value.trim().length == 11)
      return null;
    else
      return "Invalid phone number.";
  }
}

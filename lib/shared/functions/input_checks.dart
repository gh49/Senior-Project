
class InputCheck {

  static bool isInteger(String? value) {
    if(value == null) {
      return false;
    }
    try {
      int.parse(value);
    }
    catch (error) {
      return false;
    }
    return true;
  }

  static bool isNumber(String? value) {
    if(value == null) {
      return false;
    }
    return double.tryParse(value) != null;
  }

  static bool isKfupmId(String? value) {
    if(value == null) {
      return false;
    }

    value = value.toLowerCase();
    value = value.trim();
    if(InputCheck.isInteger(value[0])) {
      value = 's$value';
    }
    else if(value[0] != 's') {
      return false;
    }
    if(value.length != 10 || !InputCheck.isInteger(value.substring(1))) {
      return false;
    }

    return true;
  }
}

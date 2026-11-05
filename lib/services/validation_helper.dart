class ValidationHelperClass {
  static String? validateName(String val) {
    String value = val.trim();
    if (value.isEmpty || value == '' || value.trim().length < 3) {
      return 'Please provide a valid name';
    }
    return null;
  }

  static String? validatePunnyamCode(String val) {
    String value = val.trim();
    if (value.isEmpty || value == '' || value.trim().length < 3) {
      return 'Please provide a valid code';
    }
    return null;
  }

  static String? validateMobileNumber(String val) {
    String value = val.trim();
    if (value.isEmpty || value == '' || value.trim().length < 10) {
      return 'Please provide a valid mobile number';
    }
    return null;
  }

  static String? validateEmail(String val) {
    String value = val.trim();
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    if (regex.hasMatch(value)) {
      return null;
    } else {
      return 'Please provide a valid email';
    }
  }

  static String? validatePassword(String val) {
    String value = val.trim();
    if (value.isEmpty || value == '' || value.length < 8) {
      return 'Password must contain 8 characters';
    } else {
      return null;
    }
  }

  static String? validateQty(String val) {
    String value = val.trim();
    if (value.isEmpty || value == '') {
      return 'invalid Qty';
    }
    return null;
  }

  static String? validateRate(String val) {
    String value = val.trim();
    if (value.isEmpty || value == '') {
      return 'Please provide a valid amount';
    }
    return null;
  }

  static String? validatePaidAmount(String val, int totalRate) {
    String value = val.trim();
    if (value.isEmpty || value == '' || int.parse(value) > totalRate) {
      return 'Please provide a valid amount';
    }
    return null;
  }

  static String? validatePinCode(String val) {
    String value = val.trim();
    if (value.length < 6 || value.isEmpty || value == '') {
      return 'Please provide a valid pin code';
    }
    return null;
  }
}

enum ValidationTypes {
  name,
  email,
  punnyamCode,
  password,
  confirmPassword,
  userName,
  qty,
  rate,
  totalRate,
  paidAmount,
  mobileNumber
}

enum CreateCustomerValidationTypes {
  name,
  email,
  mobileNumber,
  houseName,
  street,
  post,
  pinCode
}

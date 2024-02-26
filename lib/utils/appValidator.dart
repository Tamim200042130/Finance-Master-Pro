class AppValidator {
  String? validateEmail(String? value) {
    if (value!.isEmpty) {
      return 'Please enter your email';
    }
    RegExp emailRegExp = RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
    if (!emailRegExp.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? validatePhoneNumber(String? value) {
    if (value!.isEmpty) {
      return 'Please enter your phone number';
    }
    if (value.length != 11) {
      return 'Phone number must be 11 digits long';
    }
    RegExp phoneRegExp = RegExp(r'^01\d{9}$');
    if (!phoneRegExp.hasMatch(value)) {
      return 'Phone number must start with 01 and be followed by 9 digits';
    }
    return null;
  }

  String? validateUsername(String? value) {
    if (value!.trim().isEmpty) {
      return 'Please enter your username';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value!.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  String? validateTitle(String? value) {
    if (value!.trim().isEmpty) {
      return 'Please enter a title';
    }
    return null;
  }

  String? validateAmount(String? value) {
    if (value!.trim().isEmpty) {
      return 'Please enter an amount';
    }
    return null;
  }
}

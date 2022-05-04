class Validators {
  static final RegExp _emailRegExp = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$ñ%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9.ñ-]+\.[a-zA-Z]+",
  );

  static final RegExp _passwordRegExp = RegExp(
    r"^(?=.*[A-Za-z0-9.ñ])(?=.*\d)[A-Za-zñ\d]{6,}$",
  );

  static isValidEmail(String email){
    return _emailRegExp.hasMatch(email);
  }

  static isValidPassword(String password){
    return _passwordRegExp.hasMatch(password);
  }
}
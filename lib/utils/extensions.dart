extension ExtString on String {
  bool get isValidName {
    final nameRegExp = RegExp(r"\b([A-ZÀ-ÿ][-,a-z. ']+[ ]*)+"
    );
    return nameRegExp.hasMatch(this);
  }

  bool get isValidEmail {
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$'
    );
    return emailRegExp.hasMatch(this);
  }

  bool get isValidPhone {
    final phoneRegExp = RegExp(r"^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$"
    );
    return phoneRegExp.hasMatch(this);
  }

  bool get isValidPassword {
    final passwordRegExp = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$'
    );
    return passwordRegExp.hasMatch(this);
  }
}
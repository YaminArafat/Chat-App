class AUser {
  late String? _img;
  late String? _firstName;
  late String? _lastName;
  late String? _email;
  late String? _mobile;
  late String? _password;
  late String? _confirmPassword;

  AUser(
      {required String img,
      required String firstName,
      required String lastName,
      required String email,
      required String mobile,
      required String password,
      required String confirmPassword}) {
    _img = img;
    _firstName = firstName;
    _lastName = lastName;
    _email = email;
    _mobile = mobile;
    _password = password;
    _confirmPassword = confirmPassword;
  }
}

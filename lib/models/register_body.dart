class RegisterBody {
  String? name;
  String? email;
  String? punnyamCode;
  String? password;
  String? confirmPassword;
  RegisterBody(
      {this.name,
      this.email,
      this.password,
      this.confirmPassword,
      this.punnyamCode});
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['email'] = email;
    data['punnyam_code'] = punnyamCode;
    data['password'] = password;
    data['confirm_password'] = confirmPassword;
    return data;
  }
}

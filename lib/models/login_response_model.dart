class LoginResponseModel {
  bool? status;
  String? message;
  String? token;
  LoginResponseModel({this.status, this.message, this.token});
  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    token = json['token'];
  }
}

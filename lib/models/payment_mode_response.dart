class PaymentModeResponse {
  bool? status;
  List<PaymentModeDataList>? data;
  PaymentModeResponse({this.status, this.data});
  PaymentModeResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <PaymentModeDataList>[];
      json['data'].forEach((v) {
        data!.add(PaymentModeDataList.fromJson(v));
      });
    }
  }
}

class PaymentModeDataList {
  int? id;
  String? name;
  PaymentModeDataList({this.id, this.name});
  PaymentModeDataList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }
}

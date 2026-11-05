import 'package:kiosk/models/save_bill_body.dart';

class PreviewBillResponse {
  bool? status;
  PreviewBillData? data;
  String? message;
  PreviewBillResponse({this.status, this.data, this.message});
  PreviewBillResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? PreviewBillData.fromJson(json['data']) : null;
    message = json['message'];
  }
}

class PreviewBillData {
  int? customerId;
  String? customerName;
  String? counterId;
  int? isscheduled;
  String? counterName;
  String? billimage;
  List<PoojaDetails>? poojaDetails;
  PreviewBillData({
    this.customerId,
    this.billimage,
    this.customerName,
    this.isscheduled,
    this.counterId,
    this.counterName,
    this.poojaDetails,
  });
  PreviewBillData.fromJson(Map<String, dynamic> json) {
    customerId = json['customer_id'];
    customerName = json['customer_name'];
    isscheduled = json['is_scheduled'];
    counterId = json['counter_id'];
    billimage = json['bill_image'];
    counterName = json['counter_name'];
    if (json['pooja_details'] != null) {
      poojaDetails = <PoojaDetails>[];
      json['pooja_details'].forEach((v) {
        poojaDetails!.add(PoojaDetails.fromJson(v));
      });
    }
  }
}

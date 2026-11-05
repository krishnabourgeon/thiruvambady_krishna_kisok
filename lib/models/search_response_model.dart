class SearchResponse {
  bool? status;
  List<SearchResponseData>? data;
  SearchResponse({this.status, this.data});
  SearchResponse.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    data = json["data"] == null
        ? null
        : (json["data"] as List)
            .map((e) => SearchResponseData.fromJson(e))
            .toList();
  }
}

class SearchResponseData {
  int? id;
  String? customerId;
  String? name;
  String? house;
  String? mobile;
  SearchResponseData({this.id, this.customerId, this.name, this.mobile});
  SearchResponseData.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    customerId = json["customer_id"];
    name = json["name"];
    mobile = json['mobile'];
  }
}

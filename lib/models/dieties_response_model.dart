class DeitiesResponse {
  bool? status;
  List<DeitiesData>? data;
  DeitiesResponse({this.status, this.data});
  DeitiesResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <DeitiesData>[];
      json['data'].forEach((v) {
        data!.add(DeitiesData.fromJson(v));
      });
    }
  }
}

class DeitiesData {
  int? id;
  String? name;
  String? nameMal;
  DeitiesData({this.id, this.name, this.nameMal});
  DeitiesData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    nameMal = json['name_mal'];
  }
}

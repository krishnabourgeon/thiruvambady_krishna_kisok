class StarsResponse {
  bool? status;
  List<StartsData>? data;
  StarsResponse({this.status, this.data});
  StarsResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <StartsData>[];
      json['data'].forEach((v) {
        data!.add(StartsData.fromJson(v));
      });
    }
  }
}

class StartsData {
  int? id;
  String? nameEng;
  String? nameMal;
  StartsData({this.id, this.nameEng, this.nameMal});
  StartsData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nameEng = json['name_eng'];
    nameMal = json['name_mal'];
  }
}

class PoojaResponse {
  bool? status;
  List<PoojaData>? data;
  PoojaResponse({this.data, this.status});
  PoojaResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <PoojaData>[];
      json['data'].forEach((v) {
        data!.add(PoojaData.fromJson(v));
      });
    }
  }
}

class PoojaData {
  int? deityPoojaId;
  int? poojaId;
  String? name;
  String? nameMal;
  String? rate;
  int? rowcount;
  PoojaData(
      {this.deityPoojaId, this.poojaId, this.name, this.nameMal, this.rate});
  PoojaData.fromJson(Map<String, dynamic> json) {
    deityPoojaId = json['deity_pooja_id'];
    poojaId = json['pooja_id'];
    name = json['name'];
    nameMal = json['name_mal'];
    rate = json['rate'];
    rowcount = json['row_count'];
  }
}

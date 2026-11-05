class SaveBillResponse {
  bool? status;
  Temple? temple;
  Summary? summary;
  List<Details>? details;
  String? message;
  String? billimage;
  SaveBillResponse(
      {this.status, this.temple, this.summary, this.details, this.message});
  SaveBillResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    temple = json['temple'] != null ? Temple.fromJson(json['temple']) : null;
    summary =
        json['summary'] != null ? Summary.fromJson(json['summary']) : null;
    if (json['details'] != null) {
      details = <Details>[];
      json['details'].forEach((v) {
        details!.add(Details.fromJson(v));
      });
    }
    message = json['message'];
    billimage = json['bill_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (temple != null) {
      data['temple'] = temple!.toJson();
    }
    if (summary != null) {
      data['summary'] = summary!.toJson();
    }
    if (details != null) {
      data['details'] = details!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    data['bill_image'] = billimage;
    return data;
  }
}

class Temple {
  String? name;
  String? nameMal;
  String? addressLine1;
  String? addressLine2;
  String? phone;
  String? email;
  String? website;
  Temple(
      {this.name,
      this.nameMal,
      this.addressLine1,
      this.addressLine2,
      this.phone,
      this.email,
      this.website});
  Temple.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    nameMal = json['name_mal'];
    addressLine1 = json['address_line_1'];
    addressLine2 = json['address_line_2'];
    phone = json['phone'];
    email = json['email'];
    website = json['website'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['name_mal'] = nameMal;
    data['address_line_1'] = addressLine1;
    data['address_line_2'] = addressLine2;
    data['phone'] = phone;
    data['email'] = email;
    data['website'] = website;
    return data;
  }
}

class Summary {
  int? id;
  String? billDate;
  String? mode;
  String? counter;
  String? devotee;
  String? total;
  String? paidAMount;
  Summary(
      {this.id,
      this.billDate,
      this.mode,
      this.counter,
      this.devotee,
      this.total,
      this.paidAMount});
  Summary.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    billDate = json['bill_date'];
    mode = json['mode'];
    counter = json['counter'];
    devotee = json['devotee'];
    total = json['total'];
    paidAMount = json['recv_amt'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['bill_date'] = billDate;
    data['mode'] = mode;
    data['counter'] = counter;
    data['devotee'] = devotee;
    data['total'] = total;
    data['recv_amt'] = paidAMount;
    return data;
  }
}

class Details {
  String? name;
  String? address;
  String? star;
  String? starMal;
  String? deity;
  String? deityMal;
  String? pooja;
  String? poojaMal;
  String? qty;
  String? rate;
  String? time;
  String? date;
  String? amount;
  Details(
      {this.name,
      this.address,
      this.star,
      this.starMal,
      this.deity,
      this.deityMal,
      this.pooja,
      this.poojaMal,
      this.qty,
      this.rate,
      this.time,
      this.date,
      this.amount});
  Details.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    address = json['address'];
    star = json['star'];
    starMal = json['star_mal'];
    deity = json['deity'];
    deityMal = json['deity_mal'];
    pooja = json['pooja'];
    poojaMal = json['pooja_mal'];
    qty = json['qty'];
    rate = json['rate'];
    time = json['time'];
    date = json['date'];
    amount = json['amount'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['address'] = address;
    data['star'] = star;
    data['star_mal'] = starMal;
    data['deity'] = deity;
    data['deity_mal'] = deityMal;
    data['pooja'] = pooja;
    data['pooja_mal'] = poojaMal;
    data['qty'] = qty;
    data['rate'] = rate;
    data['time'] = time;
    data['date'] = date;
    data['amount'] = amount;
    return data;
  }
}

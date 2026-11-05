class SaveBillBody {
  int? customerId;
  int? counterId;
  int? paymentMode;
  double? billAmount;
  double? paidAmount;
  String? transactionid;
  List<PoojaDetails>? poojaDetails;
  SaveBillBody({
    this.customerId,
    this.transactionid,
    this.counterId,
    this.paymentMode,
    this.billAmount,
    this.paidAmount,
    this.poojaDetails,
  });
  SaveBillBody.fromJson(Map<String, dynamic> json) {
    customerId = json['customer_id'];
    counterId = json['counter_id'];
    paymentMode = json['payment_mode'];
    billAmount = json['bill_amount'];
    paidAmount = json['paid_amount'];
    transactionid = json['transaction_id'];
    if (json['pooja_details'] != null) {
      poojaDetails = <PoojaDetails>[];
      json['pooja_details'].forEach((v) {
        poojaDetails!.add(PoojaDetails.fromJson(v));
      });
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['customer_id'] = customerId;
    data['counter_id'] = counterId;
    data['payment_mode'] = paymentMode;
    data['bill_amount'] = billAmount;
    data['paid_amount'] = paidAmount;
    data['transaction_id'] = transactionid;
    if (poojaDetails != null) {
      data['pooja_details'] = poojaDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PoojaDetails {
  String? name = 'Customer';
  String? address;
  int? starId;
  int? deityId;
  String? diety;
  int? poojaId;
  String? pooja;
  int? qty;
  var rate;
  String? date;
  int? isScheduled;
  String? dwmo;
  String? fromDate;
  int? noOfDays;
  String? weekDays;
  int? noOfWeeks;
  int? noOfMonths;
  String? monthStar;
  int? specialStarId;
  int? prasadamStatus;
  int? postalAmount;
  String? star;
  PoojaDetails({
    this.name,
    this.address,
    this.starId,
    this.deityId,
    this.poojaId,
    this.qty,
    this.rate,
    this.date,
    this.diety,
    this.isScheduled,
    this.dwmo,
    this.fromDate,
    this.noOfDays,
    this.weekDays,
    this.noOfWeeks,
    this.noOfMonths,
    this.monthStar,
    this.specialStarId,
    this.prasadamStatus,
    this.postalAmount,
    this.pooja,
    this.star,
  });
  PoojaDetails.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    address = json['address'];
    starId = json['star_id'];
    deityId = json['deity_id'];
    poojaId = json['pooja_id'];
    diety = json['deity'];
    qty = json['qty'];
    rate = json['rate'];
    date = json['date'];
    isScheduled = json['is_scheduled'];
    dwmo = json['dwmo'];
    fromDate = json['from_date'];
    noOfDays = json['no_of_days'];
    weekDays = json['week_days'];
    noOfWeeks = json['no_of_weeks'];
    noOfMonths = json['no_of_months'];
    monthStar = json['month_star'];
    specialStarId = json['special_star_id'];
    prasadamStatus = json['prasadam_status'];
    postalAmount = json['postal_amount'];
    star = json['star'];
    pooja = json['pooja'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['address'] = address;
    data['star_id'] = starId;
    data['deity_id'] = deityId;
    data['pooja_id'] = poojaId;
    data['qty'] = qty;
    data['rate'] = rate;
    data['date'] = date;
    data['is_scheduled'] = isScheduled;
    data['dwmo'] = dwmo;
    data['from_date'] = fromDate;
    data['no_of_days'] = noOfDays;
    data['week_days'] = weekDays;
    data['no_of_weeks'] = noOfWeeks;
    data['no_of_months'] = noOfMonths;
    data['month_star'] = monthStar;
    data['special_star_id'] = specialStarId;
    data['prasadam_status'] = prasadamStatus;
    data['postal_amount'] = postalAmount;
    return data;
  }
}

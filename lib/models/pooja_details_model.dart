// // To parse this JSON data, do
// //
// //     final poojaDetailsModel = poojaDetailsModelFromJson(jsonString);

// import 'dart:convert';

// PoojaDetailsModel poojaDetailsModelFromJson(String str) => PoojaDetailsModel.fromJson(json.decode(str));

// String poojaDetailsModelToJson(PoojaDetailsModel data) => json.encode(data.toJson());

// class PoojaDetailsModel {
//     bool status;
//     Data data;

//     PoojaDetailsModel({
//         required this.status,
//         required this.data,
//     });

//     factory PoojaDetailsModel.fromJson(Map<String, dynamic> json) => PoojaDetailsModel(
//         status: json["status"],
//         data: Data.fromJson(json["data"]),
//     );

//     Map<String, dynamic> toJson() => {
//         "status": status,
//         "data": data.toJson(),
//     };
// }

// class Data {
//     int id;
//     dynamic parentId;
//     int ledId;
//     String name;
//     String nameMal;
//     int rate;
//     int status;
//     int allowedQty;
//     int code;
//     int poojaCat;
//     int counter;
//     int isimp;
//     dynamic postelCharge;
//     dynamic courierCharge;
//     int rowcount;
//     String time;
//     int cat;
//     int online;
//     int block;
//     int counterBilling;
//     int specialPooja;
//     int noShowReport;
//     int dpcat;
//     int isKooru;
//     DateTime createdDate;
//     int forkiosk;

//     Data({
//         required this.id,
//         required this.parentId,
//         required this.ledId,
//         required this.name,
//         required this.nameMal,
//         required this.rate,
//         required this.status,
//         required this.allowedQty,
//         required this.code,
//         required this.poojaCat,
//         required this.counter,
//         required this.isimp,
//         required this.postelCharge,
//         required this.courierCharge,
//         required this.rowcount,
//         required this.time,
//         required this.cat,
//         required this.online,
//         required this.block,
//         required this.counterBilling,
//         required this.specialPooja,
//         required this.noShowReport,
//         required this.dpcat,
//         required this.isKooru,
//         required this.createdDate,
//         required this.forkiosk,
//     });

//     factory Data.fromJson(Map<String, dynamic> json) => Data(
//         id: json["id"] ?? 0,
//         parentId: json["parent_id"],
//         ledId: json["led_id"] ?? 0,
//         name: json["name"],
//         nameMal: json["name_mal"],
//         rate: json["rate"] ?? 0,
//         status: json["status"] ?? 0,
//         allowedQty: json["allowed_qty"] ?? 0,
//         code: json["code"] ?? 0,
//         poojaCat: json["pooja_cat"] ?? 0,
//         counter: json["counter"] ?? 0,
//         isimp: json["isimp"] ?? 0,
//         postelCharge: json["postel_charge"],
//         courierCharge: json["courier_charge"],
//         rowcount: json["rowcount"] ?? 0,
//         time: json["time"],
//         cat: json["cat"] ?? 0,
//         online: json["online"] ?? 0,
//         block: json["block"] ?? 0,
//         counterBilling: json["counter_billing"] ?? 0,
//         specialPooja: json["special_pooja"] ?? 0,
//         noShowReport: json["no_show_report"] ?? 0,
//         dpcat: json["dpcat"] ?? 0,
//         isKooru: json["is_kooru"] ?? 0,
//         createdDate: json["created_date"] != null
//             ? DateTime.parse(json["created_date"])
//             : DateTime.fromMillisecondsSinceEpoch(0),
//         forkiosk: json["forkiosk"] ?? 0,
//     );

//     Map<String, dynamic> toJson() => {
//         "id": id,
//         "parent_id": parentId,
//         "led_id": ledId,
//         "name": name,
//         "name_mal": nameMal,
//         "rate": rate,
//         "status": status,
//         "allowed_qty": allowedQty,
//         "code": code,
//         "pooja_cat": poojaCat,
//         "counter": counter,
//         "isimp": isimp,
//         "postel_charge": postelCharge,
//         "courier_charge": courierCharge,
//         "rowcount": rowcount,
//         "time": time,
//         "cat": cat,
//         "online": online,
//         "block": block,
//         "counter_billing": counterBilling,
//         "special_pooja": specialPooja,
//         "no_show_report": noShowReport,
//         "dpcat": dpcat,
//         "is_kooru": isKooru,
//         "created_date": "${createdDate.year.toString().padLeft(4, '0')}-${createdDate.month.toString().padLeft(2, '0')}-${createdDate.day.toString().padLeft(2, '0')}",
//         "forkiosk": forkiosk,
//     };
// }





// To parse this JSON data, do
//
//     final poojaDetailsModel = poojaDetailsModelFromJson(jsonString);

import 'dart:convert';

PoojaDetailsModel poojaDetailsModelFromJson(String str) => PoojaDetailsModel.fromJson(json.decode(str));

String poojaDetailsModelToJson(PoojaDetailsModel data) => json.encode(data.toJson());

class PoojaDetailsModel {
    bool status;
    Data data;

    PoojaDetailsModel({
        required this.status,
        required this.data,
    });

    factory PoojaDetailsModel.fromJson(Map<String, dynamic> json) => PoojaDetailsModel(
        status: json["status"] == true,
        // data can be missing/null (e.g. unknown pooja id) - parse as empty.
        data: Data.fromJson(json["data"] is Map<String, dynamic> ? json["data"] : const {}),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
    };
}

class Data {
    int id;
    dynamic parentId;
    int ledId;
    String? name;
    String? nameMal;
    num rate; // may come as int, double or "120.00"
    int status;
    int allowedQty;
    int code;
    int poojaCat;
    int counter;
    int isimp;
    dynamic postelCharge;
    dynamic courierCharge;
    int rowcount;
    String? time;
    int cat;
    int online;
    int block;
    int counterBilling;
    int specialPooja;
    int noShowReport;
    int dpcat;
    int isKooru;
    DateTime? createdDate;
    int forkiosk;

    Data({
        required this.id,
        required this.parentId,
        required this.ledId,
        required this.name,
        required this.nameMal,
        required this.rate,
        required this.status,
        required this.allowedQty,
        required this.code,
        required this.poojaCat,
        required this.counter,
        required this.isimp,
        required this.postelCharge,
        required this.courierCharge,
        required this.rowcount,
        required this.time,
        required this.cat,
        required this.online,
        required this.block,
        required this.counterBilling,
        required this.specialPooja,
        required this.noShowReport,
        required this.dpcat,
        required this.isKooru,
        required this.createdDate,
        required this.forkiosk,
    });

    // Any field can come back null (or as a string) from the API, so numbers
    // default to 0 instead of throwing "type 'Null' is not a subtype of 'int'".
    static num _num(dynamic v) =>
        v is num ? v : num.tryParse(v?.toString() ?? '') ?? 0;
    static int _int(dynamic v) => _num(v).toInt();

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: _int(json["id"]),
        parentId: json["parent_id"],
        ledId: _int(json["led_id"]),
        name: json["name"]?.toString(),
        nameMal: json["name_mal"]?.toString(),
        rate: _num(json["rate"]),
        status: _int(json["status"]),
        allowedQty: _int(json["allowed_qty"]),
        code: _int(json["code"]),
        poojaCat: _int(json["pooja_cat"]),
        counter: _int(json["counter"]),
        isimp: _int(json["isimp"]),
        postelCharge: json["postel_charge"],
        courierCharge: json["courier_charge"],
        rowcount: _int(json["rowcount"]),
        time: json["time"]?.toString(),
        cat: _int(json["cat"]),
        online: _int(json["online"]),
        block: _int(json["block"]),
        counterBilling: _int(json["counter_billing"]),
        specialPooja: _int(json["special_pooja"]),
        noShowReport: _int(json["no_show_report"]),
        dpcat: _int(json["dpcat"]),
        isKooru: _int(json["is_kooru"]),
        createdDate: DateTime.tryParse(json["created_date"]?.toString() ?? ''),
        forkiosk: _int(json["forkiosk"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "parent_id": parentId,
        "led_id": ledId,
        "name": name,
        "name_mal": nameMal,
        "rate": rate,
        "status": status,
        "allowed_qty": allowedQty,
        "code": code,
        "pooja_cat": poojaCat,
        "counter": counter,
        "isimp": isimp,
        "postel_charge": postelCharge,
        "courier_charge": courierCharge,
        "rowcount": rowcount,
        "time": time,
        "cat": cat,
        "online": online,
        "block": block,
        "counter_billing": counterBilling,
        "special_pooja": specialPooja,
        "no_show_report": noShowReport,
        "dpcat": dpcat,
        "is_kooru": isKooru,
        "created_date": createdDate == null
            ? null
            : "${createdDate!.year.toString().padLeft(4, '0')}-${createdDate!.month.toString().padLeft(2, '0')}-${createdDate!.day.toString().padLeft(2, '0')}",
        "forkiosk": forkiosk,
    };
}

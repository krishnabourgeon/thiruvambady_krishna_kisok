import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_thermal_printer/flutter_thermal_printer.dart';
// import 'package:flutter_thermal_printer/utils/printer.dart';
// import 'package:http/http.dart' as http;
import 'package:intl/intl.dart' show DateFormat;
import 'package:kiosk/color_pallatte.dart';
import 'package:kiosk/extension.dart';
import 'package:kiosk/fontpallate.dart';
import 'package:kiosk/models/save_bill_body.dart';
import 'package:kiosk/print_service.dart';
import 'package:kiosk/provider/homeprovider.dart';
import 'package:kiosk/services/helpers.dart';
import 'package:kiosk/services/provider_helper_class.dart';
// import 'package:kiosk/view/encrypt.dart';
import 'package:kiosk/view/homepage.dart';
import 'package:provider/provider.dart';

// import 'package:razorpay_flutter/razorpay_flutter.dart';

class PreviewScreen extends StatefulWidget {
  const PreviewScreen({super.key, this.lanid});
  final int? lanid;
  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  //  bool kSkipPaymentAndPrint = true; // set false for production
  final ValueNotifier<bool> isEnabled = ValueNotifier<bool>(false);
  // final _flutterThermalPrinterPlugin = FlutterThermalPrinter.instance;

  // List<Printer> printers = [];
  // Printer? connectedPrinter;
  // StreamSubscription<List<Printer>>? _devicesStreamSubscription;

  // QR flow: prints automatically 10 seconds after the QR code is shown.
  Timer? _qrPrintTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // _startScanAndAutoConnect();
    });
  }

  @override
  void dispose() {
    // Stop the auto-print timer so it can't fire after the screen is closed.
    _qrPrintTimer?.cancel();
    super.dispose();
  }

  /// Shows the payment QR code, then saves the bill and prints after 10 seconds.
  void _showQrAndAutoPrint(HomeProvider home) {
    if (isEnabled.value || (_qrPrintTimer?.isActive ?? false)) return;
    isEnabled.value = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (dialogContext) => PopScope(
            canPop: false,
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Scan to pay",
                    textAlign: TextAlign.center,
                    style: Fontpalette.blackinter50400,
                  ),
                  20.verticalSpace,
                  Image.asset(
                    "assets/images/qrcode.png",
                    width: 600.w,
                    fit: BoxFit.contain,
                  ),
                  20.verticalSpace,
                  Text(
                    "₹ ${home.grossamount?.toStringAsFixed(0)}",
                    style: Fontpalette.black60700,
                  ),
                ],
              ),
            ),
          ),
    );

    _qrPrintTimer = Timer(const Duration(seconds: 10), () async {
      if (!mounted) return;
      Navigator.of(context, rootNavigator: true).pop(); // close QR dialog
      await _saveBillAndPrint(home);
    });
  }

  /// Saves the bill and prints the receipt (same logic as the old payment
  /// success path). paymentMode 6 = UPI, as used by the old UPI flow.
  /// Pooja dates are stored as yyyy-MM-dd; the receipt prints dd-MM-yyyy.
  String? _formatPoojaDate(String? raw) {
    if (raw == null || raw.isEmpty) return raw;
    final parsed = DateTime.tryParse(raw);
    return parsed == null ? raw : DateFormat('dd-MM-yyyy').format(parsed);
  }

  Future<void> _saveBillAndPrint(HomeProvider home) async {
    bool connected = await PrinterService.connect();
    await home.saveBill(
      transid: "test",
      paymentMode: 6,
      onSuccess: () async {
        Helpers.successToast(home.saveBillResponse?.message ?? 'Bill Saved');
        if (connected) {
          DateTime parsedDate = DateTime.parse(
            home.saveBillResponse?.summary?.billDate ?? '',
          );
          String formatted = DateFormat(
            'dd-MM-yyyy HH:mm:ss',
          ).format(parsedDate);
          final templeData = home.saveBillResponse?.temple;
          // Malayalam selected (lanid != 1) and a translated name is
          // available — otherwise fall back to the English name.
          final templeName =
              widget.lanid != 1 && (templeData?.nameMal?.isNotEmpty ?? false)
                  ? templeData!.nameMal
                  : templeData?.name;
          await PrinterService.printReceipt(
            temple: templeName,
            templeAddress: templeData?.addressLine1 ?? '',
            templePlace: templeData?.addressLine2 ?? '',
            today: formatted,
            id: home.saveBillResponse?.summary?.id,
            mode: home.saveBillResponse?.summary?.mode.toString(),
            total: home.saveBillResponse?.summary?.total.toString(),
            website: templeData?.website ?? '',
            billImage: home.saveBillResponse?.billimage,
            items:
                home.pooja
                    .asMap()
                    .entries
                    .map(
                      (entry) => {
                        "personId": entry.key + 1,
                        "personName": entry.value.name,
                        "deity": entry.value.diety,
                        "star": entry.value.star,
                        "pooja": entry.value.pooja,
                        "qty": entry.value.qty,
                        "rate": entry.value.rate,
                        "date": _formatPoojaDate(entry.value.date),
                        "address": entry.value.address,
                      },
                    )
                    .toList(),
          );
        } else {
          Helpers.successToast(
            "Failed to connect to printer. Bill saved but printing failed.",
          );
        }
        isEnabled.value = false;
        if (!mounted) return;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MyHomePage()),
          (route) => false,
        );
      },
      onFailure: () async {
        isEnabled.value = false;
      },
    );
  }

  // Future<String?> selectPaymentMode(BuildContext context) async {
  // return showDialog<String>(
  // context: context,
  // barrierDismissible: false,
  // builder: (context) {
  // return AlertDialog(
  // title: Text("Select Payment Mode", style: TextStyle(fontSize: 60.sp)),
  // content: Column(
  // mainAxisSize: MainAxisSize.min,
  // children: [
  // OutlinedButton(
  // style: OutlinedButton.styleFrom(
  // foregroundColor: const Color(0xFFE65C00),
  // side: const BorderSide(color: Color(0xFFE65C00), width: 1.5),
  // minimumSize: const Size(double.infinity, 55),
  // shape: RoundedRectangleBorder(
  // borderRadius: BorderRadius.circular(8),
  // ),
  // ),
  // onPressed: () => Navigator.pop(context, "CARD"),
  // child: Text("Card", style: TextStyle(fontSize: 56.sp)),
  // ),
  // 20.verticalSpace,

  // OutlinedButton(
  // style: OutlinedButton.styleFrom(
  // foregroundColor: const Color(0xFFE65C00),
  // side: const BorderSide(color: Color(0xFFE65C00), width: 1.5),
  // minimumSize: const Size(double.infinity, 55),
  // shape: RoundedRectangleBorder(
  // borderRadius: BorderRadius.circular(8),
  // ),
  // ),
  // onPressed: () => Navigator.pop(context, "UPI"),
  // child: Text("UPI", style: TextStyle(fontSize: 56.sp)),
  // ),
  // 30.verticalSpace,
  // TextButton(
  // style: TextButton.styleFrom(
  // foregroundColor: Colors.grey,
  // minimumSize: const Size(double.infinity, 55),
  // side: const BorderSide(color: Colors.grey, width: 1.5),
  // shape: RoundedRectangleBorder(
  // borderRadius: BorderRadius.circular(8),
  // ),
  // ),
  // onPressed: () {
  // isEnabled.value = false;
  // Navigator.pop(context, null);
  // },
  // child: Text("Cancel", style: TextStyle(fontSize: 58.sp)),
  // ),
  // ],
  // ),
  // );
  // },
  // );
  // }

  // Future<String> checkStatus(String urn, String tid) async {
  //   final body = {"urn": urn, "tid": tid};
  //   print("Original Request: $body");
  //   final encryptedData = WorldlineEncryption.encryptRequest(body);

  //   final response = await http.post(
  //     Uri.parse('https://bouat.mrlpay.com/pcpos4/StatusCheck.php?source=629'),
  //     headers: {'Content-Type': 'application/json'},
  //     body: encryptedData,
  //   );
  //   final jsonResponse = jsonDecode(response.body);
  //   final encrypted = jsonResponse['data'];
  //   final decrypt = WorldlineEncryption.decryptResponse(encrypted);

  //   final data = jsonDecode(decrypt);
  //   return data['status'];
  // }

  // Future<String> checkStatus(String urn, String tid) async {
  // final body = {"urn": urn, "tid": tid};
  // print("Original Request: $body");
  // final encryptedData = WorldlineEncryption.encryptRequest(body);

  // final response = await http.post(
  // Uri.parse('https://lb.mrlpay.com/pcpos4/StatusCheck.php?source=941'),
  // headers: {'Content-Type': 'application/json'},
  // body: encryptedData,
  // );
  // final jsonResponse = jsonDecode(response.body);
  // final encrypted = jsonResponse['data'];
  // final decrypt = WorldlineEncryption.decryptResponse(encrypted);

  // final data = jsonDecode(decrypt);
  // return data['status'];
  // }

  // Future<String> waitForPaymentStatus(String urn, String tid) async {
  // while (true) {
  // final status = await checkStatus(urn, tid);

  // print("Status: $status");

  // if (status == "success") {
  // return "success";
  // }

  // if (status == "Failed") {
  // return "failed";
  // }

  // await Future.delayed(const Duration(seconds: 5));
  // }
  // }

  // saleTransaction(String? amt, String? mode) async {
  //   final request = {
  //     "tid": "2462204U",
  //     "amount": amt,
  //     "organization_code": "Retail",
  //     "invoiceNumber": "",
  //     "rrn": "",
  //     "type": mode == "CARD" ? "SALE" : "SALE-UPI",
  //     "cb_amt": "",
  //     "app_code": "",
  //     "tokenisedValue": "",
  //     "actionId": mode == "CARD" ? "1" : "133",
  //     "request_urn": "",
  //   };
  //   print("Original Request: $request");

  //   final encryptedData = WorldlineEncryption.encryptRequest(request);

  //   final response = await http.post(
  //     Uri.parse(
  //       'https://bouat.mrlpay.com/pcpos4/TransactionRequest.php?source=629',
  //     ),
  //     headers: {'Content-Type': 'application/json'},
  //     body: encryptedData,
  //   );

  //   final jsonResponse = jsonDecode(response.body);

  //   final encrypted = jsonResponse['data'];
  //   final decrypt = WorldlineEncryption.decryptResponse(encrypted);
  //   print("decrypt json: $decrypt");
  //   // if (decrypt == null || decrypt.startsWith("Error")) {
  //   //   print("Decryption failed: $decrypt");
  //   //   isEnabled.value = false;
  //   //   Helpers.successToast("Payment failed. Please try again.");
  //   //   return;
  //   // }
  //   final data = jsonDecode(decrypt);
  //   final String urn = data['urn'];
  //   final String tid = data['tid'];
  //   return await waitForPaymentStatus(urn, tid);
  // }

  // saleTransaction(String? amt, String? mode) async {
  // final request = {
  // "tid": "3419965A",
  // "amount": amt,
  // "organization_code": "Retail",
  // "invoiceNumber": "",
  // "rrn": "",
  // "type": mode == "CARD" ? "SALE" : "SALE-UPI",
  // "cb_amt": "",
  // "app_code": "",
  // "tokenisedValue": "",
  // "actionId": mode == "CARD" ? "1" : "133",
  // "request_urn": "",
  // };
  // print("Original Request: $request");

  // final encryptedData = WorldlineEncryption.encryptRequest(request);

  // final response = await http.post(
  // Uri.parse(
  // 'https://lb.mrlpay.com/pcpos4/TransactionRequest.php?source=941',
  // ),
  // headers: {'Content-Type': 'application/json'},
  // body: encryptedData,
  // );

  // final jsonResponse = jsonDecode(response.body);

  // final encrypted = jsonResponse['data'];
  // final decrypt = WorldlineEncryption.decryptResponse(encrypted);
  // print("decrypt json: $decrypt");
  // final data = jsonDecode(decrypt);
  // final String urn = data['urn'];
  // final String tid = data['tid'];
  // return await waitForPaymentStatus(urn, tid);
  // }

  void showPaymentStatusDialog(String message, {bool isSuccess = false}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.r),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isSuccess ? Icons.check_circle : Icons.error_outline,
                  color: isSuccess ? Colors.green : Colors.red,
                  size: 60.h,
                ),
                20.verticalSpace,
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: Fontpalette.blackinter45400,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("OK", style: Fontpalette.blackinter45400),
              ),
            ],
          ),
    );
  }

  // Future<void> _startScanAndAutoConnect() async {
  //   _devicesStreamSubscription?.cancel();
  //   await _flutterThermalPrinterPlugin.getPrinters(
  //     connectionTypes: [ConnectionType.USB],
  //   );
  //   _devicesStreamSubscription = _flutterThermalPrinterPlugin.devicesStream
  //       .listen((event) async {
  //         log('Discovered printers: ${event.map((e) => e.name).toList()}');
  //         final filtered =
  //             event.where((p) => (p.name?.isNotEmpty ?? false)).toList();
  //         setState(() {
  //           printers = filtered;
  //         });
  //         if (filtered.isNotEmpty) {
  //           final first = filtered.first;
  //           if (!(first.isConnected ?? false)) {
  //             await _flutterThermalPrinterPlugin.connect(first);
  //           }
  //           Helpers.successToast("Printer connected.");
  //           setState(() {
  //             connectedPrinter = first;
  //           });
  //         }
  //       });
  // }

  // void _stopScan() {
  //   _flutterThermalPrinterPlugin.stopScan();
  //   _devicesStreamSubscription?.cancel();
  // }

  // @override
  // void dispose() {
  //   _stopScan();
  //   super.dispose();
  // }

  Widget receiptWidgets({
    String? name,
    String? add1,
    String? add2,
    String? billno,
    String? date,
    List<PoojaDetails>? pooja,
    String? mode,
    String? total,
  }) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 380),
      child: Material(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  name ?? "NA",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              Center(
                child: Text(
                  add1 ?? "NA",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              Center(
                child: Text(
                  add2 ?? "NA",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              const Divider(thickness: 2),
              const SizedBox(height: 10),
              Text(
                'Bill No: ${billno ?? "NA"}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                'Bill Date: ${date ?? "NA"}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              if (pooja == null || pooja.isEmpty)
                SizedBox()
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var i = 0; i < pooja.length; i++) ...[
                      Text(
                        '${i + 1}. ${pooja[i].name ?? "NA"} - ${pooja[i].star ?? "NA"}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        '${pooja[i].diety ?? "NA"}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        '${pooja[i].pooja ?? ""} - ₹ ${pooja[i].rate ?? "NA"}x${pooja[i].qty ?? "NA"}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const Divider(),
                    ],
                  ],
                ),
              const Divider(thickness: 2),
              _buildReceiptRows(
                'Mode: ${mode ?? "NA"}',
                'Total: ₹ ${total ?? "NA"}',
                isBold: true,
              ),
              const SizedBox(height: 50),
              const Center(
                child: Text(
                  'Thank you!',
                  style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReceiptRows(
    String leftText,
    String rightText, {
    bool isBold = false,
  }) {
    final style = TextStyle(
      fontSize: 16,
      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              leftText,
              overflow: TextOverflow.ellipsis,
              style: style,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              rightText,
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              style: style,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _printReceipts({
    String? name,
    String? add1,
    String? add2,
    String? billno,
    String? date,
    String? mode,
    String? total,
    List<PoojaDetails>? pooja,
  }) async {
    // if (connectedPrinter == null) return;
    try {
      // await _flutterThermalPrinterPlugin.printWidget(
      //   context,
      //   printer: connectedPrinter!,
      //   printOnBle: false, // USB only
      //   widget: Directionality(
      //     textDirection: TextDirection.ltr,
      //     child: Column(
      //       mainAxisSize: MainAxisSize.min,
      //       crossAxisAlignment: CrossAxisAlignment.start,
      //       children: [
      //         Center(
      //           child: Text(
      //             name ?? "",
      //             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      //           ),
      //         ),
      //         Center(child: Text(add1 ?? '')),
      //         Center(child: Text(add2 ?? "")),
      //         SizedBox(height: 10),
      //         Divider(thickness: 1),
      //         Text("Bill No: $billno"),
      //         Text("Date: $date"),
      //         Divider(thickness: 1),
      //         Text("1. Ganapathi Pooja - ₹100 x 1"),
      //         Text(
      //           "Mode: $mode",
      //           style: TextStyle(fontWeight: FontWeight.bold),
      //         ),
      //         Text(
      //           "Total: ₹$total",
      //           style: TextStyle(fontWeight: FontWeight.bold),
      //         ),
      //         SizedBox(height: 20),
      //         Center(
      //           child: Text(
      //             "Thank you!",
      //             style: TextStyle(fontStyle: FontStyle.italic),
      //           ),
      //         ),
      //       ],
      //     ),
      //   ),
      // );

      final bytes = generateEscPosCommands(
        add1: add1,
        add2: add2,
        billno: billno,
        date: date,
        mode: mode,
        name: name,
        pooja: pooja,
        total: total,
      );

      // await FlutterThermalPrinter.instance.printData(connectedPrinter!, bytes);
    } catch (e, st) {
      Helpers.successToast("Error while printing: $e");
      debugPrintStack(stackTrace: st);
    }
  }

  List<int> generateEscPosCommands({
    String? name,
    String? add1,
    String? add2,
    String? billno,
    String? date,
    String? mode,
    String? total,
    List<PoojaDetails>? pooja,
  }) {
    List<int> bytes = [];

    // Initialize
    bytes += [27, 64]; // ESC @

    // Center align
    bytes += [27, 97, 1]; // ESC a 1
    bytes += [29, 33, 0]; // GS ! 0
    //bold
    bytes += [27, 69, 1]; // ESC E 1

    bytes += utf8.encode("$name\n");

    bytes += utf8.encode("$add1\n");
    bytes += utf8.encode("$add2\n\n");
    bytes += [27, 69, 0]; //bold off
    // Left align
    bytes += [27, 97, 0]; // ESC a 0

    bytes += utf8.encode("Bill No: $billno\n");
    bytes += utf8.encode("Date: $date\n\n");

    for (int i = 0; i < pooja!.length; i++) {
      final item = pooja[i];
      final name = item.name;
      final price = item.rate;
      final qty = item.qty;
      final star = item.star;
      final poojaname = item.pooja;
      final diety = item.diety;

      bytes += utf8.encode("${i + 1}. $name - $star\n");
      bytes += utf8.encode("   $diety\n");
      bytes += utf8.encode("   $poojaname - Rs $price x$qty\n");
    }

    bytes += [27, 97, 2]; // ESC a 2 → Right align
    bytes += [27, 69, 1]; // ESC E n (bold on)
    bytes += utf8.encode("\nTotal: Rs $total\n");
    bytes += utf8.encode("Mode: $mode\n");
    bytes += [27, 69, 0]; // ESC E n (bold off)
    bytes += [27, 97, 1]; // ESC a 1 align centre
    bytes += utf8.encode("\nThank you!\n\n\n");

    // Cut (if supported)
    bytes += [29, 86, 66, 0]; // GS V B n

    return bytes;
  }

  // paymentrazorpay({String? amt}) {
  //   Razorpay razorpay = Razorpay();
  //   var options = {
  //     'key': 'rzp_live_NGgmtciA7z56d4',
  //     'amount': "${amt}00" ?? 0,
  //     'name': 'SREE KADAMPUZHA.',
  //     'description': 'Pooja Booking',
  //     'retry': {'enabled': true, 'max_count': 1},
  //     'send_sms_hash': true,
  //     'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'},
  //     'external': {
  //       'wallets': ['paytm'],
  //     },
  //   };
  //   razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
  //   razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccessResponse);
  //   razorpay.open(options);
  // }

  // void handlePaymentErrorResponse(PaymentFailureResponse response) {
  //   print(response.message);
  //   isEnabled.value = false;
  //   Helpers.successToast("Payment failed");
  // }

  // void handlePaymentSuccessResponse(PaymentSuccessResponse response) async {
  //   final home = context.read<HomeProvider>();

  //   ;
  //   await home.saveBill(
  //     transid: response.paymentId,
  //     onSuccess: () {
  //       Helpers.successToast(home.saveBillResponse?.message ?? 'Bill Saved');
  //       Navigator.pushAndRemoveUntil(
  //         context,
  //         MaterialPageRoute(builder: (context) => const MyHomePage()),
  //         (route) => false,
  //       );
  //       isEnabled.value = false;
  //     },
  //     onFailure: () {
  //       isEnabled.value = false;
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<HomeProvider>(
        builder:
            (context, home, child) => Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: AlignmentDirectional.topCenter,
                  end: AlignmentDirectional.bottomCenter,
                  colors: [
                    const Color.fromARGB(255, 243, 233, 98),
                    const Color.fromARGB(255, 244, 245, 199),
                    Colors.white,
                    Colors.white,
                    Colors.white,
                  ],
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: -30.h,
                    right: -150.w,
                    child: Container(
                      height: 220.h,
                      width: 702.w,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage("assets/images/flwr.png"),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: -45.h,
                    left: -250.w,
                    child: Container(
                      height: 220.h,
                      width: 702.w,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage("assets/images/flwr.png"),
                        ),
                      ),
                    ),
                  ),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            25.verticalSpace,
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(45.r),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Thiruvambady Krishna Temple",
                                        style: Fontpalette.brown65700,
                                      ),
                                      Text(
                                        "തിരുവമ്പാടി ശ്രീകൃഷ്ണ ക്ഷേത്രം",
                                        style: Fontpalette.brown45600,
                                      ),
                                    ],
                                  ),
                                  Container(
                                    height: 80.h,
                                    width: 200.w,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        fit: BoxFit.contain,
                                        image: AssetImage(
                                          "assets/images/temple_diety_image.png",
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ).horizontalPadding(60.w).verticalPadding(15.h),
                            ),
                            20.verticalSpace,
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(45.r),
                                  color: Colors.white,
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        IconButton(
                                          onPressed:
                                              () => Navigator.of(context).pop(),
                                          icon: Icon(
                                            Icons.arrow_back_rounded,
                                            size: 80.w,
                                          ),
                                        ),
                                        Text(
                                          "Bill details",
                                          style: Fontpalette.blackinter50400,
                                        ),
                                        IconButton(
                                          onPressed:
                                              () => Navigator.of(context).pop(),
                                          icon: Icon(
                                            color: Colors.white,
                                            Icons.arrow_back_rounded,
                                            size: 70.w,
                                          ),
                                        ),
                                      ],
                                    ),
                                    10.verticalSpace,
                                    Container(
                                      height: 2.h,
                                      width: double.infinity,
                                      color: HexColor("#D97000"),
                                    ),
                                    20.verticalSpace,
                                    Expanded(
                                      child: ListView.separated(
                                        separatorBuilder:
                                            (context, index) =>
                                                10.verticalSpace,
                                        itemCount:
                                            home
                                                .previewBillResponse
                                                ?.data
                                                ?.poojaDetails
                                                ?.length ??
                                            0,
                                        // shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          final item =
                                              home
                                                  .previewBillResponse
                                                  ?.data
                                                  ?.poojaDetails![index];
                                          // The preview API doesn't receive/echo the pooja
                                          // name in the selected language (only IDs), so
                                          // fall back to the locally-tracked, already
                                          // localized name for display.
                                          final localPoojaName =
                                              index < home.pooja.length
                                                  ? home.pooja[index].pooja
                                                  : null;
                                          // "Kiosk User" is just a placeholder sent to
                                          // satisfy the API for Muttarukkal/Coconut/Net
                                          // Bag entries — not a real name, so don't show it.
                                          final rawDisplayName =
                                              (index < home.pooja.length
                                                  ? home.pooja[index].name
                                                  : null) ??
                                              item?.name;
                                          final displayName =
                                              rawDisplayName == "Kiosk User"
                                                  ? ""
                                                  : rawDisplayName;
                                          return Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(16.r),
                                              border: Border.all(
                                                color: HexColor("#AD9999"),
                                              ),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        "$displayName",
                                                        style:
                                                            Fontpalette
                                                                .black45600,
                                                      ),
                                                    ),
                                                    10.horizontalSpace,
                                                    // The Coconut line is
                                                    // always added together
                                                    // with its Muttarukkal
                                                    // line — it's removed
                                                    // automatically when the
                                                    // Muttarukkal line is
                                                    // removed, so it doesn't
                                                    // get its own button.
                                                    if (item?.poojaId ==
                                                        HomeProvider
                                                            .coconutPoojaId)
                                                      SizedBox()
                                                    else
                                                      InkWell(
                                                        onTap: () async {
                                                          final isMuttarukkal =
                                                              item?.poojaId ==
                                                              HomeProvider
                                                                  .muttarukkalPoojaId;
                                                          if (isMuttarukkal) {
                                                            await home
                                                                .removeMuttarukkalGroup(
                                                                  val:
                                                                      Navigator.of(
                                                                        context,
                                                                      ),
                                                                  index: index,
                                                                );
                                                          } else {
                                                            await home.removePooja(
                                                              val: Navigator.of(
                                                                context,
                                                              ),
                                                              index: index,
                                                            );
                                                          }
                                                        },
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  20.r,
                                                                ),
                                                            color:
                                                                const Color.fromARGB(
                                                                  255,
                                                                  238,
                                                                  102,
                                                                  23,
                                                                ),
                                                          ),
                                                          child:
                                                              home.poojaremoveloader ==
                                                                      LoaderState
                                                                          .loading
                                                                  ? CircularProgressIndicator(
                                                                    color:
                                                                        Colors
                                                                            .white,
                                                                  ).horizontalPadding(
                                                                    20.w,
                                                                  )
                                                                  : Text(
                                                                    "Remove",
                                                                    style:
                                                                        Fontpalette
                                                                            .white38500,
                                                                  ).symmetricPadding(
                                                                    vertical:
                                                                        5.h,
                                                                    horizontal:
                                                                        20.w,
                                                                  ),
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                                20.verticalSpace,
                                                Container(
                                                  height: 1.h,
                                                  width: double.infinity,
                                                  color: HexColor("#C9BEBE"),
                                                ),
                                                Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        item?.poojaId == null
                                                            ? SizedBox()
                                                            : Row(
                                                              children: [
                                                                SizedBox(
                                                                  width: 600.w,
                                                                  child: Text(
                                                                    "${localPoojaName ?? item?.pooja}",
                                                                    style:
                                                                        Fontpalette
                                                                            .black45600,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  "x ${item?.qty}",
                                                                  style:
                                                                      Fontpalette
                                                                          .black45600,
                                                                ),
                                                              ],
                                                            ),

                                                        Text(
                                                          "₹ ${item?.rate}",
                                                          style:
                                                              Fontpalette
                                                                  .black45600,
                                                        ),
                                                      ],
                                                    ).verticalPadding(7.h),
                                                  ],
                                                ),
                                              ],
                                            ).symmetricPadding(
                                              vertical: 15.h,
                                              horizontal: 60.w,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ).horizontalPadding(60.w).verticalPadding(20.h),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Total Amount",
                                    style: Fontpalette.blackinter50400,
                                  ),
                                  Text(
                                    "₹ ${home.grossamount?.toStringAsFixed(0)}",
                                    style: Fontpalette.black60700,
                                  ),
                                ],
                              ),
                              // IconButton(
                              //   onPressed:
                              //       connectedPrinter != null
                              //           ? _printReceipts
                              //           : null,

                              //   icon: Icon(Icons.price_change),
                              // ),
                              ValueListenableBuilder<bool>(
                                valueListenable: isEnabled,
                                builder:
                                    (context, value, child) => InkWell(
                                      //---------------------------------------------------------------------------------------
                                      // onTap: () async {
                                      // isEnabled.value = true;
                                      // String? selectedPaymentMode =
                                      // await selectPaymentMode(context);
                                      // print(
                                      // "Selected Payment Mode: $selectedPaymentMode",
                                      // );
                                      // if (selectedPaymentMode == null) {
                                      // isEnabled.value = false;
                                      // return;
                                      // }
                                      // showWaitingDialog();
                                      // final paymentStatus =
                                      // await saleTransaction(
                                      // home.grossamount?.toStringAsFixed(
                                      // 2,
                                      // ),
                                      // selectedPaymentMode,
                                      // );
                                      // Navigator.pop(
                                      // context,
                                      // ); // Dismiss the waiting dialog

                                      // bool connected =
                                      // await PrinterService.connect();
                                      // print(
                                      // "Payment Status..button: $paymentStatus",
                                      // );
                                      // // if (paymentStatus == "success") {
                                      // // AFTER
                                      // if (paymentStatus == "timeout") {
                                      // isEnabled.value = false;
                                      // Helpers.successToast(
                                      // "Payment timed out. Please try again.",
                                      // );
                                      // return;
                                      // }
                                      // if (paymentStatus == "success") {
                                      // await home.saveBill(
                                      // transid: "test",
                                      // paymentMode:
                                      // selectedPaymentMode == "CARD"
                                      // ? 4
                                      // : 6,
                                      // onSuccess: () async {
                                      // Helpers.successToast(
                                      // home
                                      // .saveBillResponse
                                      // ?.message ??
                                      // 'Bill Saved',
                                      // );
                                      // DateTime parsedDate =
                                      // DateTime.parse(
                                      // home
                                      // .saveBillResponse
                                      // ?.summary
                                      // ?.billDate ??
                                      // '',
                                      // );

                                      // // Format it to desired format: dd-MM-yyyy HH:mm:ss
                                      // String formatted = DateFormat(
                                      // 'dd-MM-yyyy HH:mm:ss',
                                      // ).format(parsedDate);
                                      // if (connected) {
                                      // final templeData =
                                      // home
                                      // .saveBillResponse
                                      // ?.temple;
                                      // // Malayalam selected (lanid != 1) and a
                                      // // translated name is available — otherwise
                                      // // fall back to the English name.
                                      // final templeName =
                                      // widget.lanid != 1 &&
                                      // (templeData
                                      // ?.nameMal
                                      // ?.isNotEmpty ??
                                      // false)
                                      // ? templeData!.nameMal
                                      // : templeData?.name;
                                      // await PrinterService.printReceipt(
                                      // temple: templeName,
                                      // templeAddress:
                                      // home
                                      // .saveBillResponse
                                      // ?.temple
                                      // ?.addressLine1 ??
                                      // '',
                                      // templePlace:
                                      // home
                                      // .saveBillResponse
                                      // ?.temple
                                      // ?.addressLine2 ??
                                      // '',
                                      // today: formatted,
                                      // id:
                                      // home
                                      // .saveBillResponse
                                      // ?.summary
                                      // ?.id,
                                      // mode:
                                      // home
                                      // .saveBillResponse
                                      // ?.summary
                                      // ?.mode
                                      // .toString(),
                                      // total:
                                      // home
                                      // .saveBillResponse
                                      // ?.summary
                                      // ?.total
                                      // .toString(),
                                      // website:
                                      // home
                                      // .saveBillResponse
                                      // ?.temple
                                      // ?.website ??
                                      // '',
                                      // items:
                                      // home.pooja
                                      // .asMap()
                                      // .entries
                                      // .map(
                                      // (entry) => {
                                      // "personId":
                                      // entry.key +
                                      // 1, // index
                                      // "personName":
                                      // entry
                                      // .value
                                      // .name,
                                      // "deity":
                                      // entry
                                      // .value
                                      // .diety,
                                      // "star":
                                      // entry
                                      // .value
                                      // .star,
                                      // "pooja":
                                      // entry
                                      // .value
                                      // .pooja,
                                      // "qty":
                                      // entry
                                      // .value
                                      // .qty,
                                      // "rate":
                                      // entry
                                      // .value
                                      // .rate,
                                      // "date":
                                      // entry
                                      // .value
                                      // .date,
                                      // "address":
                                      // entry
                                      // .value
                                      // .address,
                                      // },
                                      // )
                                      // .toList(),
                                      // );
                                      // isEnabled.value = false;
                                      // Navigator.pushAndRemoveUntil(
                                      // context,
                                      // MaterialPageRoute(
                                      // builder:
                                      // (context) =>
                                      // MyHomePage(),
                                      // ),
                                      // (route) => false,
                                      // );
                                      // } else {
                                      // Helpers.successToast(
                                      // "Failed to connect to printer. Bill saved but printing failed.",
                                      // );
                                      // isEnabled.value = false;
                                      // Navigator.pushAndRemoveUntil(
                                      // context,
                                      // MaterialPageRoute(
                                      // builder:
                                      // (context) =>
                                      // MyHomePage(),
                                      // ),
                                      // (route) => false,
                                      // );
                                      // }
                                      // },
                                      // onFailure: () async {
                                      // isEnabled.value = false;
                                      // },
                                      // );
                                      // } else {
                                      // isEnabled.value = false;
                                      // showPaymentStatusDialog(
                                      // "Payment failed",
                                      // );
                                      // }
                                      // },

                                      //----------------------------------------------------------------------------------------------------------------------------------

                                      // QR flow: show QR code, auto-print after 10 seconds.
                                      onTap: () => _showQrAndAutoPrint(home),

                                      // onTap: () async {
                                      //   isEnabled.value = true;

                                      //   String? selectedPaymentMode;
                                      //   String paymentStatus;
                                      //   bool connected = false;

                                      //   if (kSkipPaymentAndPrint) {
                                      //     // TEST MODE: no payment, no printer
                                      //     selectedPaymentMode = "CARD";
                                      //     paymentStatus = "success";
                                      //   } else {
                                      //     selectedPaymentMode = await selectPaymentMode(context);
                                      //     print("Selected Payment Mode: $selectedPaymentMode");
                                      //     if (selectedPaymentMode == null) {
                                      //       isEnabled.value = false;
                                      //       return;
                                      //     }
                                      //     showWaitingDialog();
                                      //     paymentStatus = await saleTransaction(
                                      //       home.grossamount?.toStringAsFixed(2),
                                      //       selectedPaymentMode,
                                      //     );
                                      //     Navigator.pop(context); // dismiss waiting dialog
                                      //     connected = await PrinterService.connect();
                                      //   }

                                      //   print("Payment Status..button: $paymentStatus");

                                      //   if (paymentStatus == "timeout") {
                                      //     isEnabled.value = false;
                                      //     Helpers.successToast("Payment timed out. Please try again.");
                                      //     return;
                                      //   }

                                      //   if (paymentStatus == "success") {
                                      //     await home.saveBill(
                                      //       transid: "test",
                                      //       paymentMode: selectedPaymentMode == "CARD" ? 4 : 6,
                                      //       onSuccess: () async {
                                      //         Helpers.successToast(
                                      //           home.saveBillResponse?.message ?? 'Bill Saved',
                                      //         );

                                      //         if (!kSkipPaymentAndPrint && connected) {
                                      //           final parsedDate = DateTime.parse(
                                      //             home.saveBillResponse?.summary?.billDate ?? '',
                                      //           );
                                      //           final formatted =
                                      //               DateFormat('dd-MM-yyyy HH:mm:ss').format(parsedDate);
                                      //           final templeData = home.saveBillResponse?.temple;
                                      //           final templeName = widget.lanid != 1 &&
                                      //                   (templeData?.nameMal?.isNotEmpty ?? false)
                                      //               ? templeData!.nameMal
                                      //               : templeData?.name;

                                      //           await PrinterService.printReceipt(
                                      //             temple: templeName,
                                      //             templeAddress: templeData?.addressLine1 ?? '',
                                      //             templePlace: templeData?.addressLine2 ?? '',
                                      //             today: formatted,
                                      //             id: home.saveBillResponse?.summary?.id,
                                      //             mode: home.saveBillResponse?.summary?.mode.toString(),
                                      //             total: home.saveBillResponse?.summary?.total.toString(),
                                      //             website: templeData?.website ?? '',
                                      //             items: home.pooja
                                      //                 .asMap()
                                      //                 .entries
                                      //                 .map((entry) => {
                                      //                       "personId": entry.key + 1,
                                      //                       "personName": entry.value.name,
                                      //                       "deity": entry.value.diety,
                                      //                       "star": entry.value.star,
                                      //                       "pooja": entry.value.pooja,
                                      //                       "qty": entry.value.qty,
                                      //                       "rate": entry.value.rate,
                                      //                       "date": entry.value.date,
                                      //                       "address": entry.value.address,
                                      //                     })
                                      //                 .toList(),
                                      //           );
                                      //         } else if (!kSkipPaymentAndPrint) {
                                      //           Helpers.successToast(
                                      //             "Failed to connect to printer. Bill saved but printing failed.",
                                      //           );
                                      //         }

                                      //         isEnabled.value = false;
                                      //         Navigator.pushAndRemoveUntil(
                                      //           context,
                                      //           MaterialPageRoute(builder: (context) => MyHomePage()),
                                      //           (route) => false,
                                      //         );
                                      //       },
                                      //       onFailure: () async {
                                      //         isEnabled.value = false;
                                      //       },
                                      //     );
                                      //   } else {
                                      //     isEnabled.value = false;
                                      //     showPaymentStatusDialog("Payment failed");
                                      //   }
                                      // },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            27.r,
                                          ),
                                          color: HexColor("#EC5002"),
                                        ),
                                        child:
                                            // isEnabled.value == true
                                            //     ? CircularProgressIndicator(
                                            //       color: Colors.white,
                                            //     ).horizontalPadding(20.w)
                                            //     : Text(
                                            //       "Confirm",
                                            //       style: Fontpalette.white45600,
                                            //     ).symmetricPadding(
                                            //       vertical: 18.h,
                                            //       horizontal: 150.w,
                                            //     ),
                                            // AFTER
                                            isEnabled.value == true
                                                ? CircularProgressIndicator(
                                                  color: Colors.white,
                                                ).horizontalPadding(20.w)
                                                : Text(
                                                  "Continue",
                                                  style: Fontpalette.white50700,
                                                ).symmetricPadding(
                                                  vertical: 18.h,
                                                  horizontal: 150.w,
                                                ),
                                      ),
                                    ),
                              ),
                            ],
                          ),
                          20.verticalSpace,
                        ],
                      ).horizontalPadding(100.w),
                    ],
                  ).horizontalPadding(90.w).topPadding(40.h).bottomPadding(5.h),
                ],
              ),
            ),
      ),
    );
  }

  // void showWaitingDialog() {
  // showDialog(
  // context: context,
  // barrierDismissible: false,
  // builder:
  // (context) => AlertDialog(
  // shape: RoundedRectangleBorder(
  // borderRadius: BorderRadius.circular(20.r),
  // ),
  // content: Column(
  // mainAxisSize: MainAxisSize.min,
  // children: [
  // CircularProgressIndicator(color: HexColor("#EC5002")),
  // 20.verticalSpace,
  // Text(
  // "Waiting for payment...",
  // textAlign: TextAlign.center,
  // style: Fontpalette.blackinter45400,
  // ),
  // ],
  // ),
  // ),
  // );
  // }
}

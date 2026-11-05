// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:kiosk/color_pallatte.dart';
// import 'package:kiosk/extension.dart';
// import 'package:kiosk/fontpallate.dart';
// import 'package:kiosk/provider/homeprovider.dart';
// import 'package:kiosk/services/helpers.dart';
// import 'package:kiosk/view/billpreview.dart';
// import 'package:kiosk/view/homepage.dart';
// import 'package:provider/provider.dart';

// // ─────────────────────────────────────────────────────────────────────────────
// // MUTTARUKKAL WITH COCONUT BOOKING SCREEN
// // Same shell (header, decorations, add-more/continue, print & preview flow)
// // as Bookpoojascreen, but with just Qty / Rate / Total Rate fields instead
// // of name/star/deity/pooja selection.
// // ─────────────────────────────────────────────────────────────────────────────
// class MuttarukkalBookingScreen extends StatefulWidget {
//   const MuttarukkalBookingScreen({super.key, this.lanid});
//   final int? lanid;

//   @override
//   State<MuttarukkalBookingScreen> createState() =>
//       _MuttarukkalBookingScreenState();
// }

// class _MuttarukkalBookingScreenState extends State<MuttarukkalBookingScreen> {
//   final TextEditingController qty = TextEditingController();

//   final ValueNotifier<bool> isEnabled = ValueNotifier<bool>(false);
//   final ValueNotifier<double> totalRate = ValueNotifier<double>(0);
//   final ValueNotifier<double?> unitRate = ValueNotifier<double?>(null);

//   static const String _label = "Muttarukkal with Coconut";

//   @override
//   void initState() {
//     super.initState();
//     qty.addListener(_recalcTotal);
//     _loadRate();
//   }

//   Future<void> _loadRate() async {
//     final rate = await context.read<HomeProvider>().getMuttarukkalWithCoconutRate();
//     if (!mounted) return;
//     unitRate.value = rate;
//     _recalcTotal();
//   }

//   void _recalcTotal() {
//     final q = int.tryParse(qty.text.trim()) ?? 0;
//     totalRate.value = q * (unitRate.value ?? 0);
//   }

//   @override
//   void dispose() {
//     qty.dispose();
//     isEnabled.dispose();
//     totalRate.dispose();
//     unitRate.dispose();
//     super.dispose();
//   }

//   bool _validate() {
//     if (unitRate.value == null || unitRate.value! <= 0) {
//       Helpers.successToast("Rate not available, please try again");
//       return false;
//     }
//     final q = int.tryParse(qty.text.trim());
//     if (q == null || q <= 0) {
//       Helpers.successToast("Please enter a valid quantity");
//       return false;
//     }
//     return true;
//   }

//   Future<void> _addEntry(HomeProvider home) async {
//     await home.addToPoojaDetails(
//       name: _label,
//       poojaname: _label,
//       diety: _label,
//       poojaid: HomeProvider.muttarukkalPoojaId,
//       rate: (unitRate.value ?? 0).toStringAsFixed(0),
//       qty: int.parse(qty.text.trim()),
//     );
//     qty.clear();
//     totalRate.value = 0;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: AlignmentDirectional.topCenter,
//             end: AlignmentDirectional.bottomCenter,
//             colors: [
//               const Color.fromARGB(255, 243, 233, 98),
//               const Color.fromARGB(255, 244, 245, 199),
//               Colors.white,
//               Colors.white,
//               Colors.white,
//             ],
//           ),
//         ),
//         child: Stack(
//           children: [
//             Positioned(
//               top: -30.h,
//               right: -150.w,
//               child: Container(
//                 height: 220.h,
//                 width: 702.w,
//                 decoration: BoxDecoration(
//                   image: DecorationImage(
//                     fit: BoxFit.fill,
//                     image: AssetImage("assets/images/flwr.png"),
//                   ),
//                 ),
//               ),
//             ),
//             Positioned(
//               top: -45.h,
//               left: -250.w,
//               child: Container(
//                 height: 220.h,
//                 width: 702.w,
//                 decoration: BoxDecoration(
//                   image: DecorationImage(
//                     fit: BoxFit.fill,
//                     image: AssetImage("assets/images/flwr.png"),
//                   ),
//                 ),
//               ),
//             ),
//             Consumer<HomeProvider>(
//               builder: (context, home, child) {
//                 return Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Expanded(
//                       child: Column(
//                         children: [
//                           25.verticalSpace,
//                           Container(
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(45.r),
//                             ),
//                             child: Row(
//                               mainAxisAlignment:
//                                   MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Column(
//                                   crossAxisAlignment:
//                                       CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       "Thiruvambady Krishna Temple",
//                                       style: Fontpalette.brown65700,
//                                     ),
//                                     Text(
//                                       "തിരുവമ്പാടി ശ്രീകൃഷ്ണ ക്ഷേത്രം",
//                                       style: Fontpalette.grey45600,
//                                     ),
//                                   ],
//                                 ),
//                                 Container(
//                                   height: 80.h,
//                                   width: 200.w,
//                                   decoration: BoxDecoration(
//                                     image: DecorationImage(
//                                       fit: BoxFit.contain,
//                                       image: AssetImage(
//                                         "assets/images/poojabookingimg.png",
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ).horizontalPadding(60.w).verticalPadding(15.h),
//                           ),
//                           20.verticalSpace,
//                           Expanded(
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(45.r),
//                                 color: Colors.white,
//                               ),
//                               child: SingleChildScrollView(
//                                 child: Column(
//                                   crossAxisAlignment:
//                                       CrossAxisAlignment.start,
//                                   children: [
//                                     Text(_label, style: Fontpalette.brown65700),
//                                     15.verticalSpace,
//                                     Row(
//                                       children: [
//                                         Expanded(
//                                           child: Column(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: [
//                                               Text(
//                                                 "Qty",
//                                                 style:
//                                                     Fontpalette
//                                                         .blackinter40400,
//                                               ),
//                                               5.verticalSpace,
//                                               _field(
//                                                 controller: qty,
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                         30.horizontalSpace,
//                                         Expanded(
//                                           child: Column(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: [
//                                               Text(
//                                                 "Rate",
//                                                 style:
//                                                     Fontpalette
//                                                         .blackinter40400,
//                                               ),
//                                               5.verticalSpace,
//                                               ValueListenableBuilder<double?>(
//                                                 valueListenable: unitRate,
//                                                 builder:
//                                                     (context, value, child) => Container(
//                                                       height: 50.h,
//                                                       alignment:
//                                                           Alignment
//                                                               .centerLeft,
//                                                       decoration: BoxDecoration(
//                                                         borderRadius:
//                                                             BorderRadius.circular(
//                                                               21.r,
//                                                             ),
//                                                         border: Border.all(
//                                                           color:
//                                                               Colors.black,
//                                                         ),
//                                                         color: HexColor(
//                                                           "#F5F5F5",
//                                                         ),
//                                                       ),
//                                                       child:
//                                                           value == null
//                                                               ? SizedBox(
//                                                                 height: 20.h,
//                                                                 width: 20.h,
//                                                                 child: const CircularProgressIndicator(
//                                                                   strokeWidth:
//                                                                       2,
//                                                                 ),
//                                                               ).horizontalPadding(
//                                                                 40.w,
//                                                               )
//                                                               : Text(
//                                                                 value
//                                                                     .toStringAsFixed(
//                                                                       0,
//                                                                     ),
//                                                                 style:
//                                                                     Fontpalette
//                                                                         .blackinter45400,
//                                                               ).horizontalPadding(
//                                                                 40.w,
//                                                               ),
//                                                     ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                         30.horizontalSpace,
//                                         Expanded(
//                                           child: Column(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: [
//                                               Text(
//                                                 "Total Rate",
//                                                 style:
//                                                     Fontpalette
//                                                         .blackinter40400,
//                                               ),
//                                               5.verticalSpace,
//                                               ValueListenableBuilder<double>(
//                                                 valueListenable: totalRate,
//                                                 builder:
//                                                     (context, value, child) => Container(
//                                                       height: 50.h,
//                                                       decoration: BoxDecoration(
//                                                         borderRadius:
//                                                             BorderRadius.circular(
//                                                               21.r,
//                                                             ),
//                                                         border: Border.all(
//                                                           color:
//                                                               Colors.black,
//                                                         ),
//                                                         color: HexColor(
//                                                           "#F5F5F5",
//                                                         ),
//                                                       ),
//                                                       child: Row(
//                                                         children: [
//                                                           Text(
//                                                             value
//                                                                 .toStringAsFixed(
//                                                                   0,
//                                                                 ),
//                                                             style:
//                                                                 Fontpalette
//                                                                     .blackinter45400,
//                                                           ).horizontalPadding(
//                                                             40.w,
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ).horizontalPadding(60.w).verticalPadding(20.h),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Column(
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [],
//                             ),
//                             ValueListenableBuilder<bool>(
//                               valueListenable: isEnabled,
//                               builder:
//                                   (context, value, child) => InkWell(
//                                     onTap: () async {
//                                       if (home.pooja.isEmpty) {
//                                         if (!_validate()) return;
//                                         isEnabled.value = true;
//                                         FocusScope.of(context).unfocus();
//                                         await _addEntry(home);
//                                         await home.getPreviewBill(
//                                           onSuccess: () async {
//                                             navigatescrren(
//                                               page: PreviewScreen(),
//                                               context: context,
//                                             );
//                                             home.clearStoredData();
//                                             isEnabled.value = false;
//                                           },
//                                           onFailure: () {
//                                             isEnabled.value = false;
//                                           },
//                                         );
//                                       } else {
//                                         isEnabled.value = true;
//                                         if (qty.text.isNotEmpty) {
//                                           if (!_validate()) {
//                                             isEnabled.value = false;
//                                             return;
//                                           }
//                                           await _addEntry(home);
//                                         }
//                                         await home.getPreviewBill(
//                                           onSuccess: () async {
//                                             navigatescrren(
//                                               page: PreviewScreen(),
//                                               context: context,
//                                             );
//                                             home.clearStoredData();
//                                             isEnabled.value = false;
//                                           },
//                                           onFailure: () {
//                                             isEnabled.value = false;
//                                           },
//                                         );
//                                       }
//                                     },
//                                     child: Container(
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(
//                                           27.r,
//                                         ),
//                                         color: HexColor("#EC5002"),
//                                       ),
//                                       child:
//                                           isEnabled.value == true
//                                               ? CircularProgressIndicator(
//                                                 color: Colors.white,
//                                               ).horizontalPadding(190.w)
//                                               : Text(
//                                                 "Continue",
//                                                 style: Fontpalette.white50700,
//                                               ).symmetricPadding(
//                                                 vertical: 18.h,
//                                                 horizontal: 150.w,
//                                               ),
//                                     ),
//                                   ),
//                             ),
//                           ],
//                         ),
//                         20.verticalSpace,
//                         Text(
//                           "www.punnyamtemplesuite.com",
//                           style: Fontpalette.brown30600,
//                         ),
//                       ],
//                     ).horizontalPadding(100.w),
//                   ],
//                 ).horizontalPadding(90.w).topPadding(70.h).bottomPadding(5.h);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _field({required TextEditingController controller}) {
//     return Container(
//       height: 50.h,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(21.r),
//         border: Border.all(color: Colors.black),
//       ),
//       child: TextField(
//         controller: controller,
//         keyboardType: TextInputType.number,
//         inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//         style: Fontpalette.blackinter45400,
//         textAlignVertical: TextAlignVertical.center,
//         decoration: InputDecoration(
//           isDense: true,
//           contentPadding: EdgeInsets.symmetric(
//             vertical: 15.h,
//             horizontal: 40.w,
//           ),
//           hintText: " ",
//           hintStyle: Fontpalette.blackinter24400,
//           border: InputBorder.none,
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:kiosk/color_pallatte.dart';
import 'package:kiosk/extension.dart';
import 'package:kiosk/fontpallate.dart';
import 'package:kiosk/provider/homeprovider.dart';
import 'package:kiosk/services/helpers.dart';
import 'package:kiosk/view/billpreview.dart';
import 'package:kiosk/view/homepage.dart';
import 'package:provider/provider.dart';

// ─────────────────────────────────────────────────────────────────────────────
// MUTTARUKKAL WITH COCONUT BOOKING SCREEN
// Same shell (header, decorations, add-more/continue, print & preview flow)
// as Bookpoojascreen, but with just Qty / Rate / Total Rate fields instead
// of name/star/deity/pooja selection.
// ─────────────────────────────────────────────────────────────────────────────
class MuttarukkalBookingScreen extends StatefulWidget {
  const MuttarukkalBookingScreen({super.key, this.lanid});
  final int? lanid;

  @override
  State<MuttarukkalBookingScreen> createState() =>
      _MuttarukkalBookingScreenState();
}

class _MuttarukkalBookingScreenState extends State<MuttarukkalBookingScreen> {
  final TextEditingController qty = TextEditingController();
  final TextEditingController netBag = TextEditingController();

  final ValueNotifier<bool> isEnabled = ValueNotifier<bool>(false);
  final ValueNotifier<double> totalRate = ValueNotifier<double>(0);
  final ValueNotifier<double?> unitRate = ValueNotifier<double?>(null);
  final ValueNotifier<double?> muttarukkalUnitRate = ValueNotifier<double?>(
    null,
  );
  final ValueNotifier<double?> coconutUnitRate = ValueNotifier<double?>(null);
  final ValueNotifier<double?> netBagRate = ValueNotifier<double?>(null);
  final ValueNotifier<double> netBagTotal = ValueNotifier<double>(0);
  final ValueNotifier<double> muttarukkalTotal = ValueNotifier<double>(0);

  // Populated from the pooja master data (getPoojaDetails), so the printed
  // / saved name always matches the API's own name/name_mal instead of a
  // hand-maintained translation.
  String? _muttarukkalName;
  String? _muttarukkalNameMal;
  String? _coconutName;
  String? _coconutNameMal;
  String? _netBagName;
  String? _netBagNameMal;

  String get _label =>
      widget.lanid == 1
          ? "Muttarukkal with Coconut"
          : "മുട്ടറുക്കൽ നാളികേരത്തോടുകൂടി";

  String get _muttarukkalDisplayName =>
      widget.lanid == 1
          ? (_muttarukkalName ?? "Muttarukkal")
          : (_muttarukkalNameMal ?? "മുട്ടറുക്കൽ");

  String get _coconutDisplayName =>
      widget.lanid == 1
          ? (_coconutName ?? "Coconut")
          : (_coconutNameMal ?? "നാളികേരത്തോടുകൂടി");

  String get _netBagDisplayName =>
      widget.lanid == 1
          ? (_netBagName ?? "Net Bag")
          : (_netBagNameMal ?? "നെറ്റ് ബാഗ്");

  @override
  void initState() {
    super.initState();
    qty.addListener(_recalcTotal);
    netBag.addListener(_recalcTotal);
    _loadRate();
    _loadNetBagRate();
  }

  Future<void> _loadRate() async {
    final info =
        await context.read<HomeProvider>().getMuttarukkalAndCoconutInfo();
    if (!mounted) return;
    muttarukkalUnitRate.value = info.muttarukkalRate;
    coconutUnitRate.value = info.coconutRate;
    _muttarukkalName = info.muttarukkalName;
    _muttarukkalNameMal = info.muttarukkalNameMal;
    _coconutName = info.coconutName;
    _coconutNameMal = info.coconutNameMal;
    unitRate.value = info.muttarukkalRate + info.coconutRate;
    _recalcTotal();
  }

  Future<void> _loadNetBagRate() async {
    final info = await context.read<HomeProvider>().getNetBagInfo();
    if (!mounted) return;
    netBagRate.value = info.rate;
    _netBagName = info.name;
    _netBagNameMal = info.nameMal;
    _recalcTotal();
  }

  void _recalcTotal() {
    final q = int.tryParse(qty.text.trim()) ?? 0;
    final nb = int.tryParse(netBag.text.trim()) ?? 0;
    final double muttarukkalAmount = q * (unitRate.value ?? 0);
    final double netBagAmount = nb * (netBagRate.value ?? 0);
    muttarukkalTotal.value = muttarukkalAmount;
    netBagTotal.value = netBagAmount;
    totalRate.value = muttarukkalAmount + netBagAmount;
  }

  @override
  void dispose() {
    qty.dispose();
    netBag.dispose();
    isEnabled.dispose();
    totalRate.dispose();
    unitRate.dispose();
    muttarukkalUnitRate.dispose();
    coconutUnitRate.dispose();
    netBagRate.dispose();
    netBagTotal.dispose();
    muttarukkalTotal.dispose();
    super.dispose();
  }

  bool _validate() {
    if (unitRate.value == null || unitRate.value! <= 0) {
      Helpers.successToast("Rate not available, please try again");
      return false;
    }
    final q = int.tryParse(qty.text.trim());
    if (q == null || q <= 0) {
      Helpers.successToast("Please enter a valid quantity");
      return false;
    }
    final nbText = netBag.text.trim();
    if (nbText.isNotEmpty) {
      final nb = int.tryParse(nbText);
      if (nb == null || nb < 0) {
        Helpers.successToast("Please enter a valid net bag count");
        return false;
      }
    }
    return true;
  }

  Future<void> _addEntry(HomeProvider home) async {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final q = int.parse(qty.text.trim());

    await home.addToPoojaDetails(
      name: "Kiosk User",
      poojaname: _muttarukkalDisplayName,
      diety: _label,
      poojaid: HomeProvider.muttarukkalPoojaId,
      starid: 28,
      dietyid: 4,
      date: today,
      rate: (muttarukkalUnitRate.value ?? 0).toStringAsFixed(0),
      qty: q,
    );

    await home.addToPoojaDetails(
      name: "Kiosk User",
      poojaname: _coconutDisplayName,
      diety: _label,
      poojaid: HomeProvider.coconutPoojaId,
      starid: 28,
      dietyid: 4,
      date: today,
      rate: (coconutUnitRate.value ?? 0).toStringAsFixed(0),
      qty: q,
    );

    final nb = int.tryParse(netBag.text.trim()) ?? 0;
    if (nb > 0) {
      await home.addToPoojaDetails(
        name: "Kiosk User",
        poojaname: _netBagDisplayName,
        diety: _netBagDisplayName,
        star: _netBagDisplayName,
        poojaid: HomeProvider.netBagPoojaId,
        starid: 28,
        dietyid: 4,
        date: today,
        rate: (netBagRate.value ?? 0).toStringAsFixed(0),
        qty: nb,
      );
    }

    qty.clear();
    netBag.clear();
    totalRate.value = 0;
    netBagTotal.value = 0;
    muttarukkalTotal.value = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
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
            Consumer<HomeProvider>(
              builder: (context, home, child) {
                return Column(
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Thiruvambady Krishna Temple",
                                      style: Fontpalette.brown65700,
                                    ),
                                    Text(
                                      "തിരുവമ്പാടി ശ്രീകൃഷ്ണ ക്ഷേത്രം",
                                      style: Fontpalette.grey45600,
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
                                        "assets/images/poojabookingimg.png",
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
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(_label, style: Fontpalette.brown65700),
                                    15.verticalSpace,
                                    // ── Muttarukkal: Qty / Rate / Total ──
                                    Row(
                                      children: [
                                        _labeledField(
                                          label: "Qty",
                                          field: _field(controller: qty),
                                        ),
                                        30.horizontalSpace,
                                        _labeledField(
                                          label: "Rate",
                                          field: _rateField(unitRate),
                                        ),
                                        30.horizontalSpace,
                                        _labeledField(
                                          label: "Muttarukkal Total",
                                          field: _totalField(muttarukkalTotal),
                                        ),
                                      ],
                                    ),
                                    20.verticalSpace,
                                    // ── Net Bag: Qty / Rate / Total (next line) ──
                                    Row(
                                      children: [
                                        _labeledField(
                                          label: "Net Bag",
                                          field: _field(controller: netBag),
                                        ),
                                        30.horizontalSpace,
                                        _labeledField(
                                          label: "Net Bag Rate",
                                          field: _rateField(netBagRate),
                                        ),
                                        30.horizontalSpace,
                                        _labeledField(
                                          label: "Net Bag Total",
                                          field: _totalField(netBagTotal),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "Please select a bag if required.",
                                      style: TextStyle(fontSize: 10),
                                    ),
                                    20.verticalSpace,
                                    // ── Grand total: Muttarukkal + Net Bag ──
                                    Row(
                                      children: [
                                        _labeledField(
                                          label: "Total Rate",
                                          field: _totalField(totalRate),
                                        ),
                                      ],
                                    ),
                                  ],
                                ).horizontalPadding(60.w).verticalPadding(20.h),
                              ),
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
                              children: [],
                            ),
                            ValueListenableBuilder<bool>(
                              valueListenable: isEnabled,
                              builder:
                                  (context, value, child) => InkWell(
                                    onTap: () async {
                                      if (home.pooja.isEmpty) {
                                        if (!_validate()) return;
                                        isEnabled.value = true;
                                        FocusScope.of(context).unfocus();
                                        await _addEntry(home);
                                        await home.getPreviewBill(
                                          onSuccess: () async {
                                            navigatescrren(
                                              page: PreviewScreen(
                                                lanid: widget.lanid,
                                              ),
                                              context: context,
                                            );
                                            home.clearStoredData();
                                            isEnabled.value = false;
                                          },
                                          onFailure: () {
                                            isEnabled.value = false;
                                          },
                                        );
                                      } else {
                                        isEnabled.value = true;
                                        if (qty.text.isNotEmpty) {
                                          if (!_validate()) {
                                            isEnabled.value = false;
                                            return;
                                          }
                                          await _addEntry(home);
                                        }
                                        await home.getPreviewBill(
                                          onSuccess: () async {
                                            navigatescrren(
                                              page: PreviewScreen(
                                                lanid: widget.lanid,
                                              ),
                                              context: context,
                                            );
                                            home.clearStoredData();
                                            isEnabled.value = false;
                                          },
                                          onFailure: () {
                                            isEnabled.value = false;
                                          },
                                        );
                                      }
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          27.r,
                                        ),
                                        color: HexColor("#EC5002"),
                                      ),
                                      child:
                                          isEnabled.value == true
                                              ? CircularProgressIndicator(
                                                color: Colors.white,
                                              ).horizontalPadding(190.w)
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
                        Text(
                          "www.punnyamtemplesuite.com",
                          style: Fontpalette.brown30600,
                        ),
                      ],
                    ).horizontalPadding(100.w),
                  ],
                ).horizontalPadding(90.w).topPadding(70.h).bottomPadding(5.h);
              },
            ),
          ],
        ),
      ),
    );
  }

  // Wraps a field with its label above it, matching the Qty/Rate/Total layout.
  Widget _labeledField({required String label, required Widget field}) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Fontpalette.blackinter40400),
          5.verticalSpace,
          field,
        ],
      ),
    );
  }

  // Read-only rate display — shows a spinner until the rate finishes loading.
  Widget _rateField(ValueListenable<double?> rate) {
    return ValueListenableBuilder<double?>(
      valueListenable: rate,
      builder:
          (context, value, child) => Container(
            height: 50.h,
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(21.r),
              border: Border.all(color: Colors.black),
              color: HexColor("#F5F5F5"),
            ),
            child:
                value == null
                    ? SizedBox(
                      height: 20.h,
                      width: 20.h,
                      child: const CircularProgressIndicator(strokeWidth: 2),
                    ).horizontalPadding(40.w)
                    : Text(
                      value.toStringAsFixed(0),
                      style: Fontpalette.blackinter45400,
                    ).horizontalPadding(40.w),
          ),
    );
  }

  // Read-only computed total display (Qty*Rate or NetBag*NetBagRate).
  Widget _totalField(ValueListenable<double> total) {
    return ValueListenableBuilder<double>(
      valueListenable: total,
      builder:
          (context, value, child) => Container(
            height: 50.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(21.r),
              border: Border.all(color: Colors.black),
              color: HexColor("#F5F5F5"),
            ),
            child: Row(
              children: [
                Text(
                  value.toStringAsFixed(0),
                  style: Fontpalette.blackinter45400,
                ).horizontalPadding(40.w),
              ],
            ),
          ),
    );
  }

  Widget _field({required TextEditingController controller}) {
    return Container(
      height: 50.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(21.r),
        border: Border.all(color: Colors.black),
      ),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: Fontpalette.blackinter45400,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.symmetric(
            vertical: 15.h,
            horizontal: 40.w,
          ),
          hintText: " ",
          hintStyle: Fontpalette.blackinter24400,
          border: InputBorder.none,
        ),
      ),
    );
  }
}

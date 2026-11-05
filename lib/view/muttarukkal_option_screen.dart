// // import 'package:flutter/material.dart';
// // import 'package:flutter_screenutil/flutter_screenutil.dart';
// // import 'package:kiosk/color_pallatte.dart';
// // import 'package:kiosk/extension.dart';
// // import 'package:kiosk/fontpallate.dart';
// // import 'package:kiosk/provider/homeprovider.dart';
// // import 'package:kiosk/view/bookpooja.dart';
// // import 'package:kiosk/view/homepage.dart';
// // import 'package:kiosk/view/muttarukkal_booking_screen.dart';
// // import 'package:provider/provider.dart';

// // // ─────────────────────────────────────────────────────────────────────────────
// // // BOOK A POOJA — option picker: Muttarukkal with Coconut / Others
// // // ─────────────────────────────────────────────────────────────────────────────
// // class MuttarukkalOptionScreen extends StatelessWidget {
// //   const MuttarukkalOptionScreen({super.key, this.lanid});
// //   final int? lanid;

// //   @override
// //   Widget build(BuildContext context) {
// //     final home = context.read<HomeProvider>();
// //     return Scaffold(
// //       resizeToAvoidBottomInset: false,
// //       body: Container(
// //         decoration: BoxDecoration(
// //           gradient: LinearGradient(
// //             begin: AlignmentDirectional.topCenter,
// //             end: AlignmentDirectional.bottomCenter,
// //             colors: [
// //               const Color.fromARGB(255, 243, 233, 98),
// //               const Color.fromARGB(255, 244, 245, 199),
// //               Colors.white,
// //               Colors.white,
// //               Colors.white,
// //             ],
// //           ),
// //         ),
// //         child: Stack(
// //           children: [
// //             Positioned(
// //               top: -30.h,
// //               right: -150.w,
// //               child: Container(
// //                 height: 220.h,
// //                 width: 702.w,
// //                 decoration: BoxDecoration(
// //                   image: DecorationImage(
// //                     fit: BoxFit.fill,
// //                     image: AssetImage("assets/images/flwr.png"),
// //                   ),
// //                 ),
// //               ),
// //             ),
// //             Positioned(
// //               top: -45.h,
// //               left: -250.w,
// //               child: Container(
// //                 height: 220.h,
// //                 width: 702.w,
// //                 decoration: BoxDecoration(
// //                   image: DecorationImage(
// //                     fit: BoxFit.fill,
// //                     image: AssetImage("assets/images/flwr.png"),
// //                   ),
// //                 ),
// //               ),
// //             ),
// //             Column(
// //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //               children: [
// //                 Column(
// //                   children: [
// //                     25.verticalSpace,
// //                     Container(
// //                       decoration: BoxDecoration(
// //                         color: Colors.white,
// //                         borderRadius: BorderRadius.circular(45.r),
// //                       ),
// //                       child: Row(
// //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                         children: [
// //                           Column(
// //                             crossAxisAlignment: CrossAxisAlignment.start,
// //                             children: [
// //                               Text(
// //                                 "Thiruvambady Krishna Temple",
// //                                 style: Fontpalette.brown65700,
// //                               ),
// //                               Text(
// //                                 "തിരുവമ്പാടി ശ്രീകൃഷ്ണ ക്ഷേത്രം",
// //                                 style: Fontpalette.grey45600,
// //                               ),
// //                             ],
// //                           ),
// //                           Container(
// //                             height: 80.h,
// //                             width: 200.w,
// //                             decoration: BoxDecoration(
// //                               image: DecorationImage(
// //                                 fit: BoxFit.contain,
// //                                 image: AssetImage(
// //                                   "assets/images/poojabookingimg.png",
// //                                 ),
// //                               ),
// //                             ),
// //                           ),
// //                         ],
// //                       ).horizontalPadding(60.w).verticalPadding(15.h),
// //                     ),
// //                     60.verticalSpace,
// //                     _OptionButton(
// //                       label:
// //                           lanid == 1
// //                               ? "Muttarukkal with Coconut"
// //                               : "മുട്ടറുക്കൽ (തേങ്ങയോടെ)",
// //                       onTap: () {
// //                         home.clearStoredData();
// //                         home.clearGrossAmount();
// //                         navigatescrren(
// //                           context: context,
// //                           page: MuttarukkalBookingScreen(lanid: lanid),
// //                         );
// //                       },
// //                     ),
// //                     20.verticalSpace,
// //                     _OptionButton(
// //                       label: lanid == 1 ? "Others" : "മറ്റുള്ളവ",
// //                       onTap: () {
// //                         home.clearStoredData();
// //                         home.clearGrossAmount();
// //                         navigatescrren(
// //                           context: context,
// //                           page: Bookpoojascreen(lanid: lanid),
// //                         );
// //                       },
// //                     ),
// //                   ],
// //                 ),
// //                 Column(
// //                   children: [
// //                     Row(
// //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                       children: [
// //                         Container(
// //                           height: 107.h,
// //                           width: 500.w,
// //                           decoration: BoxDecoration(
// //                             image: DecorationImage(
// //                               fit: BoxFit.contain,
// //                               image: AssetImage(
// //                                 "assets/images/logowithname.png",
// //                               ),
// //                             ),
// //                           ),
// //                         ),
// //                         Text(
// //                           "www.punnyamtemplesuite.com",
// //                           style: Fontpalette.brown30600,
// //                         ),
// //                       ],
// //                     ).horizontalPadding(100.w),
// //                   ],
// //                 ),
// //               ],
// //             ).horizontalPadding(90.w).topPadding(80.h).bottomPadding(5.h),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// // class _OptionButton extends StatelessWidget {
// //   const _OptionButton({required this.label, required this.onTap});
// //   final String label;
// //   final VoidCallback onTap;

// //   @override
// //   Widget build(BuildContext context) {
// //     return InkWell(
// //       onTap: onTap,
// //       child: Container(
// //         width: 600.w,
// //         height: 70.h,
// //         decoration: BoxDecoration(
// //           color: HexColor("#EC5002"),
// //           borderRadius: BorderRadius.circular(27.r),
// //           border: Border.all(color: HexColor("#F8A300"), width: 4.h),
// //         ),
// //         child: Center(
// //           child: Text(
// //             label,
// //             textAlign: TextAlign.center,
// //             style: Fontpalette.white45500,
// //           ).horizontalPadding(20.w),
// //         ),
// //       ),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:kiosk/color_pallatte.dart';
// import 'package:kiosk/extension.dart';
// import 'package:kiosk/fontpallate.dart';
// import 'package:kiosk/provider/homeprovider.dart';
// import 'package:kiosk/view/bookpooja.dart';
// import 'package:kiosk/view/homepage.dart';
// import 'package:kiosk/view/muttarukkal_booking_screen.dart';
// import 'package:provider/provider.dart';

// // ─────────────────────────────────────────────────────────────────────────────
// // BOOK A POOJA — option picker: Muttarukkal with Coconut / Others
// // ─────────────────────────────────────────────────────────────────────────────
// class MuttarukkalOptionScreen extends StatelessWidget {
//   const MuttarukkalOptionScreen({super.key, this.lanid});
//   final int? lanid;

//   @override
//   Widget build(BuildContext context) {
//     final home = context.read<HomeProvider>();
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
//             Column(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Column(
//                   children: [
//                     25.verticalSpace,
//                     Container(
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(45.r),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 "Thiruvambady Krishna Temple",
//                                 style: Fontpalette.brown65700,
//                               ),
//                               Text(
//                                 "തിരുവമ്പാടി ശ്രീകൃഷ്ണ ക്ഷേത്രം",
//                                 style: Fontpalette.grey45600,
//                               ),
//                             ],
//                           ),
//                           Container(
//                             height: 80.h,
//                             width: 200.w,
//                             decoration: BoxDecoration(
//                               image: DecorationImage(
//                                 fit: BoxFit.contain,
//                                 image: AssetImage(
//                                   "assets/images/poojabookingimg.png",
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ).horizontalPadding(60.w).verticalPadding(15.h),
//                     ),
//                     60.verticalSpace,
//                     _OptionButton(
//                       label:
//                           lanid == 1
//                               ? "Muttarukkal with Coconut"
//                               : "മുട്ടറുക്കൽ (തേങ്ങയോടെ)",
//                       onTap: () {
//                         home.clearStoredData();
//                         home.clearGrossAmount();
//                         navigatescrren(
//                           context: context,
//                           page: MuttarukkalBookingScreen(lanid: lanid),
//                         );
//                       },
//                     ),
//                     20.verticalSpace,
//                     _OptionButton(
//                       label: lanid == 1 ? "Others" : "മറ്റുള്ളവ",
//                       onTap: () {
//                         home.clearStoredData();
//                         home.clearGrossAmount();
//                         navigatescrren(
//                           context: context,
//                           page: Bookpoojascreen(lanid: lanid),
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//                 Column(
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Container(
//                           height: 107.h,
//                           width: 500.w,
//                           decoration: BoxDecoration(
//                             image: DecorationImage(
//                               fit: BoxFit.contain,
//                               image: AssetImage(
//                                 "assets/images/logowithname.png",
//                               ),
//                             ),
//                           ),
//                         ),
//                         Text(
//                           "www.punnyamtemplesuite.com",
//                           style: Fontpalette.brown30600,
//                         ),
//                       ],
//                     ).horizontalPadding(100.w),
//                   ],
//                 ),
//               ],
//             ).horizontalPadding(90.w).topPadding(80.h).bottomPadding(5.h),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _OptionButton extends StatelessWidget {
//   const _OptionButton({required this.label, required this.onTap});
//   final String label;
//   final VoidCallback onTap;

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       child: Container(
//         width: 600.w,
//         height: 70.h,
//         decoration: BoxDecoration(
//           color: HexColor("#EC5002"),
//           borderRadius: BorderRadius.circular(27.r),
//           border: Border.all(color: HexColor("#F8A300"), width: 4.h),
//         ),
//         child: Center(
//           child: Text(
//             label,
//             textAlign: TextAlign.center,
//             style: Fontpalette.white45500,
//           ).horizontalPadding(20.w),
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:kiosk/color_pallatte.dart';
// import 'package:kiosk/extension.dart';
// import 'package:kiosk/fontpallate.dart';
// import 'package:kiosk/provider/homeprovider.dart';
// import 'package:kiosk/view/bookpooja.dart';
// import 'package:kiosk/view/homepage.dart';
// import 'package:kiosk/view/muttarukkal_booking_screen.dart';
// import 'package:provider/provider.dart';

// // ─────────────────────────────────────────────────────────────────────────────
// // BOOK A POOJA — option picker: Muttarukkal with Coconut / Others
// // ─────────────────────────────────────────────────────────────────────────────
// class MuttarukkalOptionScreen extends StatelessWidget {
//   const MuttarukkalOptionScreen({super.key, this.lanid});
//   final int? lanid;

//   @override
//   Widget build(BuildContext context) {
//     final home = context.read<HomeProvider>();
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
//             Column(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Column(
//                   children: [
//                     25.verticalSpace,
//                     Container(
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(45.r),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 "Thiruvambady Krishna Temple",
//                                 style: Fontpalette.brown65700,
//                               ),
//                               Text(
//                                 "തിരുവമ്പാടി ശ്രീകൃഷ്ണ ക്ഷേത്രം",
//                                 style: Fontpalette.grey45600,
//                               ),
//                             ],
//                           ),
//                           Container(
//                             height: 80.h,
//                             width: 200.w,
//                             decoration: BoxDecoration(
//                               image: DecorationImage(
//                                 fit: BoxFit.contain,
//                                 image: AssetImage(
//                                   "assets/images/poojabookingimg.png",
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ).horizontalPadding(60.w).verticalPadding(15.h),
//                     ),
//                     60.verticalSpace,
//                     _OptionButton(
//                       label:
//                           lanid == 1
//                               ? "Muttarukkal with Coconut"
//                               : "മുട്ടറുക്കൽ (തേങ്ങയോടെ)",
//                       onTap: () {
//                         home.clearStoredData();
//                         home.clearGrossAmount();
//                         navigatescrren(
//                           context: context,
//                           page: MuttarukkalBookingScreen(lanid: lanid),
//                         );
//                       },
//                     ),
//                     20.verticalSpace,
//                     _OptionButton(
//                       label: lanid == 1 ? "Others" : "മറ്റുള്ളവ",
//                       onTap: () {
//                         home.clearStoredData();
//                         home.clearGrossAmount();
//                         navigatescrren(
//                           context: context,
//                           page: Bookpoojascreen(lanid: lanid),
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//                 Column(
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Container(
//                           height: 107.h,
//                           width: 500.w,
//                           decoration: BoxDecoration(
//                             image: DecorationImage(
//                               fit: BoxFit.contain,
//                               image: AssetImage(
//                                 "assets/images/logowithname.png",
//                               ),
//                             ),
//                           ),
//                         ),
//                         Text(
//                           "www.punnyamtemplesuite.com",
//                           style: Fontpalette.brown30600,
//                         ),
//                       ],
//                     ).horizontalPadding(100.w),
//                   ],
//                 ),
//               ],
//             ).horizontalPadding(90.w).topPadding(80.h).bottomPadding(5.h),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _OptionButton extends StatelessWidget {
//   const _OptionButton({required this.label, required this.onTap});
//   final String label;
//   final VoidCallback onTap;

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       child: Container(
//         width: 600.w,
//         height: 70.h,
//         decoration: BoxDecoration(
//           color: HexColor("#EC5002"),
//           borderRadius: BorderRadius.circular(27.r),
//           border: Border.all(color: HexColor("#F8A300"), width: 4.h),
//         ),
//         child: Center(
//           child: Text(
//             label,
//             textAlign: TextAlign.center,
//             style: Fontpalette.white45500,
//           ).horizontalPadding(20.w),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kiosk/color_pallatte.dart';
import 'package:kiosk/extension.dart';
import 'package:kiosk/fontpallate.dart';
import 'package:kiosk/provider/homeprovider.dart';
import 'package:kiosk/view/bookpooja.dart';
import 'package:kiosk/view/homepage.dart';
import 'package:kiosk/view/muttarukkal_booking_screen.dart';
import 'package:provider/provider.dart';

// ─────────────────────────────────────────────────────────────────────────────
// BOOK A POOJA — option picker: Muttarukkal with Coconut / Others
// ─────────────────────────────────────────────────────────────────────────────
class MuttarukkalOptionScreen extends StatelessWidget {
  const MuttarukkalOptionScreen({super.key, this.lanid});
  final int? lanid;

  @override
  Widget build(BuildContext context) {
    final home = context.read<HomeProvider>();
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
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
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
                    60.verticalSpace,
                    _OptionButton(
                      label:
                          lanid == 1
                              ? "Muttarukkal with Coconut"
                              : "മുട്ടറുക്കൽ നാളികേരത്തോടുകൂടി",
                      onTap: () {
                        home.clearStoredData();
                        home.clearGrossAmount();
                        navigatescrren(
                          context: context,
                          page: MuttarukkalBookingScreen(lanid: lanid),
                        );
                      },
                    ),
                    20.verticalSpace,
                    _OptionButton(
                      label: lanid == 1 ? "Others" : "മറ്റുള്ളവ",
                      onTap: () {
                        home.clearStoredData();
                        home.clearGrossAmount();
                        navigatescrren(
                          context: context,
                          page: Bookpoojascreen(lanid: lanid),
                        );
                      },
                    ),
                  ],
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 107.h,
                          width: 500.w,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.contain,
                              image: AssetImage(
                                "assets/images/logowithname.png",
                              ),
                            ),
                          ),
                        ),
                        Text(
                          "www.punnyamtemplesuite.com",
                          style: Fontpalette.brown30600,
                        ),
                      ],
                    ).horizontalPadding(100.w),
                  ],
                ),
              ],
            ).horizontalPadding(90.w).topPadding(80.h).bottomPadding(5.h),
          ],
        ),
      ),
    );
  }
}

class _OptionButton extends StatelessWidget {
  const _OptionButton({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 600.w,
        height: 70.h,
        decoration: BoxDecoration(
          color: HexColor("#EC5002"),
          borderRadius: BorderRadius.circular(27.r),
          border: Border.all(color: HexColor("#F8A300"), width: 4.h),
        ),
        child: Center(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: Fontpalette.white45500,
          ).horizontalPadding(20.w),
        ),
      ),
    );
  }
}

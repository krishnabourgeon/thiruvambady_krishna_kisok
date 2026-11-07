// // import 'package:flutter/material.dart';
// // import 'package:flutter_screenutil/flutter_screenutil.dart';
// // import 'package:kiosk/color_pallatte.dart';
// // import 'package:kiosk/extension.dart';
// // import 'package:kiosk/fontpallate.dart';
// // import 'package:kiosk/provider/homeprovider.dart';
// // import 'package:kiosk/view/bookpooja.dart';
// // import 'package:kiosk/view/homepage.dart';
// // import 'package:provider/provider.dart';

// // class LanguageSelectedScreen extends StatefulWidget {
// //   const LanguageSelectedScreen({super.key, this.lanid});
// //   final int? lanid;
// //   @override
// //   State<LanguageSelectedScreen> createState() => _LanguageSelectedScreenState();
// // }

// // class _LanguageSelectedScreenState extends State<LanguageSelectedScreen> {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
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
// //             ],
// //           ),
// //         ),
// //         child: Stack(
// //           children: [
// //             Positioned(
// //               top: -60.h,
// //               right: -250.w,
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
// //               top: 470.h,
// //               left: -330.w,
// //               child: Container(
// //                 height: 202.h,
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
// //               top: 470.h,
// //               right: -330.w,
// //               child: Container(
// //                 height: 202.h,
// //                 width: 702.w,
// //                 decoration: BoxDecoration(
// //                   image: DecorationImage(
// //                     fit: BoxFit.fill,
// //                     image: AssetImage("assets/images/flwr.png"),
// //                   ),
// //                 ),
// //               ),
// //             ),
// //             Consumer<HomeProvider>(
// //               builder:
// //                   (context, home, child) => Column(
// //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                     children: [
// //                       Column(
// //                         children: [
// //                           Container(
// //                             height: 500.h,
// //                             decoration: BoxDecoration(
// //                               color: Colors.red,
// //                               border: Border.all(
// //                                 color: Colors.white,
// //                                 width: 10.h,
// //                               ),
// //                               borderRadius: BorderRadius.only(
// //                                 topLeft: Radius.circular(6.r),
// //                                 topRight: Radius.circular(6.r),
// //                                 bottomLeft: Radius.circular(113.r),
// //                                 bottomRight: Radius.circular(113.r),
// //                               ),
// //                               image: DecorationImage(
// //                                 fit: BoxFit.cover,
// //                                 image: AssetImage("assets/images/temple_diety_image.png"),
// //                               ),
// //                             ),
// //                           ),
// //                           10.verticalSpace,
// //                           Container(
// //                             decoration: BoxDecoration(
// //                               color: Colors.white,
// //                               borderRadius: BorderRadius.circular(45.r),
// //                             ),
// //                             child: Row(
// //                               mainAxisAlignment: MainAxisAlignment.center,
// //                               children: [
// //                                 Column(
// //                                   children: [
// //                                     Text(
// //                                       "Thiruvambady Krishna Temple",
// //                                       style: Fontpalette.brown70700,
// //                                     ),
// //                                     Text(
// //                                       "തിരുവമ്പാടി ശ്രീകൃഷ്ണ ക്ഷേത്രം",
// //                                       style: Fontpalette.grey45600,
// //                                     ),
// //                                   ],
// //                                 ).verticalPadding(30.h),
// //                               ],
// //                             ),
// //                           ),
// //                           60.verticalSpace,

// //                           Stack(
// //                             children: [
// //                               // Positioned(
// //                               //   top: 28.h,
// //                               //   right: 380.w,
// //                               //   child: Transform(
// //                               //     alignment: Alignment.center,
// //                               //     transform:
// //                               //         Matrix4.identity()..scale(
// //                               //           -1.0,
// //                               //           1.0,
// //                               //           1.0,
// //                               //         ), // Mirror horizontally
// //                               //     child: Container(
// //                               //       height: 80.h,
// //                               //       width: 220.w,
// //                               //       decoration: BoxDecoration(
// //                               //         image: DecorationImage(
// //                               //           fit: BoxFit.contain,
// //                               //           image: AssetImage(
// //                               //             "assets/images/sideflwr.png",
// //                               //           ),
// //                               //         ),
// //                               //       ),
// //                               //     ),
// //                               //   ),
// //                               // ),
// //                               // Positioned(
// //                               //   top: 28.h,
// //                               //   left: 380.w,
// //                               //   child: Container(
// //                               //     height: 80.h,
// //                               //     width: 220.w,
// //                               //     decoration: BoxDecoration(
// //                               //       image: DecorationImage(
// //                               //         fit: BoxFit.contain,
// //                               //         image: AssetImage("assets/images/sideflwr.png"),
// //                               //       ),
// //                               //     ),
// //                               //   ),
// //                               // ),
// //                               Column(
// //                                 children: [
// //                                   Row(
// //                                     mainAxisAlignment: MainAxisAlignment.center,
// //                                     children: [
// //                                       InkWell(
// //                                         onTap: () {
// //                                           home.clearStoredData();
// //                                           home.clearGrossAmount();
// //                                           navigatescrren(
// //                                             context: context,
// //                                             page: Bookpoojascreen(
// //                                               lanid: widget.lanid,
// //                                             ),
// //                                           );
// //                                         },
// //                                         child: Container(
// //                                           width: 600.w,
// //                                           decoration: BoxDecoration(
// //                                             color: HexColor("#EC5002"),
// //                                             borderRadius: BorderRadius.circular(
// //                                               27.r,
// //                                             ),
// //                                             border: Border.all(
// //                                               color: HexColor("#F8A300"),
// //                                               width: 4.h,
// //                                             ),
// //                                           ),
// //                                           height: 60.h,
// //                                           child: Center(
// //                                             child: Text(
// //                                               widget.lanid == 1
// //                                                   ? "Book a pooja"
// //                                                   : "ഒരു പൂജ ബുക്ക് ചെയ്യുക",
// //                                               style: Fontpalette.white45500,
// //                                             ),
// //                                           ),
// //                                         ),
// //                                       ),
// //                                     ],
// //                                   ),
// //                                   7.verticalSpace,
// //                                   Container(
// //                                     height: 1,
// //                                     width: 600.w,
// //                                     decoration: BoxDecoration(
// //                                       gradient: LinearGradient(
// //                                         colors: [
// //                                           Colors.white,
// //                                           HexColor("#EC5002"),
// //                                           Colors.white,
// //                                         ],
// //                                       ),
// //                                     ),
// //                                   ),
// //                                   7.verticalSpace,
// //                                   Row(
// //                                     mainAxisAlignment: MainAxisAlignment.center,

// //                                     children: [
// //                                       Container(
// //                                         decoration: BoxDecoration(
// //                                           color: HexColor("#EC5002"),
// //                                           borderRadius: BorderRadius.circular(
// //                                             27.r,
// //                                           ),
// //                                           border: Border.all(
// //                                             color: HexColor("#F8A300"),
// //                                             width: 4.h,
// //                                           ),
// //                                         ),
// //                                         height: 60.h,
// //                                         width: 600.w,
// //                                         child: Center(
// //                                           child: Text(
// //                                             widget.lanid == 1
// //                                                 ? "Donate"
// //                                                 : " ദാനം ചെയ്യുക",
// //                                             style: Fontpalette.white45500,
// //                                           ),
// //                                         ),
// //                                       ),
// //                                     ],
// //                                   ),
// //                                 ],
// //                               ).horizontalPadding(200.w),
// //                             ],
// //                           ),
// //                         ],
// //                       ),
// //                       Row(
// //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                         children: [
// //                           Container(
// //                             height: 107.h,
// //                             width: 500.w,
// //                             decoration: BoxDecoration(
// //                               image: DecorationImage(
// //                                 fit: BoxFit.contain,
// //                                 image: AssetImage(
// //                                   "assets/images/logowithname.png",
// //                                 ),
// //                               ),
// //                             ),
// //                           ),
// //                           Text(
// //                             "www.punnyamtemplesuite.com",
// //                             style: Fontpalette.brown30600,
// //                           ),
// //                         ],
// //                       ).horizontalPadding(100.w),
// //                     ],
// //                   ).horizontalPadding(90.w).topPadding(40.h).bottomPadding(5.h),
// //             ),
// //           ],
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
// import 'package:kiosk/view/muttarukkal_option_screen.dart';
// import 'package:provider/provider.dart';

// class LanguageSelectedScreen extends StatefulWidget {
//   const LanguageSelectedScreen({super.key, this.lanid});
//   final int? lanid;
//   @override
//   State<LanguageSelectedScreen> createState() => _LanguageSelectedScreenState();
// }

// class _LanguageSelectedScreenState extends State<LanguageSelectedScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
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
//             ],
//           ),
//         ),
//         child: Stack(
//           children: [
//             Positioned(
//               top: -60.h,
//               right: -250.w,
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
//               top: 470.h,
//               left: -330.w,
//               child: Container(
//                 height: 202.h,
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
//               top: 470.h,
//               right: -330.w,
//               child: Container(
//                 height: 202.h,
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
//               builder:
//                   (context, home, child) => Column(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Column(
//                         children: [
//                           Container(
//                             height: 500.h,
//                             decoration: BoxDecoration(
//                               color: Colors.red,
//                               border: Border.all(
//                                 color: Colors.white,
//                                 width: 10.h,
//                               ),
//                               borderRadius: BorderRadius.only(
//                                 topLeft: Radius.circular(6.r),
//                                 topRight: Radius.circular(6.r),
//                                 bottomLeft: Radius.circular(113.r),
//                                 bottomRight: Radius.circular(113.r),
//                               ),
//                               image: DecorationImage(
//                                 fit: BoxFit.cover,
//                                 image: AssetImage("assets/images/temple_diety_image.png"),
//                               ),
//                             ),
//                           ),
//                           10.verticalSpace,
//                           Container(
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(45.r),
//                             ),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Column(
//                                   children: [
//                                     Text(
//                                       "Thiruvambady Krishna Temple",
//                                       style: Fontpalette.brown70700,
//                                     ),
//                                     Text(
//                                       "തിരുവമ്പാടി ശ്രീകൃഷ്ണ ക്ഷേത്രം",
//                                       style: Fontpalette.grey45600,
//                                     ),
//                                   ],
//                                 ).verticalPadding(30.h),
//                               ],
//                             ),
//                           ),
//                           60.verticalSpace,

//                           Stack(
//                             children: [
//                               Column(
//                                 children: [
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       InkWell(
//                                         onTap: () {
//                                           home.clearStoredData();
//                                           home.clearGrossAmount();
//                                           navigatescrren(
//                                             context: context,
//                                             page: MuttarukkalOptionScreen(
//                                               lanid: widget.lanid,
//                                             ),
//                                           );
//                                         },
//                                         child: Container(
//                                           width: 600.w,
//                                           decoration: BoxDecoration(
//                                             color: HexColor("#EC5002"),
//                                             borderRadius: BorderRadius.circular(
//                                               27.r,
//                                             ),
//                                             border: Border.all(
//                                               color: HexColor("#F8A300"),
//                                               width: 4.h,
//                                             ),
//                                           ),
//                                           height: 60.h,
//                                           child: Center(
//                                             child: Text(
//                                               widget.lanid == 1
//                                                   ? "Book a pooja"
//                                                   : "ഒരു പൂജ ബുക്ക് ചെയ്യുക",
//                                               style: Fontpalette.white45500,
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   7.verticalSpace,
//                                   Container(
//                                     height: 1,
//                                     width: 600.w,
//                                     decoration: BoxDecoration(
//                                       gradient: LinearGradient(
//                                         colors: [
//                                           Colors.white,
//                                           HexColor("#EC5002"),
//                                           Colors.white,
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                   7.verticalSpace,
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       InkWell(
//                                         onTap: () {
//                                           home.clearStoredData();
//                                           home.clearGrossAmount();
//                                           navigatescrren(
//                                             context: context,
//                                             page: Bookpoojascreen(
//                                               lanid: widget.lanid,
//                                               isDonate: true,
//                                             ),
//                                           );
//                                         },
//                                         child: Container(
//                                           decoration: BoxDecoration(
//                                             color: HexColor("#EC5002"),
//                                             borderRadius: BorderRadius.circular(
//                                               27.r,
//                                             ),
//                                             border: Border.all(
//                                               color: HexColor("#F8A300"),
//                                               width: 4.h,
//                                             ),
//                                           ),
//                                           height: 60.h,
//                                           width: 600.w,
//                                           child: Center(
//                                             child: Text(
//                                               widget.lanid == 1
//                                                   ? "Donate"
//                                                   : " ദാനം ചെയ്യുക",
//                                               style: Fontpalette.white45500,
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ).horizontalPadding(200.w),
//                             ],
//                           ),
//                         ],
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Container(
//                             height: 107.h,
//                             width: 500.w,
//                             decoration: BoxDecoration(
//                               image: DecorationImage(
//                                 fit: BoxFit.contain,
//                                 image: AssetImage(
//                                   "assets/images/logowithname.png",
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Text(
//                             "www.punnyamtemplesuite.com",
//                             style: Fontpalette.brown30600,
//                           ),
//                         ],
//                       ).horizontalPadding(100.w),
//                     ],
//                   ).horizontalPadding(90.w).topPadding(40.h).bottomPadding(5.h),
//             ),
//           ],
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
// import 'package:provider/provider.dart';

// class LanguageSelectedScreen extends StatefulWidget {
//   const LanguageSelectedScreen({super.key, this.lanid});
//   final int? lanid;
//   @override
//   State<LanguageSelectedScreen> createState() => _LanguageSelectedScreenState();
// }

// class _LanguageSelectedScreenState extends State<LanguageSelectedScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
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
//             ],
//           ),
//         ),
//         child: Stack(
//           children: [
//             Positioned(
//               top: -60.h,
//               right: -250.w,
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
//               top: 470.h,
//               left: -330.w,
//               child: Container(
//                 height: 202.h,
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
//               top: 470.h,
//               right: -330.w,
//               child: Container(
//                 height: 202.h,
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
//               builder:
//                   (context, home, child) => Column(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Column(
//                         children: [
//                           Container(
//                             height: 500.h,
//                             decoration: BoxDecoration(
//                               color: Colors.red,
//                               border: Border.all(
//                                 color: Colors.white,
//                                 width: 10.h,
//                               ),
//                               borderRadius: BorderRadius.only(
//                                 topLeft: Radius.circular(6.r),
//                                 topRight: Radius.circular(6.r),
//                                 bottomLeft: Radius.circular(113.r),
//                                 bottomRight: Radius.circular(113.r),
//                               ),
//                               image: DecorationImage(
//                                 fit: BoxFit.cover,
//                                 image: AssetImage("assets/images/temple_diety_image.png"),
//                               ),
//                             ),
//                           ),
//                           10.verticalSpace,
//                           Container(
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(45.r),
//                             ),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Column(
//                                   children: [
//                                     Text(
//                                       "Thiruvambady Krishna Temple",
//                                       style: Fontpalette.brown70700,
//                                     ),
//                                     Text(
//                                       "തിരുവമ്പാടി ശ്രീകൃഷ്ണ ക്ഷേത്രം",
//                                       style: Fontpalette.grey45600,
//                                     ),
//                                   ],
//                                 ).verticalPadding(30.h),
//                               ],
//                             ),
//                           ),
//                           60.verticalSpace,

//                           Stack(
//                             children: [
//                               // Positioned(
//                               //   top: 28.h,
//                               //   right: 380.w,
//                               //   child: Transform(
//                               //     alignment: Alignment.center,
//                               //     transform:
//                               //         Matrix4.identity()..scale(
//                               //           -1.0,
//                               //           1.0,
//                               //           1.0,
//                               //         ), // Mirror horizontally
//                               //     child: Container(
//                               //       height: 80.h,
//                               //       width: 220.w,
//                               //       decoration: BoxDecoration(
//                               //         image: DecorationImage(
//                               //           fit: BoxFit.contain,
//                               //           image: AssetImage(
//                               //             "assets/images/sideflwr.png",
//                               //           ),
//                               //         ),
//                               //       ),
//                               //     ),
//                               //   ),
//                               // ),
//                               // Positioned(
//                               //   top: 28.h,
//                               //   left: 380.w,
//                               //   child: Container(
//                               //     height: 80.h,
//                               //     width: 220.w,
//                               //     decoration: BoxDecoration(
//                               //       image: DecorationImage(
//                               //         fit: BoxFit.contain,
//                               //         image: AssetImage("assets/images/sideflwr.png"),
//                               //       ),
//                               //     ),
//                               //   ),
//                               // ),
//                               Column(
//                                 children: [
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       InkWell(
//                                         onTap: () {
//                                           home.clearStoredData();
//                                           home.clearGrossAmount();
//                                           navigatescrren(
//                                             context: context,
//                                             page: Bookpoojascreen(
//                                               lanid: widget.lanid,
//                                             ),
//                                           );
//                                         },
//                                         child: Container(
//                                           width: 600.w,
//                                           decoration: BoxDecoration(
//                                             color: HexColor("#EC5002"),
//                                             borderRadius: BorderRadius.circular(
//                                               27.r,
//                                             ),
//                                             border: Border.all(
//                                               color: HexColor("#F8A300"),
//                                               width: 4.h,
//                                             ),
//                                           ),
//                                           height: 60.h,
//                                           child: Center(
//                                             child: Text(
//                                               widget.lanid == 1
//                                                   ? "Book a pooja"
//                                                   : "ഒരു പൂജ ബുക്ക് ചെയ്യുക",
//                                               style: Fontpalette.white45500,
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   7.verticalSpace,
//                                   Container(
//                                     height: 1,
//                                     width: 600.w,
//                                     decoration: BoxDecoration(
//                                       gradient: LinearGradient(
//                                         colors: [
//                                           Colors.white,
//                                           HexColor("#EC5002"),
//                                           Colors.white,
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                   7.verticalSpace,
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,

//                                     children: [
//                                       Container(
//                                         decoration: BoxDecoration(
//                                           color: HexColor("#EC5002"),
//                                           borderRadius: BorderRadius.circular(
//                                             27.r,
//                                           ),
//                                           border: Border.all(
//                                             color: HexColor("#F8A300"),
//                                             width: 4.h,
//                                           ),
//                                         ),
//                                         height: 60.h,
//                                         width: 600.w,
//                                         child: Center(
//                                           child: Text(
//                                             widget.lanid == 1
//                                                 ? "Donate"
//                                                 : " ദാനം ചെയ്യുക",
//                                             style: Fontpalette.white45500,
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ).horizontalPadding(200.w),
//                             ],
//                           ),
//                         ],
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Container(
//                             height: 107.h,
//                             width: 500.w,
//                             decoration: BoxDecoration(
//                               image: DecorationImage(
//                                 fit: BoxFit.contain,
//                                 image: AssetImage(
//                                   "assets/images/logowithname.png",
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Text(
//                             "www.punnyamtemplesuite.com",
//                             style: Fontpalette.brown30600,
//                           ),
//                         ],
//                       ).horizontalPadding(100.w),
//                     ],
//                   ).horizontalPadding(90.w).topPadding(40.h).bottomPadding(5.h),
//             ),
//           ],
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
import 'package:provider/provider.dart';

class LanguageSelectedScreen extends StatefulWidget {
  const LanguageSelectedScreen({super.key, this.lanid});
  final int? lanid;
  @override
  State<LanguageSelectedScreen> createState() => _LanguageSelectedScreenState();
}

class _LanguageSelectedScreenState extends State<LanguageSelectedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -60.h,
              right: -250.w,
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
              top: 470.h,
              left: -330.w,
              child: Container(
                height: 202.h,
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
              top: 470.h,
              right: -330.w,
              child: Container(
                height: 202.h,
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
              builder:
                  (context, home, child) => Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Container(
                            height: 500.h,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              border: Border.all(
                                color: Colors.white,
                                width: 10.h,
                              ),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(6.r),
                                topRight: Radius.circular(6.r),
                                bottomLeft: Radius.circular(113.r),
                                bottomRight: Radius.circular(113.r),
                              ),
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: AssetImage(
                                  "assets/images/temple_diety_image.png",
                                ),
                              ),
                            ),
                          ),
                          10.verticalSpace,
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(45.r),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      "Thiruvambady Krishna Temple",
                                      style: Fontpalette.brown70700,
                                    ),
                                    Text(
                                      "തിരുവമ്പാടി ശ്രീകൃഷ്ണ ക്ഷേത്രം",
                                      style: Fontpalette.grey45600,
                                    ),
                                  ],
                                ).verticalPadding(30.h),
                              ],
                            ),
                          ),
                          60.verticalSpace,

                          Stack(
                            children: [
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          home.clearStoredData();
                                          home.clearGrossAmount();
                                          // navigatescrren(
                                          //   context: context,
                                          //   page: MuttarukkalOptionScreen(
                                          //     lanid: widget.lanid,
                                          //   ),
                                          // );
                                          navigatescrren(
                                            context: context,
                                            page: Bookpoojascreen(
                                              lanid: widget.lanid,
                                            ),
                                          );
                                        },
                                        child: Container(
                                          width: 600.w,
                                          decoration: BoxDecoration(
                                            color: HexColor("#EC5002"),
                                            borderRadius: BorderRadius.circular(
                                              27.r,
                                            ),
                                            border: Border.all(
                                              color: HexColor("#F8A300"),
                                              width: 4.h,
                                            ),
                                          ),
                                          height: 60.h,
                                          child: Center(
                                            child: Text(
                                              widget.lanid == 1
                                                  ? "Book a pooja"
                                                  : "ഒരു പൂജ ബുക്ക് ചെയ്യുക",
                                              style: Fontpalette.white45500,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  7.verticalSpace,
                                  Container(
                                    height: 1,
                                    width: 600.w,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.white,
                                          HexColor("#EC5002"),
                                          Colors.white,
                                        ],
                                      ),
                                    ),
                                  ),
                                  7.verticalSpace,
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          home.clearStoredData();
                                          home.clearGrossAmount();
                                          navigatescrren(
                                            context: context,
                                            page: Bookpoojascreen(
                                              lanid: widget.lanid,
                                              isDonate: true,
                                            ),
                                          );
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: HexColor("#EC5002"),
                                            borderRadius: BorderRadius.circular(
                                              27.r,
                                            ),
                                            border: Border.all(
                                              color: HexColor("#F8A300"),
                                              width: 4.h,
                                            ),
                                          ),
                                          height: 60.h,
                                          width: 600.w,
                                          child: Center(
                                            child: Text(
                                              widget.lanid == 1
                                                  ? "Donate"
                                                  : "സംഭാവന",
                                              style: Fontpalette.white45500,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ).horizontalPadding(200.w),
                            ],
                          ),
                        ],
                      ),
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
                  ).horizontalPadding(90.w).topPadding(40.h).bottomPadding(5.h),
            ),
          ],
        ),
      ),
    );
  }
}

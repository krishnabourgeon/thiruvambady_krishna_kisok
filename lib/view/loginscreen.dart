import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kiosk/color_pallatte.dart';
import 'package:kiosk/extension.dart';
import 'package:kiosk/fontpallate.dart';
import 'package:kiosk/provider/auth_provider.dart';
import 'package:kiosk/provider/homeprovider.dart';
import 'package:kiosk/services/helpers.dart';
import 'package:kiosk/view/homepage.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final ValueNotifier<bool> isEnabled = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AuthProvider>(
        builder:
            (context, auth, child) => Container(
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
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Container(
                            height: 55.h,

                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(21.r),
                              border: Border.all(color: Colors.black),
                            ),
                            child: TextField(
                              controller: auth.loginUsernameController,
                              style: Fontpalette.blackinter50400,
                              textAlignVertical: TextAlignVertical.center,
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 12.h,
                                  horizontal: 40.w,
                                ),

                                hintText: "Email",
                                hintStyle: Fontpalette.blackinter50400,
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          10.verticalSpace,
                          Container(
                            height: 55.h,

                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(21.r),
                              border: Border.all(color: Colors.black),
                            ),
                            child: TextField(
                              obscureText: auth.visible,
                              controller: auth.loginPasswordController,
                              style: Fontpalette.blackinter50400,
                              textAlignVertical: TextAlignVertical.center,
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 12.h,
                                  horizontal: 40.w,
                                ),

                                suffixIcon: IconButton(
                                  icon: Icon(
                                    auth.visible
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                  onPressed: () => auth.updateVisibility(),
                                ),
                                hintText: "Password",
                                hintStyle: Fontpalette.blackinter50400,
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          20.verticalSpace,
                          ValueListenableBuilder<bool>(
                            valueListenable: isEnabled,
                            builder:
                                (context, value, child) => InkWell(
                                  onTap: () {
                                    if (auth
                                            .loginPasswordController
                                            .text
                                            .isEmpty ||
                                        auth
                                            .loginPasswordController
                                            .text
                                            .isEmpty) {
                                      Helpers.successToast("Field is  empty");
                                      return;
                                    }
                                    isEnabled.value = true;
                                    FocusScope.of(context).unfocus();
                                    auth.login(
                                      onSuccess: () async {
                                        final home =
                                            context.read<HomeProvider>();
                                        await home.getDeities();
                                        await home.getStars();

                                        home.getPaymentModes(
                                          onFailure:
                                              () => Helpers.successToast(
                                                'Error occurred while fetching payment modes ....!',
                                              ),
                                        );
                                        await home.getPoojas(
                                          deityId:
                                              home.deitiesResponse?.data![0].id
                                                  .toString(),
                                        );
                                        navigatescrren(
                                          page: MyHomePage(),
                                          context: context,
                                        ).then((value) async {
                                          await home.getCounter();
                                          isEnabled.value = false;
                                          auth.clearValues();
                                        });
                                      },
                                      onFailure: () {
                                        isEnabled.value = false;
                                        Helpers.successToast(
                                          auth.errorToast ?? '',
                                        );
                                      },
                                    );
                                  },

                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              27.r,
                                            ),
                                            color: HexColor("#EC5002"),
                                          ),
                                          child: Center(
                                            child:
                                                isEnabled.value == true
                                                    ? CircularProgressIndicator(
                                                      color: Colors.white,
                                                    )
                                                    : Text(
                                                      "Continue",
                                                      style:
                                                          Fontpalette
                                                              .white50500,
                                                    ),
                                          ).verticalPadding(20.h),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                          ),
                        ],
                      ),
                      60.verticalSpace,
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
                ],
              ),
            ),
      ),
    );
  }
}

navigatescrren({BuildContext? context, required page}) {
  Navigator.of(context!).push(
    PageRouteBuilder(
      transitionDuration: Duration(milliseconds: 500),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    ),
  );
}

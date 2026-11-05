import 'package:flutter/cupertino.dart';
import 'package:async/async.dart';
import 'package:kiosk/services/helpers.dart';
import 'package:kiosk/models/login_response_model.dart';
import 'package:kiosk/services/provider_helper_class.dart';
import 'package:kiosk/services/shared_preference_helper.dart';

class AuthProvider extends ProviderHelperClass with ChangeNotifier {
  bool visible=true;
  updateVisibility(){
    visible=!visible;
    notifyListeners();
  }
  TextEditingController loginUsernameController = TextEditingController();
  TextEditingController loginPasswordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController punnyamCodeController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  String? errorToast;
  String? userNameValidationMessage;
  String? nameValidationMessage;
  String? emailValidationMessage;
  String? punnyamCodeValidationMessage;
  String? passwordValidationMessage;
  String? confirmPasswordValidationMessage;
  bool isLoginFormValidated = false;
  bool isRegisterFormValidated = false;
  bool isRememberCredentials = true;
  // Future<void> login({Function? onSuccess, Function? onFailure}) async {
  //   // updateLoadState(LoaderState.loading);
  //   Result res;
  //   try {
  //     res = await serviceConfig.login(
  //       email: loginUsernameController.text,
  //       password: loginPasswordController.text,
  //     );
  //   } catch (e) {
  //     // Network / server errors (e.g. server unreachable) - show a message
  //     // instead of an unhandled exception.
  //     debugPrint('Login error: $e');
  //     Helpers.successToast('Unable to reach server. Please try again later');
  //     res = Result.error(e);
  //   }
  //   if (res.isValue) {
  //     LoginResponseModel loginResponseModel = res.asValue!.value;
  //     await SharedPreferenceHelper.saveToken(loginResponseModel.token ?? '');

  //     if (onSuccess != null) onSuccess();
  //     // updateLoadState(LoaderState.loaded);
  //   } else {
  //     errorToast = 'Login failed';
  //     if (onFailure != null) onFailure();
  //     // updateLoadState(LoaderState.loaded);
  //   }
  //   notifyListeners();
  // }



    Future<void> login({Function? onSuccess, Function? onFailure}) async {
    // updateLoadState(LoaderState.loading);
    var res = await serviceConfig.login(
      email: loginUsernameController.text,
      password: loginPasswordController.text,
    );
    if (res.isValue) {
      LoginResponseModel loginResponseModel = res.asValue!.value;
      await SharedPreferenceHelper.saveToken(loginResponseModel.token ?? '');

      if (onSuccess != null) onSuccess();
      // updateLoadState(LoaderState.loaded);
    } else {
      errorToast = 'Login failed';
      if (onFailure != null) onFailure();
      // updateLoadState(LoaderState.loaded);
    }
    notifyListeners();
  }

 
 

  updateLoginFormState() {
    if (loginUsernameController.text.isNotEmpty &&
        loginPasswordController.text.isNotEmpty &&
        userNameValidationMessage == null) {
      isLoginFormValidated = true;
    } else {
      isLoginFormValidated = false;
    }
    debugPrint('is login form validated $isLoginFormValidated');
    notifyListeners();
  }

  updateRegisterFormState() {
    if (nameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        punnyamCodeController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        confirmPasswordController.text.isNotEmpty &&
        nameValidationMessage == null &&
        emailValidationMessage == null &&
        punnyamCodeValidationMessage == null &&
        passwordValidationMessage == null &&
        confirmPasswordValidationMessage == null) {
      isRegisterFormValidated = true;
    } else {
      isRegisterFormValidated = false;
    }
    notifyListeners();
  }

  updateRememberMeValue(bool value) {
    isRememberCredentials = value;
    notifyListeners();
  }

  clearValues() {
    nameController.clear();
    emailController.clear();
    punnyamCodeController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    loginUsernameController.clear();
    loginPasswordController.clear();
    nameValidationMessage = null;
    emailValidationMessage = null;
    punnyamCodeValidationMessage = null;
    passwordValidationMessage = null;
    confirmPasswordValidationMessage = null;
    userNameValidationMessage = null;
    notifyListeners();
  }

  @override
  void updateLoadState(LoaderState state) {
    loaderState = state;
    notifyListeners();
  }
}

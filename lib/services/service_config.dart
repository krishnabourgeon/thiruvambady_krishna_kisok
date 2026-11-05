import 'package:flutter/foundation.dart';
import 'package:async/async.dart';
import 'package:kiosk/models/counters_model.dart';
import 'package:kiosk/models/dieties_response_model.dart';
import 'package:kiosk/models/error_response_model.dart';
import 'package:kiosk/models/login_response_model.dart';
import 'package:kiosk/models/payment_mode_response.dart';
import 'package:kiosk/models/pooja_details_model.dart';
import 'package:kiosk/models/pooja_response_model.dart';
import 'package:kiosk/models/preview_bill_response.dart';
import 'package:kiosk/models/save_bill_body.dart';
import 'package:kiosk/models/save_bill_response.dart';
import 'package:kiosk/models/starts_response_model.dart';
import 'package:kiosk/services/app_config.dart';
import 'base_client.dart';

class ServiceConfig {
  Future<Result> login({String? email, String? password}) async {
    Map<String, dynamic> body = {
      'email': email ?? '',
      'password': password ?? '',
    };
    Result res = await BaseClient.post('auth/login', body: body);
    if (res.isError) {
      ErrorResponseModel errorResponseModel = ErrorResponseModel(
        errorMessage: 'OOps...!, login failed',
      );
      return Result.error(errorResponseModel);
    } else {
      var response = res.asValue!.value;
      LoginResponseModel loginResponseModel = LoginResponseModel.fromJson(
        response,
      );
      return (loginResponseModel.status ?? false)
          ? Result.value(loginResponseModel)
          : Result.error(loginResponseModel);
    }
  }

  Future<Result> getDeities() async {
    Result res = await BaseClient.get('deities');
    if (res.isError) {
      ErrorResponseModel errorResponseModel = ErrorResponseModel(
        errorMessage: 'OOps...!, Something went wrong',
      );
      return Result.error(errorResponseModel);
    } else {
      var response = res.asValue!.value;
      debugPrint('-----------------deities response $response-------------------');
      print("-----------------deities response $response-------------------");
      DeitiesResponse deitiesResponse = DeitiesResponse.fromJson(response);
      return (deitiesResponse.status ?? false)
          ? Result.value(deitiesResponse)
          : Result.error(deitiesResponse);
    }
  }

  Future<Result> getStarts() async {
    Result res = await BaseClient.get('stars');
    if (res.isError) {
      ErrorResponseModel errorResponseModel = ErrorResponseModel(
        errorMessage: 'OOps...!, Something went wrong',
      );
      return Result.error(errorResponseModel);
    } else {
      var response = res.asValue!.value;
      debugPrint('stars response $response');
      StarsResponse starsResponse = StarsResponse.fromJson(response);
      return (starsResponse.status ?? false)
          ? Result.value(starsResponse)
          : Result.error(starsResponse);
    }
  }

  Future<Result> getPoojas(String deityId) async {
    Result res = await BaseClient.post(
      'deity/poojas',
      body: {'deity': deityId},
    );
    if (res.isError) {
      ErrorResponseModel errorResponseModel = ErrorResponseModel(
        errorMessage: 'OOps...!, Something went wrong',
      );
      return Result.error(errorResponseModel);
    } else {
      var response = res.asValue!.value;
      debugPrint('pooja response $response');
      PoojaResponse poojaResponse = PoojaResponse.fromJson(response);

      return (poojaResponse.status ?? false)
          ? Result.value(poojaResponse)
          : Result.error(poojaResponse);
    }
  }

  Future<Result> getPoojaDetails(int poojaid) async {
    Result res = await BaseClient.get('getpoojadetails?pooja_id=$poojaid');
    if (res.isError) {
      ErrorResponseModel errorResponseModel = ErrorResponseModel(
        errorMessage: 'OOps...!, Something went wrong',
      );
      return Result.error(errorResponseModel);
    } else {
      var response = res.asValue!.value;
      debugPrint('pooja details response $response');
      PoojaDetailsModel poojaDetailResponse = PoojaDetailsModel.fromJson(response);
      return (poojaDetailResponse.status ?? false)
          ? Result.value(poojaDetailResponse)
          : Result.error(poojaDetailResponse);
    }
  }


  Future<Result> getCounters() async {
    Result res = await BaseClient.post('counters');
    if (res.isError) {
      ErrorResponseModel errorResponseModel = ErrorResponseModel(
        errorMessage: 'OOps...!, Something went wrong',
      );
      return Result.error(errorResponseModel);
    } else {
      var response = res.asValue!.value;
      debugPrint('counters response $response');
      CounterModel counterResponse = CounterModel.fromJson(response);
      return (counterResponse.status ?? false)
          ? Result.value(counterResponse)
          : Result.error(counterResponse);
    }
  }

  Future<Result> getPreviewBill({
    List<PoojaDetails>? pooja,
    totalamount,
  }) async {
    final body = {
      "customer_id": 0,
      "counter_id": AppConfig.counterID,
      "paymentMode": null,
      "billAmount": totalamount.toString(),
      "paidAmount": null,
      "pooja_details": pooja,
    };
    Result res = await BaseClient.post('preview-bill', body: body);

    if (res.isError) {
      ErrorResponseModel errorResponseModel = ErrorResponseModel(
        errorMessage: 'OOps...!, Something went wrong',
      );

      return Result.error(errorResponseModel);
    } else {
      var response = res.asValue!.value;
      debugPrint('preview response $response');
      PreviewBillResponse previewBillResponse = PreviewBillResponse.fromJson(
        response,
      );
      return (previewBillResponse.status ?? false)
          ? Result.value(previewBillResponse)
          : Result.error(previewBillResponse);
    }
  }

  Future<Result> saveBill(SaveBillBody saveBillBody) async {
    if (kDebugMode) {
      print("savebill..............${saveBillBody.toJson()}");
    }
    Result res = await BaseClient.post(
      'save-bill',
      body: saveBillBody.toJson(),
    );
    if (res.isError) {
      ErrorResponseModel errorResponseModel = ErrorResponseModel(
        errorMessage: 'OOps...!, Something went wrong',
      );
      return Result.error(errorResponseModel);
    } else {
      var response = res.asValue!.value;
print(response);
      SaveBillResponse saveBillResponse = SaveBillResponse.fromJson(response);
      return (saveBillResponse.status ?? false)
          ? Result.value(saveBillResponse)
          : Result.error(saveBillResponse);
    }
  }

  Future<Result> getPaymentModes() async {
    Result res = await BaseClient.get('payment-modes');
    if (res.isError) {
      ErrorResponseModel errorResponseModel = ErrorResponseModel(
        errorMessage: 'OOps...!, Something went wrong',
      );
      return Result.error(errorResponseModel);
    } else {
      var response = res.asValue!.value;
      print("payment_modes response $response");
      PaymentModeResponse paymentModeResponse = PaymentModeResponse.fromJson(
        response,
      );
      return (paymentModeResponse.status ?? false)
          ? Result.value(paymentModeResponse)
          : Result.error(paymentModeResponse);
    }
  }
}

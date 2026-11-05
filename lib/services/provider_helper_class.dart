import 'package:kiosk/services/service_config.dart';

enum LoaderState { initial, loaded, loading, error, networkErr, noData }

abstract class ProviderHelperClass {
  final ServiceConfig serviceConfig = ServiceConfig();
  LoaderState loaderState = LoaderState.initial;
  int apiCallCount = 0;
  bool btnLoader = false;
  void updateLoadState(LoaderState state);
  void updateBtnLoader(bool value) {}
}

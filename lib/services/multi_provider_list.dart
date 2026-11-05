import 'package:kiosk/provider/auth_provider.dart';
import 'package:kiosk/provider/homeprovider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class MultiProviderList {
  static List<SingleChildWidget> providerList = [
    // ChangeNotifierProvider(create: (_) => BillingProvider()),
    ChangeNotifierProvider(create: (_) => AuthProvider()),
    ChangeNotifierProvider(create: (_) => HomeProvider()),
    // ChangeNotifierProvider(create: (_) => CreateCustomerProvider()),
    // ChangeNotifierProvider(create: (_) => BillDetailprovider()),
    // ChangeNotifierProvider(create: (_) => PreviewBillProvider())
  ];
}

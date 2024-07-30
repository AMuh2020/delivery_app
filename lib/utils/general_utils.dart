import 'package:delivery_app/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

// clears cart
void clearCheckout() {
  final checkoutInstance = CheckoutModel.instance;
  checkoutInstance.clearCheckoutItems();
  print('cleared checkout');
}

// Clear all preferences - useful for logout
void clearPreferences() async{
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
  print('cleared preferences');
}

// list of things stored in shared preferences
// auth_token
// user_id
// lat_long
// address
// cart - implement

// store auth token
void storeFCMToken(String token) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('fcm_token', token);
}

// clear address
void clearAddress() {
  final addressInstance = AddressModel.instance;
  addressInstance.setAddress(null);
  print('cleared address');
}
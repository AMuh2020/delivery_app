import 'package:delivery_app/main.dart';
import 'package:shared_preferences/shared_preferences.dart';


void clearCheckout() {
  final checkoutInstance = CheckoutModel.instance;
  checkoutInstance.clearCheckoutItems();
  print('cleared checkout');
}

// Clear all preferences - useful for logout
void clearPreferences() async{
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
}

// list of things stored in shared preferences
// auth_token
// user_id
// lat_long
// address
// cart - implement



import 'package:delivery_app/auth/login_or_register.dart';
import 'package:delivery_app/models/food.dart';
import 'package:flutter/material.dart';

// import 'src/app.dart';
// import 'src/settings/settings_controller.dart';
// import 'src/settings/settings_service.dart';
import 'package:provider/provider.dart';
import 'package:delivery_app/themes/theme_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';



void main() async {
  // Set up the SettingsController, which will glue user settings to multiple
  // Flutter Widgets.
  // final settingsController = SettingsController(SettingsService());

  // Load the user's preferred theme while the splash screen is displayed.
  // This prevents a sudden theme change when the app is first displayed.
  // await settingsController.loadSettings();

  // Run the app and pass in the SettingsController. The app listens to the
  // SettingsController for changes, then passes it further down to the
  // SettingsView.
  // runApp(MyApp(settingsController: settingsController));
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => CheckoutModel()),
        ChangeNotifierProvider(create: (context) => AddressModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Delivery App',
      theme: Provider.of<ThemeProvider>(context).themeData,
      home: const LoginOrRegister(),
    );
  }
}

class CheckoutModel extends ChangeNotifier {
  // Private constructor
  CheckoutModel._internal();

  // The single instance of CheckoutModel
  static final CheckoutModel _instance = CheckoutModel._internal();
  factory CheckoutModel() {
    return _instance;
  }

  // Getter to access the single instance of CheckoutModel
  static CheckoutModel get instance => _instance;

  // array for checkout items
  List<Food> checkoutItems = [];

  void add(Food item) {
    checkoutItems.add(item);
    notifyListeners();
  }
  void remove(Food item) {
    checkoutItems.remove(item);
    notifyListeners();
  }
  int get subtotal => checkoutItems.fold(0, (sum, item) => sum + item.price * item.quantity);

  void increaseQuantity(Food item) {
    item.quantity++;
    notifyListeners();
  }
  void decreaseQuantity(Food item) {
    if (item.quantity > 1) {
      item.quantity--;
      notifyListeners();
    }
  }
  void clearCheckoutItems() {
    checkoutItems.clear();
    notifyListeners();
  }
}

class AddressModel with ChangeNotifier {
  String? _address;

  // Singleton
  static final AddressModel _instance = AddressModel._internal();
  factory AddressModel() {
    return _instance;
  }
  AddressModel._internal();

  // Singleton accessor
  static AddressModel get instance => _instance;

  String? get address => _address;

  void setAddress(String? newAddress) {
    _address = newAddress;
    notifyListeners();
  }
}
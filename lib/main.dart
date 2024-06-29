

import 'package:delivery_app/auth/login_or_register.dart';
import 'package:delivery_app/models/food.dart';
import 'package:flutter/material.dart';

// import 'src/app.dart';
// import 'src/settings/settings_controller.dart';
// import 'src/settings/settings_service.dart';
import 'package:provider/provider.dart';
import 'package:delivery_app/themes/theme_provider.dart';

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
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => CheckoutModel()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
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
}
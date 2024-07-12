

import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:delivery_app/auth/login_or_register.dart';
import 'package:delivery_app/models/food.dart';
import 'package:delivery_app/utils/general_utils.dart';
import 'package:flutter/material.dart';

// import 'src/app.dart';
// import 'src/settings/settings_controller.dart';
// import 'src/settings/settings_service.dart';
import 'package:provider/provider.dart';
import 'package:delivery_app/themes/theme_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:delivery_app/firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

// setup for firebase messaging
void _configureFCMListeners(){
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    MessageService().broadcastMessage(message);
    if (message.data['type'] == 'order_status_update') {
      

    }

    // if (message.notification != null) {
    //   print('Message also contained a notification: ${message.notification}');
    // }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('Handling a message ${message.messageId}');
    MessageService().broadcastMessage(message);
    if (message.data['type'] == 'order') {
      // handle order message
      // order arrived or order status changed e.g. your driver is on the way
      // navigate to order page
      // Navigator.push(context, MaterialPageRoute(builder: (context) => OrderPage(orderId: message.data['order_id'])));
    } else if (message.data['type'] == 'reminder') {
      // store cart on server?? can also do checks to ensure cart is still valid
      
    }
  });

  // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //   print('Got a message whilst in the foreground!');
  //   print('Message data: ${message.data}');

  //   if (message.notification != null) {
  //     print('Message also contained a notification: ${message.notification}');
  //   }
  // });
  // FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  
}

// Future<void> _handleMessage(RemoteMessage message) async {
//   print('Handling a message ${message.messageId}');
  
//   return;
// }

void _initializeFCM() {
  FirebaseMessaging.instance.requestPermission();
  FirebaseMessaging.instance.getToken().then((token) {
    print('FCM token: $token');
    storeFCMToken('$token');
  });
  
  
  // for apple devices check for apns
  final apnsToken = FirebaseMessaging.instance.getAPNSToken();
  if (apnsToken != null) {
    apnsToken.then((token) {
      print('APNS token: $token');
    });
  } else {
    print('APNS token is null');
  }
}



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
  _initializeFCM();
  _configureFCMListeners();
  
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
  Decimal get subtotal => checkoutItems.fold<Decimal>(Decimal.zero, (sum, item) => sum + item.price * Decimal.fromInt(item.quantity));

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

class MessageService {
  MessageService._privateConstructor();

  static final MessageService _instance = MessageService._privateConstructor();

  factory MessageService() {
    return _instance;
  }

  final StreamController<RemoteMessage> _messageStreamController = StreamController.broadcast();

  Stream<RemoteMessage> get messageStream => _messageStreamController.stream;

  void dispose() {
    _messageStreamController.close();
  }

  void broadcastMessage(RemoteMessage message) {
    _messageStreamController.sink.add(message);
  }
}
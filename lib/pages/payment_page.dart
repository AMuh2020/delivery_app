import 'package:delivery_app/pages/home_page.dart';
import 'package:delivery_app/pages/orders_page.dart';
import 'package:delivery_app/utils/general_utils.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:delivery_app/globals.dart' as globals;
import 'dart:convert';

class PaymentPage extends StatefulWidget {
  final int orderId;
  const PaymentPage({
    super.key,
    required this.orderId,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  WebViewController controller = WebViewController();
  late String reference;

  // initialize transaction
  Future<List<dynamic>> serverBeginInitialization() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // contact server for initialization
    final response = await http.post(
      Uri.parse('${globals.serverUrl}/api/init_transaction'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Token ${prefs.getString('auth_token')}',
      },
      body: json.encode({
        'user_id': prefs.getInt('user_id'),
        'order_id': widget.orderId,
      }),
    );
    String authURL = '';
    if (response.statusCode == 201) {
      // If the server returns an OK response, then parse the JSON.
      final parsed = jsonDecode(response.body);
      print(parsed);
      authURL = parsed['auth_url'];
      print(authURL);
      return [authURL, parsed['reference']];
    } else {
      // If that response was not OK, throw an error.
      // throw Exception('Failed to initialize transaction');
      Navigator.pop(context);
      return [];
    }
  }
  Future<void> beginInitialization() async {

    // contact server to do initialization, returns auth url
    List<dynamic> data = await serverBeginInitialization();
    if (data.isEmpty) {
      return;
    }
    String authURL = data[0];
    reference = data[1];
    // initialize webview
    controller
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setUserAgent('Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4324.96 Mobile Safari/537.36')
    ..setBackgroundColor(const Color(0x00000000))
    ..setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          // Update loading bar.
        },
        onPageStarted: (String url) {},
        onPageFinished: (String url) {},
        onHttpError: (HttpResponseError error) {
          // showDialog(
          //   context: context,
          //   builder: (BuildContext context) {
          //     return AlertDialog(
          //       title: const Text('HTTP Error'),
          //       content: Text('An error occurred: ${error} - {error}'),
          //       actions: <Widget>[
          //         TextButton(
          //           child: const Text('OK'),
          //           onPressed: () {
          //             Navigator.of(context).pop(); // Close the dialog
          //           },
          //         ),
          //       ],
          //     );
          //   },
          // );
        },
        onWebResourceError: (WebResourceError error) {
          // showDialog(
          //   context: context,
          //   builder: (BuildContext context) {
          //     return AlertDialog(
          //       title: const Text('Web Resource Error'),
          //       content: Text('An error occurred: ${error.errorCode} - ${error.description}'),
          //       actions: <Widget>[
          //         TextButton(
          //           child: const Text('OK'),
          //           onPressed: () {
          //             Navigator.of(context).pop(); // Close the dialog
          //           },
          //         ),
          //       ],
          //     );
          //   },
          // );
        },
        onNavigationRequest: (NavigationRequest request) {
          print('Navigating to: ${request.url}');
          // check if the transaction was cancelled - cancel url
          if(request.url.startsWith('${globals.serverUrl}/api/transaction/cancel/${reference}')) {
            print('Transaction Cancelled');
            cancelTransaction(reference);
            Navigator.of(context).pop(); //close webview
          }
          if(request.url.startsWith('https://standard.paystack.co/close')) {
            print('Transaction 3D Secure Completed');
            clearCheckout();
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomePage()), // Replace NewPage with the page you want to navigate to
              (Route<dynamic> route) => false, // This condition ensures all previous routes are removed
            );
          }
          // callback url
          if (request.url.startsWith('${globals.serverUrl}/api/transaction/success/${reference}')) {
            print('Payment Successful');
            verifyTransaction(reference);
            clearCheckout();
            // clear entire navigation stack
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()), // Replace NewPage with the page you want to navigate to
              (Route<dynamic> route) => false, // This condition ensures all previous routes are removed
            );
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => OrdersPage()));
            // send a request to the server to verify the transaction

            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ),
    )
    ..loadRequest(Uri.parse(authURL));
  }

  Future<void> verifyTransaction(String reference) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance(); 
    final response = await http.post(
      Uri.parse('${globals.serverUrl}/api/verify_transaction'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Token ${prefs.getString('auth_token')}',
      },
      body: json.encode({
        'reference': reference,
      }),
    );
    if (response.statusCode == 200) {
      // If the server returns an OK response, then parse the JSON.
      final parsed = jsonDecode(response.body);
      print(parsed);
      return;
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to verify transaction');
    }
  }

  Future<void> cancelTransaction(String reference) async {
    print('Cancelling Transaction');
    final SharedPreferences prefs = await SharedPreferences.getInstance(); 
    final response = await http.post(
      Uri.parse('${globals.serverUrl}/api/transaction/cancel/${reference}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Token ${prefs.getString('auth_token')}',
      },
      body: json.encode({
        'user_id': prefs.getInt('user_id'),
        'reference': reference,
      }),
    );
    if (response.statusCode == 201) {
      // If the server returns an OK response, then parse the JSON.
      final parsed = jsonDecode(response.body);
      print('Transaction Cancelled');
      print(parsed);
      return;
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to cancel transaction');
    }
  }

  @override
  void initState() {
    super.initState();
    beginInitialization();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            cancelTransaction(reference);
            // pop twice to get to the cart page
            Navigator.pop(context);
            Navigator.pop(context);
          },
        ),
      ),
      body: WebViewWidget(
        controller: controller,
      ),
    );
  }
}
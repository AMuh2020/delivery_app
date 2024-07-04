// this page is for contacting the restaurant to see if they can take the order
import 'package:delivery_app/components/current_location.dart';
import 'package:delivery_app/main.dart';
import 'package:delivery_app/pages/payment_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:delivery_app/globals.dart' as globals;
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class BeforePaymentPage extends StatefulWidget {
  final int orderId;
  const BeforePaymentPage({
    super.key,
    required this.orderId,
  });

  @override
  State<BeforePaymentPage> createState() => _BeforePaymentPageState();
}

class _BeforePaymentPageState extends State<BeforePaymentPage> {
  Timer? _timer;
  String message = 'Please wait while we check if the restaurant can accept your order.';

  final addressInstance = AddressModel.instance;

  @override
  void initState() {
    super.initState();
    _startPolling();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startPolling() {
    const period = Duration(seconds: 5);
    _timer = Timer.periodic(period, (timer) async {
      final status = await checkOrderStatus('${widget.orderId}');
      print(status);
      if (status == 'accepted') {
        timer.cancel();
        // // pop to cart page - this is so that the user can't come back to this page
        // Navigator.of(context).pop();
        // // then navigate to payment page
        print('Order accepted');
        final locationConfirmed = await locationConfirmDialog() ?? false;
        if (locationConfirmed) {
          print('Location confirmed');
          if (context.mounted) {
            print('Navigating to payment page');
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PaymentPage(orderId: widget.orderId),
              ),
            );
          }
        }
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => PaymentPage(orderId: widget.orderId),
        //   ),
        // );
      } else if (status == 'rejected') {
        timer.cancel();
        setState(() {
          message = 'Order was rejected by the restaurant';
        });
      } else if (status == 'error') {
        timer.cancel();
        setState(() {
          message = 'There was an error checking the order status';
        });
      }
    });
  }

  Future<String> checkOrderStatus(String orderId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await http.post(
      Uri.parse('${globals.serverUrl}/api/orders/accept_check/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Token ${prefs.getString('auth_token')}',
      },
      body: jsonEncode({
        'order_id': orderId,
      }),
    );
    final parsed = jsonDecode(response.body);
    print(parsed);


    // If the server returns an OK response then the order was accepted
    if (response.statusCode == 200) {
      if (parsed['message'] == 'Order accepted') {
        return 'accepted';
      } else if (parsed['message'] == 'Order rejected') {
        return 'rejected';
      }
      return 'accepted';
    } else if (response.statusCode == 202) {
      return 'pending';
    } else {
      return 'error';
    }
  }

  Future<void> cancelOrder() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await http.post(
      Uri.parse('${globals.serverUrl}/api/orders/cancel_order/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Token ${prefs.getString('auth_token')}',
      },
      body: jsonEncode({
        'order_id': widget.orderId,
      }),
    );
    if (response.statusCode == 200) {
      // If the server returns an OK response, then parse the JSON.
      final parsed = jsonDecode(response.body);
      print(parsed);
      return;
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to cancel order');
    }
  }

  Future<bool?> _showBackDialog() {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Order?'),
        content: const Text('Are you sure you want to cancel the order?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }
  Future<bool?> locationConfirmDialog() {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Please confirm your location'),
        content: const CurrentLocation(),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) {
          cancelOrder();
          return;
        }
        final shouldLeave = await _showBackDialog() ?? false;
        if (shouldLeave && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Pre Payment'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Order ID: ${widget.orderId}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              // location
              // Text(
              //   'Address: ${addressInstance.address}',
              //   style: Theme.of(context).textTheme.bodyLarge,
              // ),
              Text(
                '$message',
              ),
              const CircularProgressIndicator(),
              const Spacer()
            ],
          ),
        ),
      ),
    );
  }
}
// this page is for contacting the restaurant to see if they can take the order
import 'package:delivery_app/components/current_location.dart';
import 'package:delivery_app/main.dart';
import 'package:delivery_app/pages/payment_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:delivery_app/globals.dart' as globals;
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class BeforePaymentPage extends StatefulWidget {
  final int orderId;
  final double serviceFee;
  final double deliveryFee;
  final double subtotal;
  final double total;
  const BeforePaymentPage({
    super.key,
    required this.orderId,
    required this.serviceFee,
    required this.deliveryFee,
    required this.subtotal,
    required this.total,
  });

  @override
  State<BeforePaymentPage> createState() => _BeforePaymentPageState();
}

class _BeforePaymentPageState extends State<BeforePaymentPage> {
  Timer? _timer;
  String message = 'Please wait while we check if the restaurant can accept your order.';
  Widget messageWidget = const Column(
    children: [
      Text(
        'Please wait while we check if the restaurant can accept your order.',
      ),
      Center(child: CircularProgressIndicator()),
    ],
  );
  bool restaurantAccept = false;

  final addressInstance = AddressModel.instance;

  StreamSubscription<RemoteMessage>? _messageSubscription;

  @override
  void initState() {
    super.initState();
    _messageSubscription = MessageService().messageStream.listen((RemoteMessage message) {
      // Handle the message as needed for this specific page
      print("Message received on Specific Page: ${message.data}");
      print(message.data['type']);
      if (message.data['type'] == 'order_status_update') {
        print('next');
        if (message.data['status'] == 'cooking') {
          print('Order accepted');
          setState(() {
            messageWidget = const Column(
              children: [
                Text(
                  'Order was accepted by the Restaurant. Proceed to payment',
                ),
              ],
            );
            restaurantAccept = true;
          });
        } else if (message.data['status'] == 'rejected') {
          setState(() {
            messageWidget = const Column(
              children: [
                Text(
                  'Order was rejected by the restaurant. Reason: ...',
                ),
              ],
            );
          });
        }
      }
    });
    // _startPolling();
  }

  @override
  void dispose() {
    _messageSubscription?.cancel();
    // _timer?.cancel();
    super.dispose();
  }

  // polls the server for update on order, change to FCM??
  void _startPolling() {
    const period = Duration(seconds: 5);
    _timer = Timer.periodic(period, (timer) async {
      final status = await checkOrderStatus('${widget.orderId}');
      print(status);
      if (status == 'accepted') {
        timer.cancel();
        print('Order accepted');
          setState(() {
          messageWidget = const Column(
            children: [
              Text(
                'Order was accepted by the Restaurant. Proceed to payment',
              ),
            ],
          );
          restaurantAccept = true;
        });
      } else if (status == 'rejected') {
        timer.cancel();
        setState(() {
          messageWidget = const Column(
            children: [
              Text(
                'Order was rejected by the restaurant. Reason: ...',
              ),
            ],
          );
        });
      } else if (status == 'error') {
        timer.cancel();
        setState(() {
          messageWidget = const Column(
            children: [
              Text(
                'There was an error checking the order status, please cancel order and order again',
              ),
            ],
          );
        });
      }
    });
  }

  // sends the check order request
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

  // sends cancel order http request to server to delete from db
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
                style: Theme.of(context).textTheme.titleLarge,
              ),
              // location
              // Text(
              //   'Address: ${addressInstance.address}',
              //   style: Theme.of(context).textTheme.bodyLarge,
              // ),
              messageWidget,
              Divider(),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Subtotal'),
                        Text('${widget.subtotal}')
                      ],
                    ),
                    Text('Fees'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Service'),
                        Text('${widget.serviceFee}')
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Delivery'),
                        Text('${widget.deliveryFee}')
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total',
                          style:  Theme.of(context).textTheme.bodyLarge,
                        ),
                        Text(
                          '${widget.total}',
                          style: Theme.of(context).textTheme.bodyLarge,
                        )
                      ],
                    ),
                  ]
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: restaurantAccept ? () async { //if condition isn't met button is null and unselectable
                        // final locationConfirmed = await locationConfirmDialog() ?? false;
                        if (context.mounted) {
                          print('Location confirmed');
                          print('Navigating to payment page');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PaymentPage(orderId: widget.orderId),
                            ),
                          );
                        }
                        return;
                      } : null,
                      child: Text('Proceed to payment')
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
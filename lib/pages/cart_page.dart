// this page is the cart page where users can view their cart and proceed to checkout
import 'package:delivery_app/main.dart';
import 'package:delivery_app/models/food.dart';
import 'package:delivery_app/pages/payment_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:delivery_app/globals.dart' as globals;

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({
    Key? key,
  });

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  int subtotal = 0;

  @override
  void initState() {
    super.initState();
  }

  Future<int> processOrder(List<Food> items) async {
    // build a json of orders and order items to send to the server
    // converting from Food and Addon objects to json
    final List<Map<String, dynamic>> orders = items.map((e) => e.toJson(e)).toList();
    print(orders);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await http.post(
      Uri.parse('${globals.serverUrl}/api/create_order'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Token ${prefs.getString('auth_token')}',
      },
      body: jsonEncode({
        'user_id': prefs.getInt('user_id'),
        'restaurant_id': items[0].restaurant,
        'order_items': orders,
      }),
    );
    print(response.statusCode);
    print(response.body);
    int orderId = jsonDecode(response.body)['order_id'];
    return orderId;
  }
  Future<void> completeOrderAndNavigate(List<Food> checkoutItems) async {
    var orderId = await processOrder(checkoutItems); // Assuming model.checkoutItems is your data

    // After processOrder completes, navigate to the PaymentPage
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PaymentPage(orderId: orderId)),
    );
  }

  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: Consumer<CheckoutModel>(
        builder: (context, model, child) {
          return Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ListView.builder(
                    itemCount: model.checkoutItems.length,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.all(10.0), // Add padding to match ListTile's default padding
                        child: Column(
                          children: [
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    "${model.checkoutItems[index].name}  x${model.checkoutItems[index].quantity}",
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                  )
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '₦${model.checkoutItems[index].price * model.checkoutItems[index].quantity}',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () {
                                        // print("Removed Subtotal: ${model.subtotal}"); 
                                        model.remove(model.checkoutItems[index]);
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            ListView.builder(
                              itemCount: model.checkoutItems[index].addons.length,
                              itemBuilder: (context, addonIndex) {
                                // print('Addon Index: $addonIndex');
                                final addon = model.checkoutItems[index].addons[addonIndex];
                                return Text(addon.name); // Display each addon's name
                              },
                              physics: NeverScrollableScrollPhysics(), // Prevents the ListView from scrolling independently
                              shrinkWrap: true, // Allows ListView to size itself according to its children
                            ),
                            // quantity
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                children: [
                                  Text('Quantity: '),
                                  IconButton(
                                    onPressed: () {
                                      model.increaseQuantity(model.checkoutItems[index]);
                                    },
                                    icon: Icon(Icons.add),
                                  ),
                                  Text('${model.checkoutItems[index].quantity}'),
                                  IconButton(
                                    onPressed: () {
                                      model.decreaseQuantity(model.checkoutItems[index]);
                                    },
                                    icon: Icon(Icons.remove),
                                  ),
                                ],
                              ),
                            ),
                            Divider(),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Subtotal: ₦${model.subtotal}', style: TextStyle(fontSize: 20)),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        // backgroundColor: Theme.of(context).colorScheme.secondary,
                      ),
                      onPressed: () {
                        print('Checkout pressed');
                        if (model.subtotal == 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Cart is empty'),
                            ),
                          );
                          return;
                        }
                        completeOrderAndNavigate(model.checkoutItems);
                        // todo: implement checkout
                        // send order to server
                        // get total from server (double checking total to prevent fraud)
                        // once response is received, show payment dialog
                        // show payment dialog with total - paystack/stripe
                        // stripe happens on backend
                        // reject payment if restaurant rejects order
                        // if payment is successful, send order to restaurant
                        // add order to order history
                        // get a driver to deliver order
                        // notify user of delivery time in order history page and homepage + notification
                      },
                      child: Text('Confirm and pay'),
                    ),
                  ],
                ),
              ),
            ],
          );
        }
      ),
    );
  }
}
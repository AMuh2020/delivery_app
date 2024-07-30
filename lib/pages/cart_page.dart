// this page is the cart page where users can view their cart and proceed to checkout
import 'dart:async';
import 'dart:io';

import 'package:decimal/decimal.dart';
import 'package:delivery_app/main.dart';
import 'package:delivery_app/models/food.dart';
import 'package:delivery_app/pages/before_payment_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:delivery_app/globals.dart' as globals;

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({
    super.key, 
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

  Future<void> completeOrderAndNavigate(List<Food> checkoutItems) async {
    final List<Map<String, dynamic>> orders = checkoutItems.map((e) => e.toJson(e)).toList();
    print(orders);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try{
      final response = await http.post(
        Uri.parse('${globals.serverUrl}/api/create_order'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Token ${prefs.getString('auth_token')}',
        },
        body: jsonEncode({
          'user_id': prefs.getInt('user_id'),
          'restaurant_id': checkoutItems[0].restaurant,
          'order_items': orders,
          'delivery_address': AddressModel.instance.address,
        }),
      ).timeout(Duration(seconds: 10));
      print(response.statusCode);
      print(response.body);
      
      if (response.statusCode == 201) {
        var responseData = jsonDecode(response.body);
        if (mounted){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BeforePaymentPage(
              orderId: responseData['order_id'],
              serviceFee: responseData['service_fee'],
              deliveryFee: responseData['delivery_fee'],
              subtotal: responseData['subtotal'],
              total: responseData['total'],
            )),
          );
        }
      } else {
        // failed to create order
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create order, check your internet connection'),
          ),
        );
        return;
      }
    } on SocketException catch (e) {
        print(e);
        // cant connect to server
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Cant connect to server'),
          ),
        );
        return;
    } on TimeoutException catch (e) {
      return;
    }
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
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                      '₦${model.checkoutItems[index].price * Decimal.fromInt(model.checkoutItems[index].quantity)}',
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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: model.checkoutItems[index].addons.map((addon) {
                                return Text('${addon.name}'); // Display each addon's name
                              }).toList(),
                            ),
                            // quantity
                            Row(
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
                      child: Text(' Go to Checkout'),
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
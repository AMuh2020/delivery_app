import 'package:delivery_app/main.dart';
import 'package:delivery_app/models/food.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({
    Key? key,
  });

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  int subtotal = 0;

  void initState() {
    super.initState();
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
                        // todo: implement checkout
                        // show payment dialog with total - paystack/stripe
                        // reject payment if restaurant rejects order
                        // if payment is successful, send order to restaurant
                        // add order to order history
                        // get a driver to deliver order
                        // notify user of delivery time in order history page and homepage + notification
                      },
                      child: Text('Checkout'),
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
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
        title: Text('Checkout Page'),
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
                                    model.checkoutItems[index].name,
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                  )
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '₦${model.checkoutItems[index].price}'+' x ${model.checkoutItems[index].addons.length}',
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
                                print('Addon Index: $addonIndex');
                                final addon = model.checkoutItems[index].addons[addonIndex];
                                return Text(addon.name); // Display each addon's name
                              },
                              physics: NeverScrollableScrollPhysics(), // Prevents the ListView from scrolling independently
                              shrinkWrap: true, // Allows ListView to size itself according to its children
                            )
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
                        // Add your checkout logic here
                        print('Checkout pressed');
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
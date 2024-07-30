import 'package:decimal/decimal.dart';
import 'package:delivery_app/components/addons_list_item.dart';
import 'package:delivery_app/main.dart';
import 'package:delivery_app/models/food.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:delivery_app/globals.dart' as globals;

class MenuItemPage extends StatefulWidget {
  final Food menuItemData;

  const MenuItemPage({
    super.key,
    required this.menuItemData,
  });

  @override
  State<MenuItemPage> createState() => _MenuItemPageState();
}

class _MenuItemPageState extends State<MenuItemPage> {

  late Future<List<Addon>> addons;
  
  // total price of the item
  Decimal totalPrice = Decimal.parse('0');

  // total price of the addons
  Decimal addonsTotalPrice = Decimal.parse('0');

  // quantity of the item
  int quantity = 1;

  // checkbox states
  List<bool> checkboxStates = [];

  // create a list of selected addons based on the checkbox states
  List<Addon> selectedAddons = [];


  List<Food> toCheckoutItems = [];

  Future<List<Addon>> fetchAddons() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await http.get(
      Uri.parse('${globals.serverUrl}/api/fooditems/${widget.menuItemData.id}/addons/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Token ${prefs.getString('auth_token')}',
      },
    );

    if (response.statusCode == 200) {
      // If the server returns an OK response, then parse the JSON.
      final parsed = jsonDecode(response.body);
      final results = parsed as List;
      print(results);
      checkboxStates = List.filled(results.length, false);
      return results.map((e) => Addon.fromJson(e)).toList();
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load addons');
    }
  }

  

  // load addons when the page is loaded
  @override
  void initState() {
    super.initState();
    // call the fetch addons function
    addons = fetchAddons();
    totalPrice = widget.menuItemData.price;
    
  }

  // add to total
  void addToTotal(Decimal price) {
    setState(() {
      addonsTotalPrice += price;
      totalPrice += price * Decimal.fromInt(quantity);
    });
  }

  // take away from total
  void takeFromTotal(Decimal price) {
    setState(() {
      addonsTotalPrice -= price;
      totalPrice -= price * Decimal.fromInt(quantity);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 300,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(widget.menuItemData.imagePath),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.menuItemData.name,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Text(
                            '₦${widget.menuItemData.price}',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Text(
                            widget.menuItemData.description,
                            style: Theme.of(context).textTheme.bodyMedium,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                          ),
                          // quantity
                          _quantityWidget(),
                          
                        ],
                      ),
                    ),
                    if (widget.menuItemData.addons.isNotEmpty) _addonsWidget(),
                    

                    // extra space to account for the bottom widget
                    const SizedBox(height: 100),
                  ],
                ),
                
                // Spacer(),
                
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _bottomWidget()
          ),
          SafeArea(
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back),
            ),
          ),
        ],
      ),
    );
  }
  Widget _quantityWidget() {
    return Row(
      children: [
        Text('Quantity: '),
        IconButton(
          onPressed: () {
            setState(() {
              quantity += 1;
              totalPrice = (widget.menuItemData.price + addonsTotalPrice) * Decimal.fromInt(quantity); 
            });
          },
          icon: Icon(Icons.add),
        ),
        Text('$quantity'),
        IconButton(
          onPressed: () {
            if (quantity > 1) {
              setState(() {
                quantity -= 1;
                totalPrice = (widget.menuItemData.price + addonsTotalPrice) * Decimal.fromInt(quantity);
              });
            }
          },
          icon: Icon(Icons.remove),
        ),
      ],
    );
  }
  
  Widget _addonsWidget() {
    return FutureBuilder<List<Addon>>(
      future: addons,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(
                  'Addons',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Column(
                children: snapshot.data!.map((item) {
                  int index = snapshot.data!.indexOf(item);
                  return AddonsListItem(
                    name: item.name,
                    price: item.price,
                    checkbox: Checkbox(
                      value: checkboxStates[index],
                      onChanged: (bool? value) {
                        setState(() {
                          print("2. $value");
                          checkboxStates[index] = value!;
                          if (value == true) {
                            addToTotal(item.price);
                            selectedAddons.add(item);
                          } else {
                            takeFromTotal(item.price);
                            selectedAddons.removeWhere((element) {
                              return element.name == item.name;
                            });
                          }
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  // bottom widget - add to cart button
  Widget _bottomWidget() {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
      ),
      child: Align(
        alignment: Alignment.center,
        child: Consumer<CheckoutModel>(
          builder: (context, model, child) {
            return ElevatedButton(
              onPressed: () {
                // print("4 ${selectedAddons}");
                // Add to cart
                model.add(
                  // add the original Food object but with the addons
                  // addons of true are added to the addons list
                  Food(
                    id: widget.menuItemData.id,
                    amountInStock: widget.menuItemData.amountInStock,
                    name: widget.menuItemData.name,
                    category: widget.menuItemData.category,
                    description: widget.menuItemData.description,
                    price: widget.menuItemData.price + addonsTotalPrice,
                    imagePath: widget.menuItemData.imagePath,
                    createdAt: widget.menuItemData.createdAt,
                    updatedAt: widget.menuItemData.updatedAt,
                    restaurant: widget.menuItemData.restaurant,
                    addons: selectedAddons,
                    quantity: quantity,
                  )
                );
                
                // add the items in the list to the checkout model
                // for (var item in toCheckoutItems) {
                //   model.add(item);
                // }
                Navigator.pop(context, toCheckoutItems);
            
              },
              style: ElevatedButton.styleFrom(
                // backgroundColor: Theme.of(context).colorScheme.secondary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                fixedSize: Size(300, 60),
              ),
              child: Text(
                'Add $quantity to basket ₦$totalPrice',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            );
          }
        )
      ),
    );
  }
}


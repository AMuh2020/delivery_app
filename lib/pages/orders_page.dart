import 'package:delivery_app/components/home_page_drawer.dart';
import 'package:delivery_app/models/order.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:delivery_app/globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {

  late Future<List<Order>> futureOrder;

  Future<List<Order>> fetchOrders() async {
    print('fetching orders');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await http.get(
      Uri.parse('${globals.serverUrl}/api/orders/user_orders/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Token ${prefs.getString('auth_token')}',
      },
    );
    if (response.statusCode == 200) {
      // If the server returns an OK response, then parse the JSON.
      final parsed = jsonDecode(response.body);
      print(parsed);
      final results = parsed as List;
      return results.map<Order>((json) => Order.fromJson(json)).toList();
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load orders');
    }
  }
  @override
  void initState() {
    super.initState();
    futureOrder = fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: HomePageDrawer(),
        appBar: AppBar(
          title: const Text('Orders'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'In Progress'),
              Tab(text: 'Completed'),
            ],
          )
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            setState(() {
              futureOrder = fetchOrders();
            });
            await futureOrder;
          },
          child: FutureBuilder(
            future: futureOrder,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                var inProgressTerms = ['cooking', 'delivering'];
                var inProgressOrders = snapshot.data.where((order) => inProgressTerms.contains(order.status)).toList();
                var completedTerms = ['completed', 'cancelled'];
                var completedOrders = snapshot.data.where((order) => completedTerms.contains(order.status)).toList();
                return TabBarView(
                  children: [
                    // in progress orders
                    RefreshIndicator(
                      onRefresh: () async {
                        setState(() {
                          futureOrder = fetchOrders();
                        });
                        await futureOrder;
                      },
                      child: ListView.builder(
                        itemCount: inProgressOrders.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text('Order ID: ${inProgressOrders[index].id}'),
                            subtitle: Text('Status: ${inProgressOrders[index].status}'),
                            trailing: Text('Total: ${inProgressOrders[index].total}'),
                          );
                        },
                      ),
                    ),
                    // completed orders
                    RefreshIndicator(
                      onRefresh: () async {
                        setState(() {
                          futureOrder = fetchOrders();
                        });
                        await futureOrder;
                      },
                      child: ListView.builder(
                        itemCount: completedOrders.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text('Order ID: ${completedOrders[index].id}'),
                            subtitle: Text('Status: ${completedOrders[index].status}'),
                            trailing: Text('Total: ${completedOrders[index].total}'),
                          );
                        },
                      ),
                    ),
                  ]
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
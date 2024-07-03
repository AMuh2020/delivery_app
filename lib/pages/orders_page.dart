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

  Future<List<Order>> fetchOrders() async {
    // for (Order order in orders) {
    //   // fetch order details
    // }
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
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: HomePageDrawer(),
      appBar: AppBar(
        title: const Text('Orders'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            fetchOrders();
          });
          await fetchOrders();
        },
        child: FutureBuilder(
          future: fetchOrders(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(snapshot.data[index].restaurantName),
                    subtitle: Text(snapshot.data[index].status),
                    trailing: Text(snapshot.data[index].total.toString()),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
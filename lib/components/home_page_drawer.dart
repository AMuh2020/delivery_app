import 'package:delivery_app/auth/login_or_register.dart';
import 'package:delivery_app/components/drawer_tile.dart';
import 'package:delivery_app/pages/home_page.dart';
import 'package:delivery_app/pages/orders_page.dart';
import 'package:delivery_app/pages/profile_page.dart';
import 'package:delivery_app/pages/settings_page.dart';
import 'package:delivery_app/utils/general_utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:delivery_app/globals.dart' as globals;

class HomePageDrawer extends StatefulWidget {
  HomePageDrawer({super.key});

  @override
  State<HomePageDrawer> createState() => _HomePageDrawerState();
}

class _HomePageDrawerState extends State<HomePageDrawer> {
  late SharedPreferences prefs;
  String username = '';

  @override
  void initState() {
    super.initState();
    getPrefs();
  }

  Future<void> _signout() async {
    // logout user
    try{
      final response = await http.post(
        Uri.parse('${globals.serverUrl}/api/signout/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Token ${prefs.getString('auth_token')}',
        },
      ).timeout(Duration(seconds: 5));
      clearPreferences();
      if (response.statusCode == 200) {
        print('Signed out');
        // If the server returns an OK response, then parse the JSON.
        final parsed = response.body;
        print(parsed);
      } else {
        // If that response was not OK, throw an error.
        print('Failed to signout');
        // throw Exception('Failed to signout');
      }
    } catch (e) {
      print('Failed to signout');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('There was an error while trying to logout'),
        ),
      );
    }
  }
  
  Future<void> getPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? '';
    });
  }

  

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        children: [
          // app logo
          const Padding(
            padding: const EdgeInsets.only(top: 100.0),
            child: Icon(
              Icons.restaurant,
              size: 60,
              // color: Theme.of(context).colorScheme.inversePrimary,
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(25),
            child: Divider(
              // color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          // home list tile
          MyDrawerTile(
            icon: Icons.home,
            text: 'Home',
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()), 
                (Route<dynamic> route) => false,
              );
            },
          ),
          
          // profile list tile
          MyDrawerTile(
            icon: Icons.person,
            text: 'Profile',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfilePage(),
                ),
              );
            },
          ),
          // orders list tile
          MyDrawerTile(
            icon: Icons.shopping_cart,
            text: 'Orders',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const OrdersPage(),
                ),
              );
            },
          ),
          // settings list tile
          MyDrawerTile(
            icon: Icons.settings,
            text: 'Settings',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsPage(),
                ),
              );
            },
          ),

          const Spacer(),
          Text('Logged in as ${username}'),
          // logout list tile
          MyDrawerTile(
            icon: Icons.logout,
            text: 'Logout',
            onTap: () {
              _signout();
              // pop until login or register page
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginOrRegister()), 
                (Route<dynamic> route) => false,
              );
            },
          ),

          const SizedBox(height: 25)

        ],
      ),
    );
  }
}
import 'package:delivery_app/components/my_drawer_tile.dart';
import 'package:delivery_app/pages/home_page.dart';
import 'package:delivery_app/pages/orders_page.dart';
import 'package:delivery_app/pages/settings_page.dart';
import 'package:flutter/material.dart';

class HomePageDrawer extends StatelessWidget {
  const HomePageDrawer({super.key});

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
            padding: const EdgeInsets.all(25),
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
              Navigator.pop(context);
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

          // logout list tile
          MyDrawerTile(
            icon: Icons.logout,
            text: 'Logout',
            onTap: () {

              Navigator.pop(context);
            },
          ),

          const SizedBox(height: 25)

        ],
      ),
    );
  }
}
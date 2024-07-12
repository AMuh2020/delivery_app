import 'dart:convert';

import 'package:delivery_app/components/home_page_drawer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:delivery_app/globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  Future<dynamic> _getProfile() async {
    // get profile data
    final prefs = await SharedPreferences.getInstance();
    var response = await http.get(
      Uri.parse('${globals.serverUrl}/api/profile/'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${prefs.getString('auth_token')}',
      },
    );

    if (response.statusCode == 200) {
      // If the server returns an OK response, then parse the JSON.
      final parsed = jsonDecode(response.body);
      print(parsed);
      return parsed;
    } else {
      // If that response was not OK, throw an error.
      // throw Exception('Failed to load profile');
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(
      //     content: Text('Failed to load profile'),
      //   ),
      // );
      // Navigator.pop(context);
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: HomePageDrawer(),
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: FutureBuilder(
        future: _getProfile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
            return Column(
              children: [
                // display profile data

                // username
                ListTile(
                  title: const Text('Username'),
                  subtitle: Text(snapshot.data['username']),
                ),

                // first name
                ListTile(
                  title: const Text('First Name'),
                  subtitle: Text(snapshot.data['first_name']),
                ),

                // last name
                ListTile(
                  title: const Text('Last Name'),
                  subtitle: Text(snapshot.data['last_name']),
                ),

                // email
                ListTile(
                  title: const Text('Email'),
                  subtitle: Text(snapshot.data['email']),
                ),

                // phone number
                ListTile(
                  title: const Text('Phone Number'),
                  subtitle: Text(snapshot.data['phone_number']),
                ),
                
              ],
            );
          } else if (snapshot.connectionState == ConnectionState.done && !snapshot.hasData) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Failed to load profile, check your internet connection and try again'),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
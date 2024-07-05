import 'dart:async';
import 'dart:io';

import 'package:delivery_app/pages/home_page.dart';
import 'package:delivery_app/pages/login_page.dart';
import 'package:delivery_app/pages/register_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:delivery_app/globals.dart' as globals;
import 'dart:convert';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {

  bool isLoggedIn = true;
  bool showLoginPage = true;
  // for login persistence
  Future<void> _checkLogin() async {
    print('checking login');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // check if has logged in before using auth token
    if (prefs.getString('auth_token') != null) {
      print('has auth token');
      try {
        final response = await http.post(
          Uri.parse('${globals.serverUrl}/api/token_auth/'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Token ${prefs.getString('auth_token')}',
          },
        ).timeout(Duration(seconds: 5));
        print(response.statusCode);
        if (response.statusCode == 200) {
          // If the server returns an OK response, then parse the JSON.
          final parsed = jsonDecode(response.body);
          // set user details in shared preferences
          // prefs.setInt('user_id', parsed['user_id']);
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomePage()), // Replace NewPage with the page you want to navigate to
            (Route<dynamic> route) => false, // This condition ensures all previous routes are removed
          );
        } else {
          setState(() {
            isLoggedIn = false;
          });
        }
      } on SocketException {
        print('cant connect to server');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cant connect to server'),
          ),
        );
        setState(() {
          isLoggedIn = false;
        });
      } on TimeoutException {
        print('cant connect to server');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cant connect to server'),
          ),
        );
        setState(() {
          isLoggedIn = false;
        });
      } catch (e) {
        print(e);
        setState(() {
          isLoggedIn = false;
        });
      }
      
    } else {
      print('no auth token');
      setState(() {
        isLoggedIn = false;
      });
    }
  }
  // toggle between login and register pages
  void togglePage() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  Future<void> _intializeFCM() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    print('fcm token: $fcmToken');
  }

  @override
  void initState() {
    super.initState();
    _intializeFCM();
    _checkLogin();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoggedIn) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      if (showLoginPage) {
        return LoginPage(onTap: togglePage);
      } else {
        return RegisterPage(onTap: togglePage);
      }
    }
  }
}

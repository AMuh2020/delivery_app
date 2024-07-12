import 'dart:convert';
import 'dart:io';
import 'package:delivery_app/components/my_button.dart';
import 'package:delivery_app/components/my_textfield.dart';
import 'package:delivery_app/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:delivery_app/globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {

  final void Function()? onTap;


  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text editing controllers
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // login function
  Future<void> login() async {

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // bool hasAuthToken = prefs.getString('auth_token')?.isNotEmpty ?? false;
    try {
      final response = await http.post(
        Uri.parse('${globals.serverUrl}/api/signin/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String , String>{
          'username': usernameController.text,
          'password': passwordController.text,
          'fcmtoken': '${prefs.getString('fcm_token')}',
        }),
      );
      var responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {

        // Accessing user information
        var user = responseData['user'];
        print(user);

        // access the auth token
        // this is the token we will use to authenticate future requests
        String authToken = user['auth_token'];
        prefs.setString('auth_token', authToken);
        int id = user['id'];
        prefs.setInt('userID', id);
        String username = user['username'];
        prefs.setString('username', username);
        String email = user['email'];
        prefs.setString('email', email);
        String phoneNumber = user['phone_number'];
        prefs.setString('phone_number', phoneNumber);
        // String address = user['address']; 
        // prefs.setString('address', address);
        print(response.statusCode);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(responseData['message']),
          ),
        );
        return;
      }
    } on SocketException catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to connect to server'),
        ),
      );
      return;
    }

    // for now go to home page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const HomePage(),
      ),
    );
    return;
  }
  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // logo
            const Icon(
              Icons.lock_open_rounded,
              size: 72,
              // color: Theme.of(context).colorScheme.inversePrimary,
            ),
            const SizedBox(height: 25),
            // message, app slogan
            Text(
              'Welcome to GbeWa the delivery app exclusive to ilorin',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 25),
            // email textfield
            // MyTextField(
            //   controller: emailController,
            //   hintText: "Email",
            //   obscureText: false,
            // ),
             MyTextField(
              controller: usernameController,
              hintText: "Username",
              obscureText: false,
            ),
            
            const SizedBox(height: 10),
      
            // password textfield
            MyTextField(
              controller: passwordController,
              hintText: "Password",
              obscureText: true,
            ),
            const SizedBox(height: 25),
            //sign in button
            MyButton(
              text: "Sign In",
              onTap: login, 
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Not a member?",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 5),
                GestureDetector(
                  onTap: widget.onTap,
                  child: Text(
                    "Register now",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      )
    );
  }
}
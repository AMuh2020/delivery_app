import 'package:delivery_app/components/my_button.dart';
import 'package:delivery_app/components/my_textfield.dart';
import 'package:delivery_app/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:delivery_app/globals.dart' as globals;


class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // text editing controllers
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  // register function
  Future<void> register() async {
    final bool registrationSuccess = await performRegistration(
      usernameController.text,
      firstnameController.text,
      lastnameController.text,
      phoneNumberController.text,
      emailController.text,
      passwordController.text,
      confirmPasswordController.text,
    );
    if (registrationSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Registration successful"),
        ),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(onTap: widget.onTap),
        )
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Registration failed"),
        ),
      );
    }

    

    return;
    
  }
  Future<bool> performRegistration(String username, String firstname,String lastname, String phoneNumber, String email, String password, String confirmPassword) async {
    // api call to register
    final response = await http.post(
      Uri.parse('${globals.serverUrl}/api/signup/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'first_name': firstname,
        'last_name': lastname,
        'phone_number': phoneNumber,
        'email': email,
        'password': password,
      }),
    );
    if (response.statusCode == 201) {
      // If the server returns an OK response, then parse the JSON.
      final parsed = jsonDecode(response.body);
      print(parsed);
      return true;
    }
    return false;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            const Icon(
              Icons.lock_open_rounded,
              size: 100,
              // color: Theme.of(context).colorScheme.inversePrimary,
            ),
            const SizedBox(height: 25),
            // message, app slogan
            const Text(
              "Let's create an account!",
              style: TextStyle(
                // color: Theme.of(context).colorScheme.inversePrimary,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 25),
            // username textfield
            MyTextField(
              controller: usernameController,
              hintText: "Username",
              obscureText: false,
            ),
            const SizedBox(height: 10),
            // first name textfield
            MyTextField(
              controller: firstnameController,
              hintText: "First Name",
              obscureText: false,
            ),
            const SizedBox(height: 10),
            // last name textfield
            MyTextField(
              controller: lastnameController,
              hintText: "Last Name",
              obscureText: false,
            ),
            const SizedBox(height: 10),
            // phone number textfield
            MyTextField(
              controller: phoneNumberController,
              hintText: "Phone Number",
              obscureText: false,
            ),
            const SizedBox(height: 10),
            // email textfield
            MyTextField(
              controller: emailController,
              hintText: "Email",
              obscureText: false,
            ),
            const SizedBox(height: 10),
            // password textfield
            MyTextField(
              controller: passwordController,
              hintText: "Password",
              obscureText: true,
            ), 
            const SizedBox(height: 10),

            // confirm password textfield
            MyTextField(
              controller: confirmPasswordController,
              hintText: "Confirm password",
              obscureText: true,
            ),
            const SizedBox(height: 25),

            // register button
            MyButton(
              text: "Sign Up",
              onTap: () {
                // username check
                if (usernameController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Username cannot be empty"),
                    ),
                  );
                  return;
                }
                // phone number check
                if (phoneNumberController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Phone number cannot be empty"),
                    ),
                  );
                  return;
                }
                // email check
                if (emailController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Email cannot be empty"),
                    ),
                  );
                  return;
                }
                // password match check
                if (passwordController.text != confirmPasswordController.text) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Passwords do not match"),
                    ),
                  );
                  return;
                }
                register();
                
              },
            ),

            const SizedBox(height: 25),

            // sign in button, already a member? sign in
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already a member?",
                  style: TextStyle(
                    // color: Theme.of(context).colorScheme.primary,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 5),
                GestureDetector(
                  onTap: widget.onTap,
                  child: Text(
                    "Login",
                    style: TextStyle(
                      // color: Theme.of(context).colorScheme.inversePrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
        ],)
      )
    );
  }
}
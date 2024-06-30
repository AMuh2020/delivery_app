import 'package:delivery_app/components/my_button.dart';
import 'package:delivery_app/components/my_textfield.dart';
import 'package:delivery_app/pages/home_page.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {

  final void Function()? onTap;


  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text editing controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // login function
  void login() {
    // todo: implement login

    // for now go to home page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const HomePage(),
      ),
    );
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
            Icon(
              Icons.lock_open_rounded,
              size: 72,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),

            const SizedBox(height: 25),
            // message, app slogan
            Text(
              'Welcome to Delivery App',
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 25),
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

            const SizedBox(height: 25),
            //sign in button
            MyButton(
              text: "Sign In",
              onTap: login, 
            ),
            const SizedBox(height: 25),
            // sign up button, not a member? sign up

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
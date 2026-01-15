import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'homepage.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> loginUser() async {
    String url =
        "https://shopnauval.alwaysdata.net/servershop_nauval/login.php";
    // "http://10.0.3.2/servershop_nauval/login.php";

    try {
      var response = await http.post(Uri.parse(url), body: {
        "email": emailController.text,
        "password": passwordController.text,
      });

      var data = json.decode(response.body);

      if (data['success'] == true) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLogin', true);
        await prefs.setString('userID', data['user']['id'].toString());
        await prefs.setString('userName', data['user']['name']);
        await prefs.setString('userEmail', data['user']['email']);

        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Login Failed! Wrong email or password")),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green.shade50,
                    ),
                    child: const Icon(Icons.shopping_bag,
                        size: 60, color: Colors.green),
                  ),
                  const SizedBox(height: 20),
                  const Text("Welcome Back!",
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87)),
                  const SizedBox(height: 5),
                  const Text("Login to your account",
                      style: TextStyle(fontSize: 16, color: Colors.grey)),
                  const SizedBox(height: 40),
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "Email",
                      hintText: "Enter your email",
                      prefixIcon: const Icon(Icons.email_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Password",
                      hintText: "Enter your password",
                      prefixIcon: const Icon(Icons.lock_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 2,
                      ),
                      onPressed: () {
                        if (emailController.text.isEmpty ||
                            passwordController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Please fill all fields")));
                        } else {
                          loginUser();
                        }
                      },
                      child: const Text("LOGIN",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? ",
                          style: TextStyle(color: Colors.grey)),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RegisterPage()),
                          );
                        },
                        child: const Text("Register Here",
                            style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold)),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

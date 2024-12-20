import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:graduan_test/core/services/shared_pref_services.dart';
import 'package:graduan_test/features/auth/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String email = '';
  String password = '';
  bool hasToken = false;

  void _login() async {
    final authService = AuthService();
    try {
      if (_formKey.currentState!.validate()) {
        await authService.login(email, password);
      }
      setState(() {
        hasToken = SharedPreferencesService().hasToken();
      });
      if (hasToken) {
        if (!mounted) return;
        Navigator.pushNamedAndRemoveUntil(context, '/home', ModalRoute.withName('/'));
        setState(() {});
      }
    } catch (e) {
      log(e.toString());
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  _updateEmail() {
    setState(() {
      email = emailController.text;
    });
  }

  _updatePassword() {
    setState(() {
      password = passwordController.text;
    });
  }

  @override
  void initState() {
    super.initState();
    emailController.addListener(_updateEmail);
    passwordController.addListener(_updatePassword);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 15.0,
            children: [
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter password';
                  }
                  return null;
                },
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _login,
                  child: Text('Login'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

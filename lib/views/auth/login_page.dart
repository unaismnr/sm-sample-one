import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:sm_sample_one/services/auth_service.dart';
import 'package:sm_sample_one/views/auth/signup_page.dart';
import 'package:sm_sample_one/views/home/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  String? email;

  String? password;

  String? userame;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: ValidationBuilder().email().maxLength(50).build(),
                onChanged: (value) {
                  email = value.trim();
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                validator:
                    ValidationBuilder().maxLength(15).minLength(6).build(),
                onChanged: (value) {
                  password = value.trim();
                },
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 45,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      bool success = await AuthService.login(email, password);
                      if (context.mounted) {
                        success
                            ? Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HomePage(),
                                ),
                                (route) => false,
                              )
                            : ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Login Failed'),
                                ),
                              );
                      }
                    }
                  },
                  child: const Text('Login'),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SignupPage(),
                    ),
                  );
                },
                child: const Text('Create an Account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

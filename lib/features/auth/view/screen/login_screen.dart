import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:insights/features/auth/view_model/auth_viewmodel.dart';
import 'package:insights/features/home/view/home_screen.dart';

import 'components/app_text_field.dart';
import 'signup_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _errorMessage;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.deepPurple.withOpacity(0.08),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Sign In',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      )),
                  const SizedBox(height: 24),
                  if (_errorMessage != null) ...[
                    Text(_errorMessage!,
                        style: const TextStyle(color: Colors.red)),
                    const SizedBox(height: 10),
                  ],
                  AppTextField(
                    controller: _emailController,
                    label: 'Email',
                    icon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Enter email' : null,
                  ),
                  AppTextField(
                    controller: _passwordController,
                    label: 'Password',
                    icon: Icons.lock,
                    obscureText: true,
                    validator: (value) => value == null || value.isEmpty
                        ? 'Enter password'
                        : null,
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 2,
                      ),
                      onPressed: _isLoading
                          ? null
                          : () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  _isLoading = true;
                                  _errorMessage = null;
                                });
                                try {
                                  await ref
                                      .read(authControllerProvider.notifier)
                                      .login(
                                        email: _emailController.text,
                                        password: _passwordController.text,
                                      );
                                  if (context.mounted) {
                                    Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const HomeScreen()),
                                      (route) => false,
                                    );
                                  }
                                } catch (e) {
                                  setState(() {
                                    _errorMessage = e.toString();
                                  });
                                } finally {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                }
                              }
                            },
                      child: _isLoading
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white),
                            )
                          : const Text(
                              'Sign In',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => const SignupScreen()),
                      );
                    },
                    child: const Text(
                      "Don't have an account? Sign Up",
                      style: TextStyle(
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Container(
                  //   padding: const EdgeInsets.all(16),
                  //   decoration: BoxDecoration(
                  //     color: Colors.deepPurple.withOpacity(0.1),
                  //     borderRadius: BorderRadius.circular(12),
                  //     border: Border.all(
                  //       color: Colors.deepPurple.withOpacity(0.3),
                  //       width: 1,
                  //     ),
                  //   ),
                  //   child: const Column(
                  //     children: [
                  //       Text(
                  //         'Admin Access',
                  //         style: TextStyle(
                  //           fontWeight: FontWeight.bold,
                  //           color: Colors.deepPurple,
                  //         ),
                  //       ),
                  //       SizedBox(height: 8),
                  //       Text(
                  //         'Email: admin_lu@gmail.com\nPassword: Aa12345!',
                  //         style: TextStyle(
                  //           fontSize: 12,
                  //           color: Colors.deepPurple,
                  //         ),
                  //         textAlign: TextAlign.center,
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../utils/constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controllers for the text fields
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // For displaying error messages
  String? _errorMessage;
  bool _isLoading = false;

  @override
  void dispose() {
    // Clean up controllers when the widget is disposed
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Handle login button press
  void _handleLogin() {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Simulate login process
    Future.delayed(const Duration(seconds: 1), () {
      // Check if the widget is still mounted before updating state
      if (!mounted) return;

      // For demo purposes, accept any non-empty credentials
      if (_loginController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty) {
        // Navigate to main layout screen
        Navigator.of(context).pushReplacementNamed(AppConstants.mainRoute);
      } else {
        // Show error message
        setState(() {
          _errorMessage = "Login va parol kiritilishi shart";
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // App logo or icon could go here
                  const Icon(Icons.school, size: 64, color: Colors.blue),
                  const SizedBox(height: 24),

                  // Title
                  const Text(
                    'Test Boshqaruv Tizimi',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  const Text(
                    'Tizimga Kirish',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 32),

                  // Login field
                  TextFormField(
                    controller: _loginController,
                    decoration: const InputDecoration(
                      labelText: 'Login',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 16),

                  // Password field
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Parol',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock),
                    ),
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _handleLogin(),
                  ),
                  const SizedBox(height: 24),

                  // Login button
                  FilledButton(
                    onPressed: _isLoading ? null : _handleLogin,
                    child:
                        _isLoading
                            ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                            : const Text('Kirish'),
                  ),

                  // Error message
                  if (_errorMessage != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

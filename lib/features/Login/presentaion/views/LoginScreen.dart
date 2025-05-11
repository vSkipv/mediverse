import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../constants.dart';
import '../../../ForGotPassword/presention/views/ForgotPassword.dart';
import '../../../Sginup/presentaion/views/SignupScreen.dart';
import '../controller/cubit/login_cubit.dart';
import '../controller/cubit/login_state.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Screen',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'GT Sectra Fine',
      ),
      home: const LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;
  bool _rememberMe = false;
  final TextEditingController _nationalIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _nationalIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          // Handle successful login
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login successful')),
          );
          // Navigate to next screen or handle success
        } else if (state is LoginError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Back Button and Sign in text
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios, color: kPrimaryColor),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          const Expanded(
                            child: Center(
                              child: Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: kPrimaryColor,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 48),
                        ],
                      ),
                      const SizedBox(height: 40),

                      // National ID Field
                      const Text(
                        'National ID',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _nationalIdController,
                        decoration: InputDecoration(
                          hintText: 'Enter your National ID',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 20),

                      // Password Field
                      const Text(
                        'Password',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _passwordController,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          hintText: 'Enter Your Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText ? Icons.visibility : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Remember Me and Forgot Password
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: _rememberMe,
                                onChanged: (value) {
                                  setState(() {
                                    _rememberMe = value!;
                                  });
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              const Text(
                                'Remember Me',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => EmailOTPScreen()),
                              );
                            },
                            child: const Text(
                              'Forgot Password?',
                              style: TextStyle(
                                color: kPrimaryColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Login Button
                      ElevatedButton(
                        onPressed: state is LoginLoading
                            ? null
                            : () {
                                final nationalId = int.tryParse(_nationalIdController.text);
                                if (nationalId == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Please enter a valid National ID')),
                                  );
                                  return;
                                }
                                context.read<LoginCubit>().login(
                                      nationalId: nationalId,
                                      password: _passwordController.text,
                                    );
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: state is LoginLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                      const SizedBox(height: 32),

                      // Or With Divider
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: Colors.grey[400],
                              thickness: 1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'Or With',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: Colors.grey[400],
                              thickness: 1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // // Google Sign In
                      // OutlinedButton.icon(
                      //   onPressed: () {},
                      //   icon: Image.asset(
                      //     'assets/images/Google-Logo.png',
                      //     height: 24,
                      //     width: 24,
                      //   ),
                      //   label: const Text('Sign in with Google'),
                      //   style: OutlinedButton.styleFrom(
                      //     padding: const EdgeInsets.symmetric(vertical: 16),
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(8),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
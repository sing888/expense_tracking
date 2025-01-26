import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/signup_controller.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final signupController = Get.put(SignupController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Sign Up', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
                controller: signupController.usernameController,
                decoration: const InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder()),
                onChanged: (value) {
                  signupController.usernameController.text = value;
                }
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
                controller: signupController.emailController,
                decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder()),
                onChanged: (value) {
                  signupController.emailController.text = value;
                }
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Obx(() => TextField(
                controller: signupController.passwordController,
                obscureText: signupController.isPasswordVisible.value,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      signupController.isPasswordVisible.value ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      signupController.isPasswordVisible.value =!signupController.isPasswordVisible.value;
                    },
                  ),
                ),
                onChanged: (value) {
                  signupController.passwordController.text = value;
                }
            )),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Obx(() => TextField(
                controller: signupController.confirmPasswordController,
                obscureText: signupController.isPasswordVisible.value,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      signupController.isPasswordVisible.value ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      signupController.isPasswordVisible.value =!signupController.isPasswordVisible.value;
                    },
                  ),
                ),
                onChanged: (value) {
                  signupController.confirmPasswordController.text = value;
                }
            )),
          ),
          Padding(
              padding: const EdgeInsets.all(40),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(246, 236, 223, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 15), // Add space on both sides
                ),
                onPressed: () {
                  if (signupController.usernameController.text.isEmpty || signupController.emailController.text.isEmpty || signupController.passwordController.text.isEmpty || signupController.confirmPasswordController.text.isEmpty) {
                    Get.snackbar(
                      'Error',
                      'Please enter email and password',
                    );
                  } else if (!isValidEmail(signupController.emailController.text)) {
                    Get.snackbar(
                      'Error',
                      'Please enter a valid email',
                    );
                  } else {
                    signupController.signUp();
                  }
                },
                child: Center(
                    child: Obx(
                          () => signupController.loading.value
                          ? const CircularProgressIndicator()
                          : const Text(
                        'Sign up',
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ), // Text stays in the middle,
                    )),
              )),
          const Text('Already have an account? ', style: TextStyle(fontSize: 16, color: Colors.black)),
          TextButton(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 10),
            ),
            onPressed: () {
              Get.offAllNamed('/login');
            },
            child: const Text('Log in', style: TextStyle(fontSize: 16, color: Colors.blue)),
          ),
        ],
      )

    );
  }

  bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}
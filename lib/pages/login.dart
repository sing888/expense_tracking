import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/login_controller.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Login', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                  controller: loginController.emailController,
                  decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder()),
                  onChanged: (value) {
                    loginController.emailController.text = value;
                  }
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Obx(() => TextField(
                controller: loginController.passwordController,
                obscureText: loginController.isPasswordVisible.value,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      loginController.isPasswordVisible.value ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      loginController.isPasswordVisible.value =!loginController.isPasswordVisible.value;
                    },
                  ),
                ),
                onChanged: (value) {
                  loginController.passwordController.text = value;
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
                    if (loginController.emailController.text.isEmpty || loginController.passwordController.text.isEmpty) {
                      Get.snackbar(
                        'Error',
                        'Please enter email and password',
                      );
                    } else if (!isValidEmail(loginController.emailController.text)) {
                      Get.snackbar(
                        'Error',
                        'Please enter a valid email',
                      );
                    } else {
                      loginController.login();
                    }
                  },
                  child: Center(
                      child: Obx(
                            () => loginController.loading.value
                            ? const CircularProgressIndicator()
                            : const Text(
                          'Log In',
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ), // Text stays in the middle,
                      )),
                )),
            const Text('Don\'t have an account? ', style: TextStyle(fontSize: 16, color: Colors.black)),
            TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              ),
              onPressed: () {
                Get.offAllNamed('/signup');
              },
              child: const Text('Sign Up', style: TextStyle(fontSize: 16, color: Colors.blue)),
            ),
          ],
        ),
      ),
    );
  }

  bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

}
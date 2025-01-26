import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/api_service.dart';

class SignupController extends GetxController {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final ApiService _apiService = ApiService();

  var isPasswordVisible = true.obs;
  var isConfirmPasswordVisible = true.obs;

  var loading = false.obs;

  void signUp() async {
    if (passwordController.text!= confirmPasswordController.text) {
      Get.snackbar("Error", "Passwords do not match");
      return;
    }
    loading.value = true;
    try {
      var response = await _apiService.signup(
        usernameController.text,
        emailController.text,
        passwordController.text,
      );
      if (response) {
        Get.snackbar("Success", "Successfully signed up", duration: const Duration(seconds: 2));
        Get.offAllNamed('/login');
      } else {
        Get.snackbar("Error", "Failed to sign up");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to sign up");
    }
  }

}
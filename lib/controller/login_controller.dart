import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/get_storage.dart';
import '../core/api_service.dart';

class LoginController extends GetxController {
  final ApiService _apiService = ApiService();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var isPasswordVisible = true.obs;
  var loading = false.obs;

  void login() async {
    loading.value = true;
    var email = emailController.text;
    var password = passwordController.text;

    if (email.isEmpty || password.isEmpty){
      Get.snackbar("Error", "Please enter username and password");
      loading.value = false;
    }

    // if email not in email type
    if (!email.contains("@")){
      Get.snackbar("Error", "Please enter a valid email");
      loading.value = false;
    }

    var response = await _apiService.login(email, password);
    print(response);
    if (response) {
      Get.offAndToNamed('/');
    }else{
      Get.snackbar("Error", "Invalid username or password");
      loading.value = false;
    }
    loading.value = false;
  }

}
import 'dart:async';
import 'package:get/get.dart';
import '../core/get_storage.dart';
import '../core/api_service.dart';

class HomeController extends GetxController {
  final loading = false.obs;
  final ApiService _apiService = ApiService();

  var expenses = [].obs;

  @override
  void onInit() {
    super.onInit();
    getUserExpense();
  }

  void getUserExpense() async {
    loading.value = true;
    await Future.delayed(const Duration(milliseconds: 1));
    bool isTokenValid = _validateToken();
    if (isTokenValid) {
      var result = await _apiService.getUserExpense();
      loading.value = false;
      if (result['success']) {
        expenses.value = result['data'];
      } else {
        Get.offAndToNamed('/login');
      }
    } else {
      loading.value = false;
      Get.offAndToNamed('/login');
    }
  }

  bool _validateToken() {
    String? token = StorageService.getToken();
    if (token == null) {
      return false;
    } else {
      return true;
    }
  }
}




import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/api_service.dart';
import '../core/get_storage.dart';
import '../controller/dashboard_controller.dart';
import '../controller/expenseList_controller.dart';

class AddExpenseController extends GetxController {
  final ApiService _apiService = ApiService();
  var loading = false.obs;
  final DashboardController dashboardController = Get.put(DashboardController());
  final ExpenseListController expenseListController = Get.put(ExpenseListController());

  TextEditingController amountController = TextEditingController();
  TextEditingController notesController = TextEditingController();

  var selectedDate = ''.obs;
  var selectedCategory = ''.obs;
  var allCategories = [].obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getToday();
    getCategory();
  }

  void getToday() {
    DateTime now = DateTime.now();
    selectedDate.value = now.toIso8601String();
  }

  void getCategory() {
    var result = StorageService.getCategory();
    if (result != null) {
      allCategories.value = result;
    }
  }

  void addExpense() async {
    loading.value = true;
    if (amountController.text.isEmpty || selectedCategory.value.isEmpty || selectedDate.value.isEmpty) {
      Get.snackbar('Error', 'Please fill all fields');
      loading.value = false;
      return;
    }
    var result = await _apiService.addExpense(
      double.parse(amountController.text),
        selectedCategory.value,
        selectedDate.value.split('T')[0],
        notesController.text,
    );
    loading.value = false;
    if (result) {
      expenseListController.getUserExpense();
      dashboardController.getTotalByCategory();
      Get.back();
    } else {
      Get.snackbar('Error', result['message']);
    }
  }

  void addCategory(String category) {
    allCategories.add(category);
    saveCategory();
  }

  void removeCategory(int index) {
    allCategories.removeAt(index);
    saveCategory();
  }

  void saveCategory() {
    var category = allCategories;
    StorageService.saveCategory(category);
  }
}

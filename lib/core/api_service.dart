import 'package:expense_tracking/core/get_storage.dart';
import 'package:get/get.dart';

import 'api.dart';
import 'api_response.dart';

class ApiService {
  final Api _api = Api();

  Future getUserExpense() async {
    ApiResponse response = await _api.getRequest('expenses');
    if (response.success) {
      return response.data;
    }else{
      return response.message;
    }
  }

  Future getYears() async {
    ApiResponse response = await _api.getRequest('expenses/years');
    if (response.success) {
      return response.data;
    }else{
      return response.message;
    }
  }

  Future getMonths(String year) async {
    ApiResponse response = await _api.getRequest('expenses/months-by-year?year=$year');
    if (response.success) {
      return response.data;
    }else{
      return response.message;
    }
  }


  Future getTotalByCategory(String year, String month) async {
    if (month == '1' || month == '2' || month == '3' || month == '4' || month == '5' || month == '6' || month == '7' || month == '8' || month == '9'){
      month = '0$month';
    }
    ApiResponse response = await _api.getRequest('expenses/total?year=$year&month=$month');
    if (response.success) {
      return response.data;
    }
    else{
      return response.message;
    }
  }


  Future getTotalByDaily(String year, String month) async {
    if (month == '1' || month == '2' || month == '3' || month == '4' || month == '5' || month == '6' || month == '7' || month == '8' || month == '9'){
      month = '0$month';
    }
    ApiResponse response = await _api.getRequest('expenses/daily?year=$year&month=$month');
    if (response.success) {
      return response.data;
    }
    else{
      return response.message;
    }
  }

  Future login(String email, String password) async {
    ApiResponse response = await _api.postRequest('login', {'email': email, 'password': password});
    if (response.success) {
      if (response.data['success']){
        StorageService.saveToken(response.data['data']['access_token']);
        StorageService.saveRefreshToken(response.data['data']['refresh_token']);
        return true;
      }else{
        Get.snackbar('Error', '${response.data['message']}');
        return false;
      }
    }else{
      Get.snackbar('Error', '${response.message}');
      return false;
    }
  }

  Future signup(String username, String email, String password) async {
    ApiResponse response = await _api.postRequest('signup', {'username': username, 'email': email, 'password': password});
    if (response.success) {
      if (response.data['success']){
        return true;
      }else{
        Get.snackbar('Error', '${response.data['message']}');
        return false;
      }
    }else{
      Get.snackbar('Error', '${response.message}');
      return false;
    }
  }

  Future addExpense(double amount, String category, String date, String notes) async {
    ApiResponse response = await _api.postRequest('expenses', {'amount': amount, 'category': category, 'date': date, 'notes': notes});
    if (response.success) {
      if (response.data['success']){
        return true;
      }else{
        Get.snackbar('Error', '${response.data['message']}');
        return false;
      }
    }
  }
}

import 'package:get/get.dart';
import '../core/api_service.dart';

class ExpenseListController extends GetxController {
  final loading = false.obs;
  RxInt time = 0.obs;
  final ApiService _apiService = ApiService();

  var expenses = [].obs;

  @override
  void onInit() {
    super.onInit();
    getUserExpense();
  }

  void getUserExpense() async  {
    loading.value = true;
    var result = await _apiService.getUserExpense();
    if (result['success']) {
      expenses.value = result['data'];
    }else{
      expenses.value = [];
    }
    loading.value = false;
  }
}

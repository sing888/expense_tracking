import 'package:get/get.dart';
import '../core/api_service.dart';

class DashboardController extends GetxController {
  final ApiService _apiService = ApiService();
  var loading = false.obs;

  var allYears = [].obs;
  var allMonths = [].obs;
  var allData = [].obs;

  var selectYear = 0.obs;
  var selectMonth = 0.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  void getYears() async {
    loading.value = true;
    var response = await _apiService.getYears();
    allYears.value = response['data'];
    if (allYears.isNotEmpty && selectYear.value == 0) {
      selectYear.value = allYears.first;
    }
    getMonths(selectYear.value.toString());
    loading.value = false;
  }

  void getMonths(String year) async {
    loading.value = true;
    allMonths.clear();
    selectMonth.value = 0;
    var response = await _apiService.getMonths(year.toString());
    allMonths.value = response['data'];
    if (allMonths.isNotEmpty && selectMonth.value == 0) {
      selectMonth.value = allMonths.first;
      getTotalByCategory();
    }
    loading.value = false;
  }

  void getTotalByCategory() async {
    loading.value = true;
    var year = selectYear.value.toString();
    var month = selectMonth.value.toString();
    var response = await _apiService.getTotalByCategory(year, month);
    allData.value = response['data'];
    loading.value = false;
  }

}

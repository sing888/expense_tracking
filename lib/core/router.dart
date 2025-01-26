import 'package:get/get.dart';
import '../home.dart';
import '../pages/login.dart';
import '../pages/addExpense.dart';
import '../pages/signup.dart';

class AppRouter {
  static const String initial = '/';

  static final routes = [
    GetPage(name: '/', page: () => Home()),
    GetPage(name: '/login', page: () => const LoginPage()),
    GetPage(name: '/signup', page: () => const SignUpPage()),
    GetPage(name: '/addExpense', page: () => const AddExpense()),
  ];
}
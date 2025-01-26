import 'package:expense_tracking/pages/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import './pages/expenseList.dart';
import './controller/home_controller.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
   _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final List<Widget> _pages = [const DashboardPage(), const ExpenseList()];
  final HomeController _homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        currentIndex: _currentIndex,
        selectedIconTheme:
        const IconThemeData(color: Color.fromRGBO(119, 90, 11, 1)),
        unselectedIconTheme: const IconThemeData(color: Colors.grey),
        selectedItemColor: const Color.fromRGBO(119, 90, 11, 1),
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color.fromRGBO(246, 236, 223, 1),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart_outline),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.money_rounded),
            label: 'Expense List',
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      body: _pages[_currentIndex],
      );
    }
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/expenseList_controller.dart';
import '../core/get_storage.dart';

class ExpenseList extends StatefulWidget {
  const ExpenseList({super.key});

  @override
  _ExpenseListState createState() => _ExpenseListState();
}

class _ExpenseListState extends State<ExpenseList> {
  final ExpenseListController _controller = Get.put(ExpenseListController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.yellow[700],
            onPressed: () {
              Get.toNamed('/addExpense');
            },
            child: const Icon(
              Icons.add,
              color: Colors.white,
            )),
        appBar: AppBar(
          title: const Text('Expense List'),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.logout_outlined,
                color: Colors.red,
              ),
              onPressed: () {
                Get.defaultDialog(
                  title: 'Logout',
                  content: const Text('Are you sure you want to logout?'),
                  textConfirm: 'Logout',
                  textCancel: 'Cancel',
                  barrierDismissible: true,
                  onConfirm: () {
                    StorageService.clearToken();
                    Get.offAllNamed('/login');
                  },
                  confirmTextColor: Colors.white,
                  buttonColor: Colors.red,
                );
              },
            )
          ],
        ),
        body: Obx(() => _controller.loading.value == true
            ? const Center(child: CircularProgressIndicator())
            : _controller.expenses.isEmpty
                ? const Center(child: Text('No expenses found'))
                : ListView.builder(
                    itemCount: _controller.expenses.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              child: Row(
                                children: [
                                  Text('Date: ${_controller.expenses[index]['DATE']}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
                                ],
                              ),
                            ),
                            const Divider(thickness: 1),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                              child: Row(
                                children: [
                                  Text('Category: ${_controller.expenses[index]['CATEGORY']}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.normal)),
                                  const Spacer(),
                                  Text('Amount: ${_controller.expenses[index]['AMOUNT']}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                            const Divider(thickness: 1),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                              child: Row(
                                children: [
                                  Text('Note: ${_controller.expenses[index]['NOTES']}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.normal)),
                                ],
                              ),
                            ),
                          ],
                        )
                      );
                    }
                    )
        )
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controller/addExpense_controller.dart';


class AddExpense extends StatefulWidget {
  const AddExpense({super.key});

  @override
  _AddExpenseState createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  final AddExpenseController _controller = Get.put(AddExpenseController());

  TextEditingController _newCategoryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add Expense'),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: () async {
                        final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.tryParse(_controller.selectedDate.value) ??
                              DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now(),
                        );
                        if (pickedDate != null) {
                          _controller.selectedDate.value =
                              pickedDate.toIso8601String(); // Convert to string
                        }
                      },
                      child: Obx(() => Text(
                          _controller.selectedDate.value.isNotEmpty
                              ? _controller.selectedDate.value.split('T')[0]
                              : 'Select Date',
                          style: const TextStyle(fontSize: 16))),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.bottomSheet(
                          backgroundColor: Colors.white,
                          SizedBox(
                            height: 500,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  child: Row(
                                    children: [
                                      const Text('Choose Category',
                                          style: TextStyle(fontSize: 18)),
                                      const Spacer(),
                                      IconButton(
                                        icon: const Icon(Icons.add),
                                        onPressed: () {
                                          Get.defaultDialog(
                                            title: 'Add New Category',
                                            textConfirm: 'Add',
                                            textCancel: 'Cancel',
                                            barrierDismissible: true,
                                            backgroundColor: Colors.white,
                                            buttonColor: Colors.blue,
                                            content: TextFormField(
                                              controller: _newCategoryController,
                                              decoration: const InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  labelText: 'Category Name'),
                                              onChanged: (value) {
                                                _newCategoryController.text = value;
                                              },
                                            ),
                                            onConfirm: () {
                                              _controller.addCategory(
                                                  _newCategoryController.text);
                                              _newCategoryController.clear();
                                              Navigator.pop(context);
                                            },
                                          );
                                        },
                                      )
                                    ],
                                  ),
                                ),
                                const Divider(thickness: 1),
                                Obx(
                                      () => _controller.allCategories.isNotEmpty
                                      ? SizedBox(
                                    height: 400,
                                    child: ListView.builder(
                                      itemCount: _controller.allCategories.length,
                                      itemBuilder: (context, index) {
                                        return ListTile(
                                          trailing: IconButton(
                                            icon: const Icon(Icons.delete,
                                                color: Colors.red),
                                            onPressed: () {
                                              Get.defaultDialog(
                                                title: 'Delete Category',
                                                textConfirm: 'Delete',
                                                textCancel: 'Cancel',
                                                barrierDismissible: true,
                                                backgroundColor: Colors.white,
                                                buttonColor: Colors.red,
                                                content: Text(
                                                    'Are you sure you want to delete "${_controller.allCategories[index]}" category?'),
                                                onConfirm: () {
                                                  _controller.removeCategory(index);
                                                  Navigator.pop(context);
                                                },
                                              );
                                            },
                                          ),
                                          title: Text(
                                              _controller.allCategories[index]),
                                          onTap: () {
                                            _controller.selectedCategory.value =
                                            _controller.allCategories[index];
                                            Navigator.pop(context);
                                          },
                                        );
                                      },
                                    ),
                                  )
                                      : const Center(child: Text('No Categories Found')),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                      child: Obx(() => Text(
                          _controller.selectedCategory.value.isNotEmpty
                              ? _controller.selectedCategory.value
                              : 'Select Category',
                          style: const TextStyle(fontSize: 16))),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: _controller.amountController,
                keyboardType: TextInputType.number,
                // Pops up numeric keypad
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))
                ],
                // Allows only digits
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  _controller.amountController.text = value;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                  controller: _controller.notesController,
                  maxLines: null,
                  decoration: const InputDecoration(
                      labelText: 'Notes', border: OutlineInputBorder()),
                  onChanged: (value) {
                    _controller.notesController.text = value;
                  }),
            ),
            Padding(
                padding: const EdgeInsets.all(40),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(246, 236, 223, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15), // Add space on both sides
                  ),
                  onPressed: () {
                    _controller.addExpense();
                  },
                  child: Center(
                      child: Obx(
                            () => _controller.loading.value
                            ? const CircularProgressIndicator()
                            : const Text(
                          'Submit',
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ), // Text stays in the middle,
                      )),
                )),
          ],
        ));
  }
}

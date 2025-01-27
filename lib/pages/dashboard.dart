import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/get_storage.dart';
import '../controller/dashboard_controller.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final DashboardController _controller = Get.put(DashboardController());

  @override
  void initState() {
    super.initState();
    _controller.getYears();
  }

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
          title: const Text('Dashboard'),
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
        body: Column(
          children: <Widget>[
            SizedBox(
              height: Get.height * 0.03,
              child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text(
                        'Year: ',
                        style: TextStyle(fontSize: 18.0),
                      ),
                      Obx(() => _controller.selectYear.value == 0
                          ? const Text('None',
                              style: TextStyle(
                                  fontSize: 18.0, color: Colors.black))
                          : Text(_controller.selectYear.value.toString())),
                      const Spacer(),
                      const Text(
                        'Month: ',
                        style: TextStyle(fontSize: 18.0),
                      ),
                      Obx(() => _controller.selectMonth.value == 0
                          ? const Text('None',
                              style: TextStyle(
                                  fontSize: 18.0, color: Colors.black))
                          : Text(_controller.selectMonth.value.toString())),
                      const Spacer(),
                      IconButton(
                          onPressed: () {
                            Get.defaultDialog(
                                title: 'Filter',
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Text('Year:     ',
                                            style: TextStyle(fontSize: 20.0)),
                                        Obx(
                                          () => DropdownButton<int>(
                                            value: _controller.selectYear.value,
                                            items: _controller.allYears
                                                .map((value) {
                                              return DropdownMenuItem<int>(
                                                value: value,
                                                child: Text(value.toString()),
                                              );
                                            }).toList(),
                                            onChanged: (value) {
                                              _controller.selectYear.value =
                                                  value!;
                                              _controller
                                                  .getMonths(value.toString());
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                    const Divider(thickness: 1.0),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text('Month:    ',
                                            style: TextStyle(fontSize: 20.0)),
                                        Obx(
                                          () => DropdownButton<int>(
                                            value:
                                                _controller.selectMonth.value,
                                            items: _controller.allMonths
                                                .map((value) {
                                              return DropdownMenuItem<int>(
                                                value: value,
                                                child: Text(value.toString()),
                                              );
                                            }).toList(),
                                            onChanged: (value) {
                                              _controller.selectMonth.value =
                                                  value!;
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                barrierDismissible: false,
                                onConfirm: () {
                                  _controller.getTotalByCategory();
                                  _controller.getTotalByDaily();
                                  Navigator.pop(context);
                                },
                                confirmTextColor: Colors.white,
                                buttonColor: Colors.blue);
                          },
                          icon: const Icon(
                            Icons.filter_list_outlined,
                            size: 20.0,
                          )),
                    ],
                  )),
            ),
            const Divider(thickness: 1.0),
            const Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '     Total Expense by Category ',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                Spacer()
              ],
            ),
            SizedBox(
              height: Get.height * 0.30,
              child: Obx(
                () => _controller.loading.value == true
                    ? const Center(child: CircularProgressIndicator())
                    : GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200,
                          childAspectRatio: 0.66,
                          mainAxisSpacing: 10.0,
                          crossAxisSpacing: 10.0,
                        ),
                        scrollDirection: Axis.horizontal,
                        itemCount: _controller.allDataByCategory.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            color: _controller.allDataByCategory[index]['category'] ==
                                    'Total'
                                ? Colors.green[100]
                                : Colors.grey[100],
                            elevation: 5.0,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    _controller.allDataByCategory[index]['category']
                                        .toString(),
                                    style: const TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const Divider(thickness: 1.0),
                                  Text(
                                    _controller.allDataByCategory[index]['total_expense']
                                        .toString(),
                                    style: const TextStyle(fontSize: 20.0),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),
            const Divider(thickness: 1.0),
            const Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '     Total Expense by Daily ',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                Spacer()
              ],
            ),
            SizedBox(
              height: Get.height * 0.30,
              child: Obx(
                    () => _controller.loading.value == true
                    ? const Center(child: CircularProgressIndicator())
                    : GridView.builder(
                  gridDelegate:
                  const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    childAspectRatio: 0.66,
                    mainAxisSpacing: 10.0,
                    crossAxisSpacing: 10.0,
                  ),
                  scrollDirection: Axis.horizontal,
                  itemCount: _controller.allDataByDaily.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      elevation: 5.0,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _controller.allDataByDaily[index]['day']
                                  .toString(),
                              style: const TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold),
                            ),
                            const Divider(thickness: 1.0),
                            Text(
                              _controller.allDataByDaily[index]['daily_total']
                                  .toString(),
                              style: const TextStyle(fontSize: 20.0),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maneger/controller/admin/admin_maneger_controller.dart';

class ManagerScreen extends StatelessWidget {
  ManagerScreen({super.key});
  final AdminManegerController adminManegerController = Get.put(
    AdminManegerController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 20),
          SizedBox(
            height: 150,
            child: newMethod(
              context,
              Center(
                child: Text('طلبات التجار', style: TextStyle(fontSize: 30)),
              ),
            ),
          ),
          newMethod(
            context,
            TextButton(
              onPressed: () {
                adminManegerController.getVendorRequest();
              },
              child: Text('تحديث'),
            ),
          ),
          Expanded(
            child: Obx(
              () => adminManegerController.admin.isEmpty
                  ? newMethod(
                      context,
                      Center(
                        child: Text('فارغ', style: TextStyle(fontSize: 30)),
                      ),
                    )
                  : adminManegerController.isAdminLoading.value
                  ? CircularProgressIndicator()
                  : ListView.builder(
                      itemCount: adminManegerController.admin.length,

                      // scrollDirection: Axis.vertical,
                      itemBuilder: (c, i) => newMethod(
                        context,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Text(
                                  adminManegerController.admin[i].userName
                                      .toString(),
                                ),

                                Text(
                                  adminManegerController.admin[i].userPhone
                                      .toString(),
                                ),
                              ],
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              margin: EdgeInsets.symmetric(horizontal: 5),
                              child: Row(
                                children: [
                                  Text(
                                    'رفض',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Icon(
                                    Icons.error_outline_sharp,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                margin: EdgeInsets.symmetric(horizontal: 5),
                                child: Row(
                                  children: [
                                    Text(
                                      'قبول',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Icon(Icons.check, color: Colors.white),

                                    // },
                                  ],
                                ),
                              ),
                              onTap: () => adminManegerController.acceptAdmin(
                                adminManegerController.admin[i].userId,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
      // ),
    );
  }

  Container newMethod(BuildContext context, Widget widget) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: 7),
      padding: EdgeInsets.all(20),
      color: Theme.of(context).colorScheme.surface,
      child: widget,
    );
  }
}

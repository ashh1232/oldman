import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maneger/controller/admin_maneger_controller.dart';

class ManagerScreen extends StatelessWidget {
  ManagerScreen({super.key});
  final AdminManegerController adminManegerController = Get.put(
    AdminManegerController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.blue,
      body:
          // SingleChildScrollView(
          //   child:
          Column(
            children: [
              SizedBox(height: 20),
              Container(
                height: 150,
                child: newMethod(
                  context,
                  Center(
                    child: Text('طلبات التجار', style: TextStyle(fontSize: 30)),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  // height: MediaQuery.of(context).size.height / 2,
                  child: Obx(
                    () => ListView.builder(
                      itemCount: adminManegerController.admin.length,

                      // scrollDirection: Axis.vertical,
                      itemBuilder: (c, i) => newMethod(
                        context,
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
                            Text(
                              adminManegerController.admin[i].userImage
                                  .toString(),
                            ),
                            // Text(
                            //   adminManegerController.admin[i].userRole.toString(),
                            // ),
                            // Text(
                            //   adminManegerController.admin[i].userStatus.toString(),
                            // ),
                            // Text(
                            //   adminManegerController.admin[i].userCreatedAt
                            //       .toString(),
                            // ),
                            // Text(
                            //   adminManegerController.admin[i].userUpdatedAt
                            //       .toString(),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
            // ),
          ),
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

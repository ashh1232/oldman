import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ManagerScreen extends StatelessWidget {
  const ManagerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.blue,
      body: SingleChildScrollView(
        child: Column(
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
            Container(
              height: MediaQuery.of(context).size.height / 2,
              child: ListView.builder(
                itemCount: 20,

                // scrollDirection: Axis.vertical,
                itemBuilder: (c, i) => newMethod(context, Text('data')),
              ),
            ),
            Container(
              height: 150,
              child: newMethod(
                context,
                Center(
                  child: Text('طلبات التجار', style: TextStyle(fontSize: 30)),
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height / 2,
              child: ListView.builder(
                itemCount: 20,

                // scrollDirection: Axis.vertical,
                itemBuilder: (c, i) => newMethod(context, Text('aaaa')),
              ),
            ),
          ],
        ),
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

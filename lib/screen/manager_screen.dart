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
            Container(
              padding: EdgeInsets.only(top: 50),
              height: 200,
              color: Colors.amber,
              child: ListView.builder(
                itemCount: 200,
                scrollDirection: Axis.horizontal,

                itemBuilder: (c, i) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('data'),
                ),
              ),
            ),
            newMethod(context, Text('data')),
            newMethod(context, Text('data')),
            newMethod(context, Text('data')),
            newMethod(context, Text('data')),
            newMethod(context, Text('data')),
            newMethod(context, Text('data')),
            newMethod(context, Text('data')),
            newMethod(context, Text('data')),
            newMethod(context, Text('data')),
            newMethod(context, Text('data')),
            newMethod(context, Text('data')),
            newMethod(context, Text('data')),
            newMethod(context, Text('data')),
            newMethod(context, Text('data')),
          ],
        ),
      ),
    );
  }

  Container newMethod(BuildContext context, Widget widget) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 7),
      padding: EdgeInsets.all(20),
      color: Theme.of(context).colorScheme.surface,
      child: widget,
    );
  }
}

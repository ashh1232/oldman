import 'package:flutter/material.dart';

class TalContainer extends StatelessWidget {
  const TalContainer({
    super.key,
    this.title = '',
    this.titleIcon = const SizedBox.shrink(),
    this.desc = '',
    this.body = const SizedBox.shrink(),
  });
  final String title;
  final Widget titleIcon;
  final String desc;
  final Widget body;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 3),
      color: Theme.of(context).colorScheme.surface,
      padding: EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),

                // Text(Iconaa),
                titleIcon,
              ],
            ),
          ),
          body,

          // SizedBox(height: 8),
          Text(
            desc,
            style: TextStyle(color: Colors.grey.shade700, height: 1.6),
          ),
        ],
      ),
    );
  }
}

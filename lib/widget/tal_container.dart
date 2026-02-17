import 'package:flutter/material.dart';

class TalContainer extends StatelessWidget {
  const TalContainer({
    super.key,
    this.noTitle = false,
    this.title = '',
    this.titleIcon = const SizedBox.shrink(),
    this.desc = '',
    this.body = const SizedBox.shrink(),
  });
  final String title;
  final Widget titleIcon;
  final String desc;
  final Widget body;
  final bool noTitle;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 3),
      padding: EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          noTitle
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),

                      // Text(Iconaa),
                      titleIcon,
                    ],
                  ),
                )
              : SizedBox.shrink(),
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

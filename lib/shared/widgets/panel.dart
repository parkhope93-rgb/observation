import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

class Panel extends StatelessWidget {
  final String title;
  final Widget child;

  const Panel({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: forest,
            ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}
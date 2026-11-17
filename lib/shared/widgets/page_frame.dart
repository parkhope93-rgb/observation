import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

class PageFrame extends StatelessWidget {
  final String title;
  final Widget? action;
  final Widget? child;

  const PageFrame({
    super.key,
    required this.title,
    this.action,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(32, 26, 32, 20),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Color(0xFFE5E9E3),
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.7,
                  color: forest,
                ),
              ),
              const Spacer(),
              if (action != null) action!,
            ],
          ),
        ),

        // Content
        Expanded(
          child: child ?? const SizedBox(),
        ),
      ],
    );
  }
}
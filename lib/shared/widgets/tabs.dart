import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

class Tabs extends StatelessWidget {
  final int index;
  final ValueChanged<int> onChanged;

  const Tabs({
    super.key,
    required this.index,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(3, (i) {
        return TextButton(
          onPressed: () => onChanged(i),
          child: Text(
            ['Projects', 'Tasks', 'Schedule'][i],
            style: TextStyle(
              color: index == i ? forest : Colors.black54,
              fontWeight:
                  index == i ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        );
      }),
    );
  }
}
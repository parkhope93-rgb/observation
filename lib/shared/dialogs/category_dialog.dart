import 'package:flutter/material.dart';

import '../../core/database/supabase_client.dart';

Future<void> showCategoryDialog(BuildContext context) async {
  final name = TextEditingController();

  final colors = [
    const Color(0xFF8DBB8B),
    const Color(0xFF78B5EE),
    const Color(0xFFF2D17C),
    const Color(0xFFB99AE8),
    const Color(0xFF83D0C6),
    const Color(0xFFB9BEC4),
    const Color.fromARGB(255, 235, 245, 169),
    
  ];

  Color selectedColor = colors.first;

  await showDialog(
    context: context,
    builder: (_) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        title: const Text('New Category'),

        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: name,
              decoration: const InputDecoration(
                labelText: 'Category name',
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Category Color',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            Wrap(
              spacing: 12,
              children: colors.map((color) {
                final selected = selectedColor == color;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedColor = color;
                    });
                  },
                  child: Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      // border: selected
                      //     ? Border.all(
                      //         color: forest,
                      //         width: 3,
                      //       )
                      //     : null,
                    ),
                    child: selected
                        ? const Icon(
                            Icons.check,
                            size: 18,
                            color: Colors.white,
                          )
                        : null,
                  ),
                );
              }).toList(),
            ),
          ],
        ),

        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),

          FilledButton(
            onPressed: () async {
              if (name.text.trim().isEmpty) return;

              try {
                await db.from('categories').insert({
                  'name': name.text.trim(),
                  'color':
                      '0x${selectedColor.toARGB32().toRadixString(16).padLeft(8, '0')}',
                });

                if (context.mounted) {
                  Navigator.pop(context);
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(e.toString())),
                  );
                }
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    ),
  );
}
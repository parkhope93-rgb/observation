import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/database/supabase_client.dart';

Future<bool> showEventDialog(
  BuildContext context, {
  String? categoryId,
}) async {
  final title = TextEditingController();

  String? cat = categoryId;
  DateTime date = DateTime.now();

  final cats = await db.from('categories').select().order('name');

  if (!context.mounted) {
    title.dispose();
    return false;
  }

  final result = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => StatefulBuilder(
      builder: (c, set) => AlertDialog(
        title: const Text('New Event'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: title,
              decoration: const InputDecoration(
                labelText: 'Event title',
              ),
            ),

            const SizedBox(height: 10),

            DropdownButtonFormField<String>(
              value: cat,
              decoration: const InputDecoration(
                labelText: 'Category',
              ),
              items: cats.map((x) {
                return DropdownMenuItem<String>(
                  value: x['id'].toString(),
                  child: Text(x['name']),
                );
              }).toList(),
              onChanged: (v) {
                set(() {
                  cat = v;
                });
              },
            ),

            TextButton(
              onPressed: () async {
                final d = await showDatePicker(
                  context: c,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2035),
                  initialDate: date,
                );

                if (d != null) {
                  set(() {
                    date = d;
                  });
                }
              },
              child: Text(
                DateFormat('yyyy-MM-dd').format(date),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c, false),
            child: const Text('Cancel'),
          ),

          FilledButton(
            onPressed: () async {
              if (title.text.trim().isEmpty || cat == null) return;

              try {
                await db.from('events').insert({
                  'title': title.text.trim(),
                  'category_id': cat,
                  'starts_at': date.toIso8601String(),
                });

                if (c.mounted) {
                  Navigator.pop(c, true);
                }
              } catch (e) {
                if (c.mounted) {
                  ScaffoldMessenger.of(c).showSnackBar(
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

  title.dispose();

  return result ?? false;
}
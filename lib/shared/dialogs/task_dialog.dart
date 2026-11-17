import 'package:flutter/material.dart';

import '../../core/database/supabase_client.dart';

Future<bool> showTaskDialog(
  BuildContext context, {
  String? categoryId,
  String? projectId,
}) async {
  final title = TextEditingController();

  String? cat = categoryId;
  DateTime? due;

  final cats = await db.from('categories').select().order('name');

  if (!context.mounted) {
    title.dispose();
    return false;
  }

  final result = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => StatefulBuilder(
      builder: (c, set) => AlertDialog(
        title: Text(
          projectId == null ? 'New Task' : 'New Subtask',
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: title,
              decoration: const InputDecoration(
                labelText: 'Task title',
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
              onChanged: projectId != null
                  ? null
                  : (v) {
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
                  initialDate: DateTime.now(),
                );

                if (d != null) {
                  set(() {
                    due = d;
                  });
                }
              },
              child: Text(
                due == null
                    ? 'Set due date'
                    : '${due!.year}-${due!.month.toString().padLeft(2, '0')}-${due!.day.toString().padLeft(2, '0')}',
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
                await db.from('tasks').insert({
                  'title': title.text.trim(),
                  'category_id': cat,
                  'project_id': projectId,
                  'due_date': due?.toIso8601String().split('T').first,
                  'status': 'todo',
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
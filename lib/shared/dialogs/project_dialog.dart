import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/database/supabase_client.dart';

Future<bool> showProjectDialog(
  BuildContext context, {
  String? categoryId,
}) async {
  final name = TextEditingController();
  final desc = TextEditingController();

  String? cat = categoryId;
  DateTime? due;

  final cats = await db.from('categories').select().order('name');

  if (!context.mounted) {
    name.dispose();
    desc.dispose();
    return false;
  }

  final result = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => StatefulBuilder(
      builder: (c, set) => AlertDialog(
        title: const Text('New Project'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: name,
                decoration: const InputDecoration(
                  labelText: 'Project name',
                ),
              ),

              const SizedBox(height: 10),

              TextField(
                controller: desc,
                decoration: const InputDecoration(
                  labelText: 'Description',
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
                      : DateFormat('yyyy-MM-dd').format(due!),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c, false),
            child: const Text('Cancel'),
          ),

          FilledButton(
            onPressed: () async {
              if (name.text.trim().isEmpty || cat == null) return;

              try {
                await db.from('projects').insert({
                  'name': name.text.trim(),
                  'description': desc.text,
                  'category_id': cat,
                  'due_date': due?.toIso8601String().split('T').first,
                  'progress': 0,
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

  name.dispose();
  desc.dispose();

  return result ?? false;
}
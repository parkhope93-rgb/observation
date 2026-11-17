import 'package:flutter/material.dart';

import '../../core/database/supabase_client.dart';
import '../../shared/dialogs/task_dialog.dart';
import '../../shared/widgets/page_frame.dart';
import '../../shared/widgets/task_row.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  Future<void> createTask() async {
    final created = await showTaskDialog(context);

    if (created && mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageFrame(
      title: 'Tasks',
      action: TextButton(
        onPressed: createTask,
        child: const Text('+ Task'),
      ),
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: db
            .from('tasks')
            .select('*,categories(name,color)')
            .neq('status', 'done')
            .order('due_date'),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(24),
            children: snapshot.data!
                .map((task) => TaskRow(task: task))
                .toList(),
          );
        },
      ),
    );
  }
}
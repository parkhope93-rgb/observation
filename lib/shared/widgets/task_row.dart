import 'package:flutter/material.dart';

import '../../core/database/supabase_client.dart';
import '../../core/utils/helpers.dart';

class TaskRow extends StatefulWidget {
  final Map<String, dynamic> task;

  const TaskRow({
    super.key,
    required this.task,
  });

  @override
  State<TaskRow> createState() => _TaskRowState();
}

class _TaskRowState extends State<TaskRow> {
  late bool isDone;

  @override
  void initState() {
    super.initState();
    isDone = widget.task['status'] == 'done';
  }

  @override
  void didUpdateWidget(covariant TaskRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    isDone = widget.task['status'] == 'done';
  }

  Future<void> updateStatus(bool? value) async {
    if (value == null) return;

    final previous = isDone;

    setState(() {
      isDone = value;
    });

    try {
      await db.from('tasks').update({
        'status': value ? 'done' : 'todo',
      }).eq('id', widget.task['id']);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isDone = previous;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('태스크 업데이트 실패: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final task = widget.task;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Checkbox(
        value: isDone,
        onChanged: updateStatus,
      ),
      title: Text(
        task['title'] ?? '',
        style: TextStyle(
          decoration: isDone ? TextDecoration.lineThrough : null,
        ),
      ),
      subtitle: Text(
        '${task['categories']?['name'] ?? ''}'
        '${task['project_id'] == null ? ' · Independent task' : ' · Project task'}',
      ),
      trailing: Text(
        dateLabel(task['due_date']),
        style: const TextStyle(color: Colors.black54),
      ),
    );
  }
}
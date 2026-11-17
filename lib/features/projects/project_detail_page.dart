import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/database/supabase_client.dart';

import '../../shared/dialogs/task_dialog.dart';
import '../../shared/widgets/task_row.dart';

class ProjectDetailPage extends StatefulWidget {
  final Map<String, dynamic> project;

  const ProjectDetailPage({
    super.key,
    required this.project,
  });

  @override
  State<ProjectDetailPage> createState() => _ProjectDetailPageState();
}

class _ProjectDetailPageState extends State<ProjectDetailPage> {
  Future<void> createSubtask() async {
    final created = await showTaskDialog(
      context,
      categoryId: widget.project['category_id'].toString(),
      projectId: widget.project['id'].toString(),
    );

    if (created && mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final project = widget.project;

    final progress =
        ((project['progress'] ?? 0) as num).toDouble();

    return Scaffold(
      backgroundColor: cream,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 24, 22, 14),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                ),
                Expanded(
                  child: Text(
                    project['name'] ?? 'Project',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: forest,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: createSubtask,
                  child: const Text('+ Subtask'),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Text(
              project['description'] ?? '',
              style: const TextStyle(
                color: Colors.black54,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(24),
            child: LinearProgressIndicator(
              value: (progress / 100).clamp(0.0, 1.0),
              color: forest,
              minHeight: 7,
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 28),
            child: Text(
              'Tasks',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: forest,
              ),
            ),
          ),

          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: db
                  .from('tasks')
                  .select('*,categories(name,color)')
                  .eq('project_id', project['id'])
                  .order('created_at'),
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
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  children: snapshot.data!
                      .map((task) => TaskRow(task: task))
                      .toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
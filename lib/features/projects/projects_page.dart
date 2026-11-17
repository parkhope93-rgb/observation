import 'package:flutter/material.dart';

import '../../core/database/supabase_client.dart';
import '../../shared/dialogs/project_dialog.dart';
import '../../shared/widgets/page_frame.dart';
import '../../shared/widgets/project_card.dart';

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({super.key});

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  Future<void> createProject() async {
    final created = await showProjectDialog(context);

    if (created && mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageFrame(
      title: 'Projects',
      action: TextButton(
        onPressed: createProject,
        child: const Text('+ New Project'),
      ),
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: db
            .from('projects')
            .select('*,categories(name,color)')
            .eq('archived', false)
            .order('created_at', ascending: false),
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

          return GridView.extent(
            maxCrossAxisExtent: 290,
            childAspectRatio: 1.35,
            padding: const EdgeInsets.all(24),
            children: snapshot.data!
                .map((project) => ProjectCard(project: project))
                .toList(),
          );
        },
      ),
    );
  }
}
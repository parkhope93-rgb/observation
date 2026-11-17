import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/database/supabase_client.dart';

import '../../shared/dialogs/project_dialog.dart';
import '../../shared/dialogs/task_dialog.dart';
import '../../shared/dialogs/event_dialog.dart';

import '../../shared/widgets/tabs.dart';
import '../../shared/widgets/project_card.dart';
import '../../shared/widgets/task_row.dart';
import '../../shared/widgets/event_row.dart';

class CategoryStandalonePage extends StatefulWidget {
  final Map<String, dynamic> category;

  const CategoryStandalonePage({
    super.key,
    required this.category,
  });

  @override
  State<CategoryStandalonePage> createState() =>
      _CategoryStandalonePageState();
}

class _CategoryStandalonePageState
    extends State<CategoryStandalonePage> {
  int tab = 0;

  String get categoryId => widget.category['id'].toString();

  Future<void> createItem() async {
    bool created = false;

    if (tab == 0) {
      created = await showProjectDialog(
        context,
        categoryId: categoryId,
      );
    } else if (tab == 1) {
      created = await showTaskDialog(
        context,
        categoryId: categoryId,
      );
    } else {
      created = await showEventDialog(
        context,
        categoryId: categoryId,
      );
    }

    if (created && mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cream,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                ),

                Text(
                  widget.category['name'],
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: forest,
                  ),
                ),

                const Spacer(),

                TextButton(
                  onPressed: createItem,
                  child: Text(
                    tab == 0
                        ? '+ New Project'
                        : tab == 1
                            ? '+ Task'
                            : '+ Event',
                  ),
                ),
              ],
            ),
          ),

          Tabs(
            index: tab,
            onChanged: (value) {
              setState(() {
                tab = value;
              });
            },
          ),

          Expanded(
            child: _content(),
          ),
        ],
      ),
    );
  }

  Widget _content() {
    if (tab == 0) {
      return FutureBuilder<List<Map<String, dynamic>>>(
        future: db
            .from('projects')
            .select('*,categories(name,color)')
            .eq('category_id', categoryId)
            .eq('archived', false),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            padding: const EdgeInsets.all(22),
            children: snapshot.data!
                .map((project) => ProjectCard(project: project))
                .toList(),
          );
        },
      );
    }

    if (tab == 1) {
      return FutureBuilder<List<Map<String, dynamic>>>(
        future: db
            .from('tasks')
            .select('*,categories(name,color)')
            .eq('category_id', categoryId)
            .order('due_date'),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            padding: const EdgeInsets.all(22),
            children: snapshot.data!
                .map((task) => TaskRow(task: task))
                .toList(),
          );
        },
      );
    }

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: db
          .from('events')
          .select('*,categories(name,color)')
          .eq('category_id', categoryId)
          .order('starts_at'),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        }

        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView(
          padding: const EdgeInsets.all(22),
          children: snapshot.data!
              .map((event) => EventRow(event: event))
              .toList(),
        );
      },
    );
  }
}
import 'package:flutter/material.dart';

import '../../core/database/supabase_client.dart';
import '../../core/utils/helpers.dart';

import '../../shared/dialogs/category_dialog.dart';
import '../../shared/dialogs/project_dialog.dart';
import '../../shared/dialogs/task_dialog.dart';
import '../../shared/dialogs/event_dialog.dart';

import '../../shared/widgets/page_frame.dart';
import '../../shared/widgets/tabs.dart';
import '../../shared/widgets/project_card.dart';
import '../../shared/widgets/task_row.dart';
import '../../shared/widgets/event_row.dart';

import 'category_standalone_page.dart';

class CategoryPage extends StatefulWidget {
  final String? categoryId;
  final String? categoryName;

  const CategoryPage({
    super.key,
    this.categoryId,
    this.categoryName,
  });

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  int tab = 0;

  @override
  void didUpdateWidget(covariant CategoryPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.categoryId != widget.categoryId) {
      tab = 0;
    }
  }

  Future<void> createItem() async {
    bool created = false;

    if (tab == 0) {
      created = await showProjectDialog(
        context,
        categoryId: widget.categoryId,
      );
    } else if (tab == 1) {
      created = await showTaskDialog(
        context,
        categoryId: widget.categoryId,
      );
    } else {
      created = await showEventDialog(
        context,
        categoryId: widget.categoryId,
      );
    }

    if (created && mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.categoryId == null) {
      return _buildCategoryList();
    }

    return PageFrame(
      title: widget.categoryName ?? 'Category',
      action: TextButton(
        onPressed: createItem,
        child: Text(
          tab == 0
              ? '+ New Project'
              : tab == 1
                  ? '+ Task'
                  : '+ Event',
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Tabs(
            index: tab,
            onChanged: (value) {
              setState(() {
                tab = value;
              });
            },
          ),
          Expanded(
            child: _categoryContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryList() {
  return PageFrame(
    title: 'Categories',
    action: TextButton(
      onPressed: () async {
        await showCategoryDialog(context);

        if (mounted) {
          setState(() {});
        }
      },
      child: const Text('+ Category'),
    ),
    child: FutureBuilder<List<Map<String, dynamic>>>(
      future: db.from('categories').select().order('name'),
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

        final categories = snapshot.data!;

        return Padding(
          padding: const EdgeInsets.fromLTRB(32, 28, 32, 32),
          child: Align(
            alignment: Alignment.topLeft,
            child: Wrap(
              spacing: 14,
              runSpacing: 14,
              children: categories.map((category) {
                final color = catColor(category['color']);

                return InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => CategoryStandalonePage(
                          category: category,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 17,
                      vertical: 13,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFFE8EBE6),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 13,
                          height: 13,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                          ),
                        ),

                        const SizedBox(width: 11),

                        Text(
                          category['name'],
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.3,
                            color: Color(0xFF343B34),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    ),
  );
}

  Widget _categoryContent() {
    final id = widget.categoryId!;

    if (tab == 0) {
      return FutureBuilder<List<Map<String, dynamic>>>(
        future: db
            .from('projects')
            .select('*,categories(name,color)')
            .eq('category_id', id)
            .eq('archived', false),
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
            padding: const EdgeInsets.all(22),
            children: snapshot.data!
                .map((project) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: ProjectCard(project: project),
                    ))
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
            .eq('category_id', id)
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
            padding: const EdgeInsets.all(22),
            children:
                snapshot.data!.map((task) => TaskRow(task: task)).toList(),
          );
        },
      );
    }

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: db
          .from('events')
          .select('*,categories(name,color)')
          .eq('category_id', id)
          .order('starts_at'),
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
          padding: const EdgeInsets.all(22),
          children:
              snapshot.data!.map((event) => EventRow(event: event)).toList(),
        );
      },
    );
  }
}

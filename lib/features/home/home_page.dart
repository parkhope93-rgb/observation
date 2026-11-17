import 'package:flutter/material.dart';

import '../../core/database/supabase_client.dart';
import '../../shared/dialogs/project_dialog.dart';
import '../../shared/widgets/page_frame.dart';
import '../../shared/widgets/panel.dart';
import '../../shared/widgets/project_card.dart';
import '../../shared/widgets/task_row.dart';
import '../../shared/widgets/event_row.dart';

class HomePage extends StatefulWidget {
  final ValueChanged<Map<String, dynamic>> onCategory;

  const HomePage({
    super.key,
    required this.onCategory,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<dynamic>> _homeFuture;

  @override
  void initState() {
    super.initState();
    _homeFuture = loadHomeData();
  }

  Future<List<dynamic>> loadHomeData() async {
    debugPrint('===== HOME DATA START =====');

    try {
      final now = DateTime.now();

      final today = DateTime(now.year, now.month, now.day);
      final tomorrow = today.add(const Duration(days: 1));

      final results = await Future.wait([
        db
            .from('projects')
            .select('*,categories(name,color)')
            .eq('archived', false)
            .order('due_date'),
        db
            .from('tasks')
            .select('*,categories(name,color)')
            .eq('status', 'todo')
            .order('due_date'),
        db
            .from('events')
            .select('*,categories(name,color)')
            .gte('starts_at', today.toIso8601String())
            .lt('starts_at', tomorrow.toIso8601String())
            .order('starts_at'),
      ]);

      debugPrint('Projects: ${results[0].length}');
      debugPrint('Tasks: ${results[1].length}');
      debugPrint('Events: ${results[2].length}');

      debugPrint('===== HOME DATA SUCCESS =====');

      return results;
    } catch (e, stack) {
      debugPrint('===== HOME DATA ERROR =====');
      debugPrint(e.toString());
      debugPrint(stack.toString());

      rethrow;
    }
  }

  Future<void> createProject() async {
    final created = await showProjectDialog(context);

    if (created && mounted) {
      setState(() {
        _homeFuture = loadHomeData();
      });
    }
  }

  String getFormattedDate() {
    final now = DateTime.now();

    const weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];

    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return '${weekdays[now.weekday - 1]}, '
        '${months[now.month - 1]} ${now.day}, ${now.year}';
  }

  @override
  Widget build(BuildContext context) {
    return PageFrame(
      title: 'Overview',
      action: TextButton(
        onPressed: createProject,
        child: const Text('+ New Project'),
      ),
      child: FutureBuilder<List<dynamic>>(
        future: _homeFuture,
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

          final projects = snapshot.data![0] as List;
          final tasks = snapshot.data![1] as List;
          final events = snapshot.data![2] as List;

          return ListView(
            padding: const EdgeInsets.all(26),
            children: [
              // Greeting
              _buildGreeting(),

              const SizedBox(height: 24),

              // Summary Cards
              LayoutBuilder(
                builder: (context, box) {
                  final cardWidth = box.maxWidth > 800
                      ? (box.maxWidth - 36) / 3
                      : box.maxWidth > 500
                          ? (box.maxWidth - 16) / 2
                          : box.maxWidth;

                  return Wrap(
                    spacing: 18,
                    runSpacing: 18,
                    children: [
                      SizedBox(
                        width: cardWidth,
                        child: _SummaryCard(
                          title: 'Active Projects',
                          value: projects.length.toString(),
                          icon: Icons.folder_outlined,
                          color: const Color(0xFF8DBB8B),
                        ),
                      ),
                      SizedBox(
                        width: cardWidth,
                        child: _SummaryCard(
                          title: 'Open Tasks',
                          value: tasks.length.toString(),
                          icon: Icons.check_circle_outline,
                          color: const Color(0xFF78B5EE),
                        ),
                      ),
                      SizedBox(
                        width: cardWidth,
                        child: _SummaryCard(
                          title: "Today's Schedule",
                          value: events.length.toString(),
                          icon: Icons.calendar_today_outlined,
                          color: const Color(0xFFB99AE8),
                        ),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 34),

              // Projects
              _buildSectionTitle(
                'In Progress',
                'Your active projects',
              ),

              const SizedBox(height: 16),

              if (projects.isEmpty)
                _buildEmptyMessage('No active projects yet.')
              else
                Wrap(
                  spacing: 14,
                  runSpacing: 14,
                  children: projects.take(8).map((project) {
                    return SizedBox(
                      width: 220,
                      child: ProjectCard(project: project),
                    );
                  }).toList(),
                ),

              const SizedBox(height: 34),

              // Tasks & Schedule
              LayoutBuilder(
                builder: (context, box) {
                  final width = box.maxWidth > 900
                      ? (box.maxWidth - 20) / 2
                      : box.maxWidth;

                  return Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    children: [
                      SizedBox(
                        width: width,
                        child: Panel(
                          title: "Today's Tasks",
                          child: tasks.isEmpty
                              ? _buildEmptyMessage(
                                  'No pending tasks.',
                                )
                              : Column(
                                  children: tasks
                                      .take(6)
                                      .map(
                                        (task) => TaskRow(task: task),
                                      )
                                      .toList(),
                                ),
                        ),
                      ),
                      SizedBox(
                        width: width,
                        child: Panel(
                          title: "Today's Schedule",
                          child: events.isEmpty
                              ? _buildEmptyMessage(
                                  'No schedules for today.',
                                )
                              : Column(
                                  children: events
                                      .map(
                                        (event) => EventRow(event: event),
                                      )
                                      .toList(),
                                ),
                        ),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 30),
            ],
          );
        },
      ),
    );
  }

  Widget _buildGreeting() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 28,
        vertical: 24,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F3EF),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  getFormattedDate(),
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF7B827A),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Aaaa... Fighting...~',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF343B34),
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'I\'m just speaking potato.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF777F76),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Image.asset(
            'assets/images/bugam_morning.png',
            width: 85,
            height: 85,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF929292),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyMessage(String message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: Text(
          message,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF999999),
          ),
        ),
      ),
    );
  }
}

// Summary Card

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFEAEAEA),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF888888),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



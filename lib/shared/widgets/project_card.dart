import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/utils/helpers.dart';

import '../../features/projects/project_detail_page.dart';

class ProjectCard extends StatelessWidget {
  final Map<String, dynamic> project;

  const ProjectCard({
    super.key,
    required this.project,
  });

  @override
  Widget build(BuildContext context) {
    final progress =
        ((project['progress'] ?? 0) as num).toDouble();

    final color = catColor(
      project['color'] ?? project['categories']?['color'],
    );

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProjectDetailPage(project: project),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(.10),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.folder_open_outlined,
              color: forest,
            ),

            const SizedBox(height: 10),

            Text(
              project['name'] ?? '',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              project['categories']?['name'] ?? '',
              style: const TextStyle(
                color: forest,
                fontSize: 12,
              ),
            ),

            const SizedBox(height: 8),

            LinearProgressIndicator(
              value: (progress / 100).clamp(0.0, 1.0),
              color: color,
              backgroundColor: Colors.white,
              minHeight: 6,
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                Text(
                  '${progress.round()}%',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const Spacer(),

                Text(
                  dateLabel(project['due_date']),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
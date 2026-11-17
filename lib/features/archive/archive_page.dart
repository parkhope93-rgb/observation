import 'package:flutter/material.dart';

import '../../core/database/supabase_client.dart';
import '../../shared/widgets/page_frame.dart';

class ArchivePage extends StatelessWidget {
  const ArchivePage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageFrame(
      title: 'Archive',
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: db
            .from('projects')
            .select()
            .eq('archived', true),
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
            children: snapshot.data!.map((project) {
              return ListTile(
                title: Text(project['name'] ?? ''),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
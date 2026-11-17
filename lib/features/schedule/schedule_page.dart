import 'package:flutter/material.dart';

import '../../core/database/supabase_client.dart';
import '../../shared/dialogs/event_dialog.dart';
import '../../shared/widgets/page_frame.dart';
import '../../shared/widgets/event_row.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  Future<void> createEvent() async {
    final created = await showEventDialog(context);

    if (created && mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageFrame(
      title: 'Schedule',
      action: TextButton(
        onPressed: createEvent,
        child: const Text('+ Event'),
      ),
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: db
            .from('events')
            .select('*,categories(name,color)')
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
            padding: const EdgeInsets.all(24),
            children: snapshot.data!
                .map((event) => EventRow(event: event))
                .toList(),
          );
        },
      ),
    );
  }
}
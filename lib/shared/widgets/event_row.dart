import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/utils/helpers.dart';

class EventRow extends StatelessWidget {
  final Map<String, dynamic> event;

  const EventRow({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    final startsAt = DateTime.parse(event['starts_at']);

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 48,
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: catColor(event['categories']?['color'])
              .withOpacity(.18),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(DateFormat('MM.dd').format(startsAt)),
      ),
      title: Text(
        event['title'] ?? '',
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(DateFormat('HH:mm').format(startsAt)),
      trailing: Text(
        event['categories']?['name'] ?? '',
      ),
    );
  }
}
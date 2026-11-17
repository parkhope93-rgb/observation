import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


// Date Label
String dateLabel(dynamic value) {
  if (value == null) return '날짜 미정';

  return DateFormat('MM.dd').format(
    DateTime.parse(value.toString()),
  );
}

// Category Color
Color catColor(dynamic value) {
  final raw = (value ?? '0xFF83D0C6')
      .toString()
      .replaceFirst('0x', '');

  return Color(
    int.tryParse(raw, radix: 16) ?? 0xFF83D0C6,
  );
}
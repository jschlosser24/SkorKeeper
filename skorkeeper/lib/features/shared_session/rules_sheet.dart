import 'package:flutter/material.dart';

Future<void> showRulesSheet(
  BuildContext context, {
  required String title,
  String? summary,
  required List<String> bullets,
}) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (context) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            if (summary != null) ...[const SizedBox(height: 8), Text(summary)],
            const SizedBox(height: 12),
            for (final bullet in bullets)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text('• $bullet'),
              ),
          ],
        ),
      ),
    ),
  );
}

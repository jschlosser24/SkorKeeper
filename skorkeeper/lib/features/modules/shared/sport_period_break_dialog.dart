import 'package:flutter/material.dart';

/// Shows a centered (non-bottom-sheet) dialog announcing the end of a
/// quarter/period/half, with a single action to start the next one.
///
/// Used by basketball, football, hockey, and lacrosse game screens so the
/// end-of-period prompt is consistently centered on screen (issue #12)
/// instead of a bottom sheet.
Future<void> showSportPeriodEndDialog(
  BuildContext context, {
  required String title,
  required String message,
  required String actionLabel,
  required VoidCallback onAction,
}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        FilledButton(
          onPressed: () {
            Navigator.of(context).pop();
            onAction();
          },
          child: Text(actionLabel),
        ),
      ],
    ),
  );
}

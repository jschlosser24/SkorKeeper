import 'package:flutter/material.dart';

Future<String?> showSportNotesSheet(
  BuildContext context, {
  String? initialValue,
}) async {
  final controller = TextEditingController(text: initialValue ?? '');
  final result = await showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 8,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              maxLines: 6,
              decoration: const InputDecoration(
                labelText: 'Game notes',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.of(context).pop(controller.text.trim()),
                child: const Text('Save Notes'),
              ),
            ),
          ],
        ),
      );
    },
  );
  controller.dispose();
  return result;
}

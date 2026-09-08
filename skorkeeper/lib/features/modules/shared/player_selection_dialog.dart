import 'package:flutter/material.dart';

import '../../../core/modules/sport_game_state.dart';

Future<String?> showPlayerSelectionDialog(
  BuildContext context, {
  required String title,
  required List<SportPlayer> players,
}) {
  return showModalBottomSheet<String>(
    context: context,
    showDragHandle: true,
    builder: (context) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(title: Text(title)),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: players.length,
                itemBuilder: (context, index) {
                  final player = players[index];
                  return ListTile(
                    leading: player.number == null
                        ? null
                        : Chip(label: Text('#${player.number}')),
                    title: Text(player.name),
                    onTap: () => Navigator.of(context).pop(player.id),
                  );
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}

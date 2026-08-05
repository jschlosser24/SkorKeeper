import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/providers/active_sessions_provider.dart';
import '../../../../core/providers/preferences_provider.dart';
import '../../../../features/shared_session/session_setup_scaffold.dart';
import '../domain/golf_module.dart';
import '../domain/golf_state.dart';

class GolfSetupScreen extends ConsumerStatefulWidget {
  const GolfSetupScreen({required this.gameTypeId, super.key});

  final String gameTypeId;

  @override
  ConsumerState<GolfSetupScreen> createState() => _GolfSetupScreenState();
}

class _GolfSetupScreenState extends ConsumerState<GolfSetupScreen> {
  late int _holeCount;
  late final TextEditingController _customHolesController;
  late final List<TextEditingController> _parControllers;

  bool get _isMiniGolf => widget.gameTypeId == 'minigolf';

  @override
  void initState() {
    super.initState();
    _holeCount = widget.gameTypeId == 'golf18' ? 18 : 9;
    _customHolesController = TextEditingController(text: _holeCount.toString());
    _parControllers = List<TextEditingController>.generate(
      36,
      (_) => TextEditingController(text: '4'),
    );
  }

  @override
  void dispose() {
    _customHolesController.dispose();
    for (final controller in _parControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _setHoleCount(int count) {
    setState(() {
      _holeCount = count;
      _customHolesController.text = count.toString();
    });
  }

  GolfModule _module() {
    if (_isMiniGolf) {
      return MiniGolfModule(selectedHoleCount: _holeCount);
    }
    return GolfModule(
      gameTypeId: widget.gameTypeId == 'golf18' ? 'golf18' : 'golf9',
      displayName: 'Golf',
      holeCount: _holeCount,
      isMiniGolf: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final names =
        ref
            .watch(preferencesNotifierProvider)
            .valueOrNull
            ?.defaultPlayerNames ??
        const <String>[];
    return SessionSetupScaffold(
      module: _module(),
      initialPlayerNames: names,
      extraContent: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Number of Holes',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          // Quick-select buttons
          Row(
            children: [
              for (final preset in [9, 18])
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text('$preset Holes'),
                    labelStyle: TextStyle(
                      color: _holeCount == preset
                          ? Theme.of(context).colorScheme.onSecondaryContainer
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    selected: _holeCount == preset,
                    onSelected: (_) => _setHoleCount(preset),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          // Custom hole count entry
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _customHolesController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    labelText: 'Custom hole count',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    final parsed = int.tryParse(value);
                    if (parsed != null && parsed > 0 && parsed <= 36) {
                      setState(() => _holeCount = parsed);
                    }
                  },
                ),
              ),
            ],
          ),
          if (!_isMiniGolf) ...[
            const SizedBox(height: 16),
            Text('Par values', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (var i = 0; i < _holeCount; i++)
                  SizedBox(
                    width: 72,
                    child: TextField(
                      controller: _parControllers[i],
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'H${i + 1}',
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
      onStartGame: (result) async {
        final module = _module();
        final pars = _isMiniGolf
            ? List<int>.filled(_holeCount, 0)
            : List<int>.generate(
                _holeCount,
                (index) => int.tryParse(_parControllers[index].text) ?? 4,
              );
        final state = GolfState(
          holeCount: _holeCount,
          pars: pars,
          scores: {
            for (final player in result.players)
              player.id: List<int?>.filled(_holeCount, null),
          },
          isMiniGolf: _isMiniGolf,
          currentHole: 1,
        );
        final sessionId = await ref
            .read(activeSessionsNotifierProvider.notifier)
            .createSession(
              gameType: module.gameTypeId,
              sessionName: result.sessionName,
              players: result.players,
              initialModuleState: state.toJson(),
            );
        if (context.mounted) {
          context.go('/home/session/$sessionId');
        }
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/providers/preferences_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _playerNameController = TextEditingController();

  @override
  void dispose() {
    _playerNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final preferences = ref.watch(preferencesNotifierProvider);
    final notifier = ref.read(preferencesNotifierProvider.notifier);
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: preferences.when(
        data: (prefs) => ListView(
          children: [
            const _SectionHeader('Appearance'),
            ListTile(
              title: const Text('Theme'),
              subtitle: Text(
                prefs.themeMode.name[0].toUpperCase() +
                    prefs.themeMode.name.substring(1),
              ),
              trailing: SegmentedButton<ThemeMode>(
                segments: const [
                  ButtonSegment(value: ThemeMode.system, label: Text('Auto')),
                  ButtonSegment(value: ThemeMode.light, label: Text('Light')),
                  ButtonSegment(value: ThemeMode.dark, label: Text('Dark')),
                ],
                selected: {prefs.themeMode},
                onSelectionChanged: (selection) =>
                    notifier.updateThemeMode(selection.first),
              ),
            ),
            const _SectionHeader('Audio & Feedback'),
            SwitchListTile(
              title: const Text('Sound Effects'),
              value: prefs.soundEnabled,
              onChanged: (value) => notifier.updateSoundEnabled(value),
            ),
            SwitchListTile(
              title: const Text('Haptic Feedback'),
              value: prefs.hapticEnabled,
              onChanged: (value) => notifier.updateHapticEnabled(value),
            ),
            SwitchListTile(
              title: const Text('Shake to Roll Dice'),
              value: prefs.shakeToRollEnabled,
              onChanged: (value) => notifier.updateShakeEnabled(value),
            ),
            ListTile(
              title: const Text('Shake Sensitivity'),
              subtitle: Slider(
                value: prefs.shakeSensitivity,
                min: 5,
                max: 30,
                divisions: 25,
                label: prefs.shakeSensitivity.toStringAsFixed(0),
                onChanged: (value) => notifier.updateShakeSensitivity(value),
              ),
            ),
            const _SectionHeader('Default Players'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _playerNameController,
                      decoration: const InputDecoration(
                        labelText: 'Add player name',
                        border: OutlineInputBorder(),
                      ),
                      onSubmitted: (_) => _addName(prefs.defaultPlayerNames),
                    ),
                  ),
                  const SizedBox(width: 12),
                  FilledButton.icon(
                    onPressed: () => _addName(prefs.defaultPlayerNames),
                    icon: const Icon(Icons.add),
                    label: const Text('Add'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final name in prefs.defaultPlayerNames)
                    InputChip(
                      label: Text(name),
                      onDeleted: () {
                        final updated = [...prefs.defaultPlayerNames]
                          ..remove(name);
                        notifier.updateDefaultPlayerNames(updated);
                      },
                    ),
                  if (prefs.defaultPlayerNames.isEmpty)
                    const Text('No saved default players yet.'),
                ],
              ),
            ),

            // ── FAQ ─────────────────────────────────────────────────────────
            const _SectionHeader('Frequently Asked Questions'),
            const _FaqSection(),

            // ── Feedback ────────────────────────────────────────────────────
            const _SectionHeader('Feedback & Bug Reports'),
            const _FeedbackSection(),

            // ── About ────────────────────────────────────────────────────────
            const _SectionHeader('About'),
            ListTile(
              leading: Icon(
                Icons.new_releases_outlined,
                color: Theme.of(context).colorScheme.tertiary,
              ),
              title: const Text("What's New"),
              subtitle: const Text('View recent updates, features, and fixes'),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => context.push('/settings/updates'),
            ),
            const ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('SkorKeeper'),
              subtitle: Text('v1.0.0 • All-In-One Scoring & Game Tools'),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) =>
            Center(child: Text('Error: ' + error.toString())),
      ),
    );
  }

  void _addName(List<String> currentNames) {
    final name = _playerNameController.text.trim();
    if (name.isEmpty) {
      return;
    }
    ref.read(preferencesNotifierProvider.notifier).updateDefaultPlayerNames([
      ...currentNames,
      name,
    ]);
    _playerNameController.clear();
  }
}

// ── Section header ────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}

// ── FAQ section ───────────────────────────────────────────────────────────────

class _FaqSection extends StatefulWidget {
  const _FaqSection();

  @override
  State<_FaqSection> createState() => _FaqSectionState();
}

class _FaqSectionState extends State<_FaqSection> {
  static const _faqs = <({String question, String answer})>[
    (
      question: 'How do I start a new game?',
      answer:
          'From the Games tab, choose a game type or tap Custom Scoring to start a flexible session. Tap "Start Game" after configuring players.',
    ),
    (
      question: 'How do I add more players?',
      answer:
          'On any game setup screen, tap the + button next to the player count. You can save default player names in Settings → Default Players.',
    ),
    (
      question: 'How do I use Custom Scoring?',
      answer:
          'Custom Scoring lets you track any game. Set a game name, choose High Wins or Low Wins, add players, then tap cells to enter scores each round. Use "Add Round" to add more rounds.',
    ),
    (
      question: 'How do I use the Tools?',
      answer:
          'The Tools tab gives you a dice roller, coin flip, spinner, timer, stopwatch, lives counter, tally counter, notepad, and team picker — all available offline.',
    ),
    (
      question: 'How do I resume a game?',
      answer:
          'Active sessions are shown on the Games home screen. Tap the "Resume active session" card to continue where you left off.',
    ),
    (
      question: 'How does Farkle scoring work?',
      answer:
          'Roll all 6 dice. Tap dice to hold scoring ones (1s = 100, 5s = 50, three of a kind = face × 100, three 1s = 1000). Roll remaining dice or bank your turn score. A roll with no scoring dice is a Farkle — you lose your turn score!',
    ),
    (
      question: 'How does Cricket (Darts) work?',
      answer:
          'Close targets 15-20 and Bull by hitting each 3 times (/, X, ⊗). After closing a target, additional hits score points — until all players close it. First player to close all targets with equal or more points wins.',
    ),
    (
      question: 'Can I change the theme?',
      answer:
          'Yes! Go to Settings → Appearance → Theme and choose Auto (follows system), Light, or Dark.',
    ),
    (
      question: 'Does the app work offline?',
      answer:
          'Yes — SkorKeeper is fully offline. All data is stored locally on your device.',
    ),
  ];

  final Set<int> _expanded = {};

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < _faqs.length; i++)
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              initiallyExpanded: _expanded.contains(i),
              onExpansionChanged: (val) {
                setState(() {
                  if (val) {
                    _expanded.add(i);
                  } else {
                    _expanded.remove(i);
                  }
                });
              },
              leading: Icon(
                Icons.help_outline,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: Text(
                _faqs[i].question,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: Text(
                    _faqs[i].answer,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

// ── Feedback section ──────────────────────────────────────────────────────────

class _FeedbackSection extends StatefulWidget {
  const _FeedbackSection();

  @override
  State<_FeedbackSection> createState() => _FeedbackSectionState();
}

class _FeedbackSectionState extends State<_FeedbackSection> {
  final _typeController = ValueNotifier<_FeedbackType>(_FeedbackType.general);
  final _messageController = TextEditingController();
  bool _submitted = false;

  @override
  void dispose() {
    _messageController.dispose();
    _typeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_submitted) {
      return ListTile(
        leading: Icon(
          Icons.check_circle_outline,
          color: Theme.of(context).colorScheme.tertiary,
        ),
        title: const Text('Thanks for your feedback!'),
        subtitle: const Text('Your message has been noted.'),
        trailing: TextButton(
          onPressed: () => setState(() => _submitted = false),
          child: const Text('Send more'),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Help us improve SkorKeeper by sharing your thoughts or reporting issues.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          ValueListenableBuilder<_FeedbackType>(
            valueListenable: _typeController,
            builder: (context, type, _) => SegmentedButton<_FeedbackType>(
              style: SegmentedButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
                selectedForegroundColor: Theme.of(
                  context,
                ).colorScheme.onSecondaryContainer,
                selectedBackgroundColor: Theme.of(
                  context,
                ).colorScheme.secondaryContainer,
                side: BorderSide(
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              segments: const [
                ButtonSegment(
                  value: _FeedbackType.general,
                  label: Text('General'),
                  icon: Icon(Icons.thumb_up_outlined),
                ),
                ButtonSegment(
                  value: _FeedbackType.bug,
                  label: Text('Bug'),
                  icon: Icon(Icons.bug_report_outlined),
                ),
                ButtonSegment(
                  value: _FeedbackType.feature,
                  label: Text('Feature'),
                  icon: Icon(Icons.lightbulb_outline),
                ),
              ],
              selected: {type},
              onSelectionChanged: (value) =>
                  _typeController.value = value.first,
            ),
          ),
          const SizedBox(height: 12),
          ValueListenableBuilder<_FeedbackType>(
            valueListenable: _typeController,
            builder: (context, type, _) => TextField(
              controller: _messageController,
              maxLines: 4,
              maxLength: 500,
              decoration: InputDecoration(
                labelText: type == _FeedbackType.bug
                    ? 'Describe the bug and steps to reproduce it'
                    : type == _FeedbackType.feature
                    ? 'Describe the feature you would like'
                    : 'Share your thoughts',
                border: const OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _submitFeedback,
              icon: const Icon(Icons.send_outlined),
              label: const Text('Submit Feedback'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submitFeedback() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a message before submitting.'),
        ),
      );
      return;
    }
    final subject = switch (_typeController.value) {
      _FeedbackType.bug => 'SkorKeeper Bug Feedback',
      _FeedbackType.feature => 'SkorKeeper Feature Feedback',
      _FeedbackType.general => 'SkorKeeper Feedback',
    };
    final emailUri = Uri(
      scheme: 'mailto',
      path: 'schlosser.joe24@gmail.com',
      query:
          'subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(message)}',
    );
    final launched = await launchUrl(emailUri);
    if (!launched) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not open your email app to send feedback.'),
        ),
      );
      return;
    }
    _messageController.clear();
    if (mounted) {
      setState(() => _submitted = true);
    }
  }
}

enum _FeedbackType { general, bug, feature }

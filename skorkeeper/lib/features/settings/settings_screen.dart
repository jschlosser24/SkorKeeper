import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/models/session_player.dart';
import '../../core/models/user_preferences.dart';
import '../../core/monetization/app_theme_id.dart';
import '../../core/monetization/monetized_banner.dart';
import '../../core/monetization/sound_pack_catalog.dart';
import '../../core/monetization/theme_catalog.dart';
import '../../core/providers/preferences_provider.dart';
import '../../core/providers/pro_state_provider.dart';
import '../sports_hub/application/sports_entitlement_notifier.dart';
import '../sports_hub/presentation/sports_purchase_sheet.dart';
import 'pro_purchase_sheet.dart';
import 'tip_jar_sheet.dart';

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
    final isPro = ref.watch(proStateNotifierProvider).valueOrNull ?? false;
    final sportsEntitlement =
        ref.watch(sportsEntitlementNotifierProvider).valueOrNull;
    final hasSportsPlan = sportsEntitlement?.hasSportsPlan ?? false;
    final hasSportsPro = sportsEntitlement?.hasSportsPro ?? false;
    final notifier = ref.read(preferencesNotifierProvider.notifier);
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      bottomNavigationBar: const MonetizedBanner(),
      body: preferences.when(
        data: (prefs) => ListView(
          children: [
            const _SectionHeader('SkorKeeper Pro'),
            if (isPro)
              ListTile(
                leading: Icon(
                  Icons.star,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
                title: const Text('SkorKeeper Pro'),
                subtitle: const Text(
                  'Active — thank you for supporting SkorKeeper!',
                ),
                trailing: Icon(
                  Icons.check_circle,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
                onTap: () => showProPurchaseSheet(context),
              )
            else
              ListTile(
                leading: Icon(
                  Icons.star_outline,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
                title: const Text('SkorKeeper Pro'),
                subtitle: const Text(
                  'Ad-free · All themes · Unlimited history · \$3.99',
                ),
                trailing: FilledButton(
                  onPressed: () => showProPurchaseSheet(context),
                  child: const Text('Get Pro'),
                ),
              ),
            const _SectionHeader('Sports'),
            ListTile(
              leading: Icon(
                hasSportsPlan ? Icons.sports_baseball : Icons.sports_baseball_outlined,
                color: Theme.of(context).colorScheme.tertiary,
              ),
              title: const Text('Sports Plan'),
              subtitle: Text(
                hasSportsPlan
                    ? 'Active — 8 sports modules, timers, and notes unlocked'
                    : 'Baseball, Basketball, Football, Soccer, Tennis, Volleyball, Hockey, Lacrosse',
              ),
              trailing: hasSportsPlan
                  ? Icon(
                      Icons.check_circle,
                      color: Theme.of(context).colorScheme.tertiary,
                    )
                  : FilledButton(
                      onPressed: () => showSportsPurchaseSheet(
                        context,
                        tier: SportsPurchaseTier.sportsPlan,
                      ),
                      child: const Text('Get Plan'),
                    ),
            ),
            ListTile(
              leading: Icon(
                hasSportsPro ? Icons.workspace_premium : Icons.workspace_premium_outlined,
                color: Theme.of(context).colorScheme.tertiary,
              ),
              title: const Text('Sports Pro'),
              subtitle: Text(
                hasSportsPro
                    ? 'Active — in-depth tracking, export, and analytics unlocked'
                    : 'In-depth tracking, export to PDF/CSV/JSON, season analytics',
              ),
              trailing: hasSportsPro
                  ? Icon(
                      Icons.check_circle,
                      color: Theme.of(context).colorScheme.tertiary,
                    )
                  : FilledButton(
                      onPressed: () => showSportsPurchaseSheet(
                        context,
                        tier: SportsPurchaseTier.sportsPro,
                        showUpgradePitch: hasSportsPlan,
                      ),
                      child: const Text('Get Pro'),
                    ),
            ),
            const _SectionHeader('Support the Developer'),
            ListTile(
              leading: const Text('❤️', style: TextStyle(fontSize: 22)),
              title: const Text('Tip Jar'),
              subtitle: const Text('Enjoying SkorKeeper? Leave a tip!'),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => showTipJarSheet(context),
            ),
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
            Builder(
              builder: (context) {
                final selectedId = prefs.selectedThemeId;
                final themeId = AppThemeId.values.firstWhere(
                  (e) => e.name == selectedId,
                  orElse: () => AppThemeId.midnightWolves,
                );
                final themeDef =
                    ThemeCatalog.findById(themeId) ?? ThemeCatalog.defaultTheme;
                return ListTile(
                  title: const Text('Color Theme'),
                  subtitle: Text('${themeDef.emoji} ${themeDef.name}'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => context.push('/settings/themes'),
                );
              },
            ),
            const _SectionHeader('Audio & Feedback'),
            SwitchListTile(
              title: const Text('Sound Effects'),
              value: prefs.soundEnabled,
              onChanged: (value) => notifier.updateSoundEnabled(value),
            ),
            if (isPro)
              Builder(
                builder: (context) {
                  final packId = notifier.currentSoundPackId;
                  final pack = SoundPacks.findById(packId);
                  return ListTile(
                    leading: Text(
                      pack.emoji,
                      style: const TextStyle(fontSize: 20),
                    ),
                    title: const Text('Sound Pack'),
                    subtitle: Text(pack.name),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => _showSoundPackPicker(context, packId),
                  );
                },
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
                      onSubmitted: (_) => _addName(prefs),
                    ),
                  ),
                  const SizedBox(width: 12),
                  FilledButton.icon(
                    onPressed: () => _addName(prefs),
                    icon: const Icon(Icons.add),
                    label: const Text('Add'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            if (prefs.defaultPlayerNames.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'No saved default players yet.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              )
            else if (isPro)
              _DefaultPlayerColorList(
                names: prefs.defaultPlayerNames,
                colors: prefs.defaultPlayerColors,
                onChanged: (names, colors) =>
                    notifier.updateDefaultPlayers(names, colors),
              )
            else
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (var i = 0; i < prefs.defaultPlayerNames.length; i++)
                      InputChip(
                        label: Text(prefs.defaultPlayerNames[i]),
                        onDeleted: () => _removeName(prefs, i),
                      ),
                  ],
                ),
              ),

            // ── FAQ ─────────────────────────────────────────────────────────
            const _SectionHeader('Frequently Asked Questions'),
            ListTile(
              leading: Icon(
                Icons.help_outline,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: const Text('FAQ'),
              subtitle: const Text('Common questions about games, Pro features, and more'),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => context.push('/settings/faq'),
            ),

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

  void _addName(UserPreferences prefs) {
    final name = _playerNameController.text.trim();
    if (name.isEmpty) return;
    final newNames = [...prefs.defaultPlayerNames, name];
    final newColors = [
      ...prefs.defaultPlayerColors,
      kDefaultPlayerColors[prefs.defaultPlayerNames.length % kDefaultPlayerColors.length],
    ];
    ref.read(preferencesNotifierProvider.notifier).updateDefaultPlayers(newNames, newColors);
    _playerNameController.clear();
  }

  void _removeName(UserPreferences prefs, int index) {
    final newNames = [...prefs.defaultPlayerNames]..removeAt(index);
    final newColors = prefs.defaultPlayerColors.length > index
        ? ([...prefs.defaultPlayerColors]..removeAt(index))
        : [...prefs.defaultPlayerColors];
    ref.read(preferencesNotifierProvider.notifier).updateDefaultPlayers(newNames, newColors);
  }

  Future<void> _showSoundPackPicker(BuildContext context, String current) async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (_) => _SoundPackPickerSheet(
        current: current,
        onSelect: (id) {
          ref.read(preferencesNotifierProvider.notifier).updateSoundPackId(id);
          Navigator.of(context).pop();
        },
      ),
    );
  }
}

// ── Sound pack picker sheet ───────────────────────────────────────────────────

class _SoundPackPickerSheet extends StatelessWidget {
  const _SoundPackPickerSheet({
    required this.current,
    required this.onSelect,
  });

  final String current;
  final void Function(String id) onSelect;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sound Pack',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'Choose the sound effects style for your games.',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
          ),
          const SizedBox(height: 16),
          for (final pack in SoundPacks.all)
            ListTile(
              leading: Text(pack.emoji, style: const TextStyle(fontSize: 22)),
              title: Text(pack.name),
              subtitle: Text(pack.description),
              trailing: current == pack.id
                  ? Icon(Icons.check_circle, color: cs.primary)
                  : null,
              onTap: () => onSelect(pack.id),
            ),
        ],
      ),
    );
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

// ── Default player color list (Pro) ──────────────────────────────────────────

class _DefaultPlayerColorList extends StatelessWidget {
  const _DefaultPlayerColorList({
    required this.names,
    required this.colors,
    required this.onChanged,
  });

  final List<String> names;
  final List<String> colors;
  final void Function(List<String> names, List<String> colors) onChanged;

  String _colorFor(int index) {
    if (index < colors.length) return colors[index];
    return kDefaultPlayerColors[index % kDefaultPlayerColors.length];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          for (var i = 0; i < names.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => _pickColor(context, i),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: _hexToColor(_colorFor(i)),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Theme.of(context).colorScheme.outline,
                          width: 1.5,
                        ),
                      ),
                      child: Icon(
                        Icons.colorize,
                        size: 14,
                        color: _contrastColor(_hexToColor(_colorFor(i))),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      names[i],
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 18),
                    onPressed: () {
                      final newNames = [...names]..removeAt(i);
                      final newColors = List<String>.generate(
                        names.length,
                        (j) => _colorFor(j),
                      )..removeAt(i);
                      onChanged(newNames, newColors);
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _pickColor(BuildContext context, int index) async {
    final picked = await showModalBottomSheet<String>(
      context: context,
      builder: (_) => _ColorPickerSheet(current: _colorFor(index)),
    );
    if (picked == null) return;
    final newColors = List<String>.generate(names.length, (j) => _colorFor(j));
    newColors[index] = picked;
    onChanged(names, newColors);
  }

  static Color _hexToColor(String hex) {
    final clean = hex.replaceFirst('#', '');
    return Color(int.parse('FF$clean', radix: 16));
  }

  static Color _contrastColor(Color bg) {
    final luminance = bg.computeLuminance();
    return luminance > 0.4 ? Colors.black87 : Colors.white;
  }
}

class _ColorPickerSheet extends StatelessWidget {
  const _ColorPickerSheet({required this.current});

  final String current;

  static const _extraColors = [
    '#E91E63', '#9C27B0', '#3F51B5', '#2196F3', '#00BCD4',
    '#009688', '#4CAF50', '#CDDC39', '#FF9800', '#795548',
  ];

  @override
  Widget build(BuildContext context) {
    final allColors = [...kDefaultPlayerColors, ..._extraColors];
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Choose Color',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              for (final hex in allColors)
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(hex),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: _hexToColor(hex),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: hex == current
                            ? Theme.of(context).colorScheme.primary
                            : Colors.transparent,
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: hex == current
                        ? Icon(
                            Icons.check,
                            size: 20,
                            color: _contrastColor(_hexToColor(hex)),
                          )
                        : null,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  static Color _hexToColor(String hex) {
    final clean = hex.replaceFirst('#', '');
    return Color(int.parse('FF$clean', radix: 16));
  }

  static Color _contrastColor(Color bg) {
    return bg.computeLuminance() > 0.4 ? Colors.black87 : Colors.white;
  }
}

import 'package:flutter/material.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FAQ')),
      body: ListView(
        children: const [
          _FaqCategory(
            title: 'Getting Started',
            faqs: [
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
                question: 'How do I resume a game?',
                answer:
                    'Active sessions are shown on the Games home screen. Tap the "Resume active session" card to continue where you left off.',
              ),
              (
                question: 'Does the app work offline?',
                answer:
                    'Yes — SkorKeeper is fully offline. All data is stored locally on your device.',
              ),
            ],
          ),
          _FaqCategory(
            title: 'Game Rules & Scoring',
            faqs: [
              (
                question: 'How do I use Custom Scoring?',
                answer:
                    'Custom Scoring lets you track any game. Set a game name, choose High Wins or Low Wins, add players, then tap cells to enter scores each round. Use "Add Round" to add more rounds.',
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
            ],
          ),
          _FaqCategory(
            title: 'Tools',
            faqs: [
              (
                question: 'How do I use the Tools?',
                answer:
                    'The Tools tab gives you a dice roller, coin flip, spinner, timer, stopwatch, lives counter, tally counter, notepad, and team picker — all available offline.',
              ),
            ],
          ),
          _FaqCategory(
            title: 'Pro & Themes',
            faqs: [
              (
                question: 'What do I get with SkorKeeper Pro?',
                answer:
                    'Pro unlocks 7 premium color themes, 7 sound packs, default player colors, history CSV export, and removes ads. It\'s a one-time purchase.',
              ),
              (
                question: 'Can I change the theme?',
                answer:
                    'Yes! Go to Settings → Appearance to choose Auto, Light, or Dark mode, then tap Color Theme to pick from 8 themes. The free Midnight Wolves theme is always available; the other 7 require Pro.',
              ),
              (
                question: 'How do I set default player colors?',
                answer:
                    'With Pro, go to Settings → Default Players and tap the color circle next to each player name to choose their color. These carry over when you start any new game.',
              ),
            ],
          ),
          _FaqCategory(
            title: 'Sound Packs',
            faqs: [
              (
                question: 'How do I change sound effects?',
                answer:
                    'Go to Settings → Audio & Feedback → Sound Pack. Classic is free; Arcade, Nature, Jazz, Minimal, Epic, Neon, and Sports are available with Pro.',
              ),
              (
                question: 'I don\'t hear any sounds. What should I check?',
                answer:
                    'Make sure Sound Effects is toggled on in Settings → Audio & Feedback, and that your device isn\'t on silent/mute. On iOS, check that the ringer switch is not muted.',
              ),
            ],
          ),
          _FaqCategory(
            title: 'History & Export',
            faqs: [
              (
                question: 'Where is my game history?',
                answer:
                    'Tap the History tab to see all completed sessions. You can search, filter by game type, sort, and swipe to delete entries.',
              ),
              (
                question: 'How do I export my history to CSV?',
                answer:
                    'With Pro, open the History tab and tap the download icon in the top-right corner. This exports your current filtered view (or all games) to a CSV file you can share or open in a spreadsheet app.',
              ),
              (
                question: 'How do I sort the game history?',
                answer:
                    'Tap the sort icon in the History tab AppBar and choose Newest First, Oldest First, Game Type A–Z, or Winner A–Z.',
              ),
            ],
          ),
          _FaqCategory(
            title: 'Support',
            faqs: [
              (
                question: 'How do I leave a tip?',
                answer:
                    'If you enjoy the app and want to support development, go to Settings → Support the Developer → Tip Jar and choose a tip amount. Tips are one-time purchases and greatly appreciated!',
              ),
              (
                question: 'My purchase isn\'t showing up. What do I do?',
                answer:
                    'Tap Settings → SkorKeeper Pro → Restore Purchases. If that doesn\'t work, make sure you\'re signed into the same Apple/Google account used for the purchase, then try again.',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FaqCategory extends StatefulWidget {
  const _FaqCategory({required this.title, required this.faqs});

  final String title;
  final List<({String question, String answer})> faqs;

  @override
  State<_FaqCategory> createState() => _FaqCategoryState();
}

class _FaqCategoryState extends State<_FaqCategory> {
  final Set<int> _expanded = {};

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
          child: Text(
            widget.title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ),
        const Divider(height: 1),
        for (var i = 0; i < widget.faqs.length; i++)
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              initiallyExpanded: _expanded.contains(i),
              onExpansionChanged: (val) => setState(() {
                if (val) {
                  _expanded.add(i);
                } else {
                  _expanded.remove(i);
                }
              }),
              leading: Icon(
                Icons.help_outline,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: Text(
                widget.faqs[i].question,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(fontWeight: FontWeight.w500),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: Text(
                    widget.faqs[i].answer,
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

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'preferences_provider.dart';
import 'prefs_keys.dart';
import '../monetization/sound_pack_catalog.dart';

part 'audio_provider.g.dart';

class AudioService {
  AudioService({
    required AudioPlayer diceRollPlayer,
    required AudioPlayer coinFlipPlayer,
    required AudioPlayer timerAlertPlayer,
    required AudioPlayer scoreConfirmPlayer,
    required AudioPlayer bustPlayer,
    required bool Function() isSoundEnabled,
  }) : _diceRollPlayer = diceRollPlayer,
       _coinFlipPlayer = coinFlipPlayer,
       _timerAlertPlayer = timerAlertPlayer,
       _scoreConfirmPlayer = scoreConfirmPlayer,
       _bustPlayer = bustPlayer,
       _isSoundEnabled = isSoundEnabled;

  final AudioPlayer _diceRollPlayer;
  final AudioPlayer _coinFlipPlayer;
  final AudioPlayer _timerAlertPlayer;
  final AudioPlayer _scoreConfirmPlayer;
  final AudioPlayer _bustPlayer;
  final bool Function() _isSoundEnabled;

  Future<void> playDiceRoll() async => _play(_diceRollPlayer);
  Future<void> playCoinFlip() async => _play(_coinFlipPlayer);
  Future<void> playTimerAlert() async => _play(_timerAlertPlayer);
  Future<void> playScoreConfirm() async => _play(_scoreConfirmPlayer);
  Future<void> playBust() async => _play(_bustPlayer);

  Future<void> _play(AudioPlayer player) async {
    if (!_isSoundEnabled()) {
      return;
    }
    try {
      await player.seek(Duration.zero);
      await player.play();
    } catch (_) {}
  }

  void dispose() {
    _diceRollPlayer.dispose();
    _coinFlipPlayer.dispose();
    _timerAlertPlayer.dispose();
    _scoreConfirmPlayer.dispose();
    _bustPlayer.dispose();
  }
}

@Riverpod(keepAlive: true)
Future<AudioService> audioService(Ref ref) async {
  // Re-initialize whenever the sound pack changes.
  final prefs = ref.watch(preferencesNotifierProvider);
  final packId = prefs.valueOrNull != null
      ? ref.read(preferencesNotifierProvider.notifier).currentSoundPackId
      : 'classic';
  // Validate that the pack exists; fall back to classic.
  final validPackId = SoundPacks.all.any((p) => p.id == packId) ? packId : 'classic';

  final diceRoll = AudioPlayer();
  final coinFlip = AudioPlayer();
  final timerAlert = AudioPlayer();
  final scoreConfirm = AudioPlayer();
  final bust = AudioPlayer();

  final dir = 'assets/sounds/$validPackId';
  try { await diceRoll.setAsset('$dir/dice_roll.wav'); } catch (_) {}
  try { await coinFlip.setAsset('$dir/coin_flip.wav'); } catch (_) {}
  try { await timerAlert.setAsset('$dir/timer_alert.wav'); } catch (_) {}
  try { await scoreConfirm.setAsset('$dir/score_confirm.wav'); } catch (_) {}
  try { await bust.setAsset('$dir/bust.wav'); } catch (_) {}

  final service = AudioService(
    diceRollPlayer: diceRoll,
    coinFlipPlayer: coinFlip,
    timerAlertPlayer: timerAlert,
    scoreConfirmPlayer: scoreConfirm,
    bustPlayer: bust,
    isSoundEnabled: () {
      final p = ref.read(preferencesNotifierProvider).valueOrNull;
      return p?.soundEnabled ?? true;
    },
  );

  ref.onDispose(service.dispose);
  return service;
}

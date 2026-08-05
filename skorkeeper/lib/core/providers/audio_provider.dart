import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'preferences_provider.dart';

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
    } catch (_) {
      // Stub assets may be empty in local development.
    }
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
  final diceRoll = AudioPlayer();
  final coinFlip = AudioPlayer();
  final timerAlert = AudioPlayer();
  final scoreConfirm = AudioPlayer();
  final bust = AudioPlayer();

  try {
    await diceRoll.setAsset('assets/sounds/dice_roll.wav');
  } catch (_) {}
  try {
    await coinFlip.setAsset('assets/sounds/coin_flip.wav');
  } catch (_) {}
  try {
    await timerAlert.setAsset('assets/sounds/timer_alert.wav');
  } catch (_) {}
  try {
    await scoreConfirm.setAsset('assets/sounds/score_confirm.wav');
  } catch (_) {}
  try {
    await bust.setAsset('assets/sounds/bust.wav');
  } catch (_) {}

  final service = AudioService(
    diceRollPlayer: diceRoll,
    coinFlipPlayer: coinFlip,
    timerAlertPlayer: timerAlert,
    scoreConfirmPlayer: scoreConfirm,
    bustPlayer: bust,
    isSoundEnabled: () {
      final prefs = ref.read(preferencesNotifierProvider).valueOrNull;
      return prefs?.soundEnabled ?? true;
    },
  );

  ref.onDispose(service.dispose);
  return service;
}

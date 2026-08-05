# Contract: GameModule Interface

**Branch**: `001-skorkeeper-app` | **Layer**: Domain Core
**Spec ref**: FR-008–FR-021, Constitution Principle II

---

## Purpose

Every scoring game type (Custom, Darts, Yahtzee, Golf, Cribbage, Bowling, Farkle, UNO, Dominoes) MUST implement the `GameModule` abstract interface. This contract enforces Constitution Principle II: "No game-specific logic MUST leak into shared UI or app-level code. New game types MUST be addable without modifying existing modules."

---

## `GameModule` Abstract Interface

```dart
// lib/core/modules/game_module.dart

/// The registration descriptor for a game type.
/// Every game module MUST provide one of these.
abstract interface class GameModule {
  // ── Identity ───────────────────────────────────────────────────────
  
  /// Stable identifier used as game_type in the database.
  /// Must be snake_case and never change after first release.
  /// Examples: 'custom', 'darts_501', 'yahtzee', 'golf_9'
  String get gameTypeId;

  /// Human-readable display name shown on the game picker home screen.
  String get displayName;

  /// Short description shown on the game picker card.
  String get description;

  /// SVG or PNG asset path for the game's icon on the home screen.
  String get iconAsset;

  // ── Player Configuration ────────────────────────────────────────────

  /// Minimum number of players allowed (≥ 1).
  int get minPlayers;

  /// Maximum number of players allowed (≤ 10).
  int get maxPlayers;

  // ── State Lifecycle ─────────────────────────────────────────────────

  /// Produces the initial module_state_json Map for a new session.
  /// Called once when the user confirms player setup and taps "Start Game".
  /// [players] is the ordered list of participants.
  Map<String, dynamic> initialState(List<SessionPlayer> players);

  /// Validates and parses a raw JSON map back into this module's state.
  /// Returns null if the JSON is invalid or incompatible (triggers recovery flow).
  /// MUST be pure — no side effects.
  GameModuleState? stateFromJson(Map<String, dynamic> json);

  // ── Scoring Logic ───────────────────────────────────────────────────

  /// Applies a score action to the current state and returns a new immutable state.
  /// MUST be pure — identical inputs produce identical outputs.
  /// Throws [InvalidScoreActionException] if the action violates game rules.
  GameModuleState applyAction(GameModuleState state, ScoreAction action);

  /// Returns the current leaderboard rankings based on module state.
  /// Called after every [applyAction] to update the live leaderboard widget.
  List<LeaderboardEntry> leaderboard(GameModuleState state);

  /// Determines whether the session has a winner given the current state.
  /// Returns null if the game is still in progress.
  WinResult? checkWinCondition(GameModuleState state);

  // ── UI Configuration ────────────────────────────────────────────────

  /// Returns the UI layout descriptor for the scoring screen.
  /// Used by the shared GameSessionScaffold to render the correct input widget.
  ScoringLayoutDescriptor scoringLayout(GameModuleState state);

  // ── Validation ──────────────────────────────────────────────────────

  /// Validates a proposed score value before it is applied.
  /// Returns a [ScoreValidationResult] describing any rule violations.
  /// Called on every keystroke for real-time feedback in numeric inputs.
  ScoreValidationResult validateScore(GameModuleState state, String playerId, dynamic proposedValue);
}
```

---

## Supporting Types

```dart
// lib/core/modules/game_module_state.dart

/// Immutable snapshot of a game module's runtime state.
/// Each module defines its own concrete subclass annotated with @freezed.
abstract class GameModuleState {
  const GameModuleState();
  Map<String, dynamic> toJson();
}

// ── Example: DartsGameState (concrete implementation in features/modules/darts/) ──
@freezed
class DartsGameState extends GameModuleState with _$DartsGameState {
  const factory DartsGameState({
    required DartsVariant variant,
    required bool doubleIn,
    required bool doubleOut,
    required Map<String, DartsPlayerState> playerStates,
    required String currentPlayerId,
    required List<int> throwsThisTurn,
    required bool gameOver,
    String? winnerId,
  }) = _DartsGameState;

  @override
  Map<String, dynamic> toJson() => _$DartsGameStateToJson(this);
}
```

```dart
// lib/core/modules/score_action.dart

/// A score action submitted by the UI to the game module.
/// Each module defines its own ScoreAction subclass using sealed classes.
sealed class ScoreAction {
  const ScoreAction();
}

// Example actions:
class DartThrown extends ScoreAction {
  const DartThrown({ required this.score, required this.multiplier });
  final int score;        // 1–20 or 25 (bull)
  final int multiplier;  // 1 (single), 2 (double), 3 (triple)
}

class YahtzeeScoreSelected extends ScoreAction {
  const YahtzeeScoreSelected({ required this.playerId, required this.category });
  final String playerId;
  final YahtzeeCategory category;
}

class CustomRoundScoreEntered extends ScoreAction {
  const CustomRoundScoreEntered({ required this.playerId, required this.value });
  final String playerId;
  final int value;
}
```

```dart
// lib/core/modules/leaderboard_entry.dart

/// A single leaderboard row returned by GameModule.leaderboard().
@freezed
class LeaderboardEntry with _$LeaderboardEntry {
  const factory LeaderboardEntry({
    required String playerId,
    required String displayName,
    required String colorHex,
    required int rank,              // 1-based; ties share same rank
    required String scoreDisplay,  // Formatted score string (module-specific)
    required int sortKey,          // Raw sort value for ordering
    required bool isLeading,
  }) = _LeaderboardEntry;
}
```

```dart
// lib/core/modules/win_result.dart

@freezed
class WinResult with _$WinResult {
  const factory WinResult({
    required String winnerId,
    required String winnerDisplayName,
    required String winDescription,   // e.g. "Checkout with Double 16", "Yahtzee!"
    required List<LeaderboardEntry> finalStandings,
  }) = _WinResult;
}
```

```dart
// lib/core/modules/scoring_layout_descriptor.dart

/// Describes which scoring input widget the GameSessionScaffold should render.
enum ScoringLayoutType {
  numericKeypad,     // Custom, Farkle, Dominoes, UNO — tap a number
  dartsKeypad,       // Darts — full 1–20 grid + bull + multipliers
  yahtzeeScorecard,  // Yahtzee — scorecard grid with locked categories
  golfScorecard,     // Golf — hole-by-hole entry
  cribbageBoard,     // Cribbage — CustomPainter board + numeric input
  bowlingSheet,      // Bowling — frame grid + roll entry
  livesCounter,      // Lives tool (not a GameModule, but shares the scaffold)
}

@freezed
class ScoringLayoutDescriptor with _$ScoringLayoutDescriptor {
  const factory ScoringLayoutDescriptor({
    required ScoringLayoutType type,
    required Map<String, dynamic> config,  // Layout-specific config (e.g., par values for golf)
  }) = _ScoringLayoutDescriptor;
}
```

```dart
// lib/core/modules/score_validation_result.dart

@freezed
class ScoreValidationResult with _$ScoreValidationResult {
  const factory ScoreValidationResult.valid() = ValidScore;
  const factory ScoreValidationResult.invalid({
    required String reason,        // e.g. "Score cannot exceed remaining 180"
    required String shortCode,     // e.g. 'BUST', 'OVER_MAX', 'INVALID_DOUBLE_OUT'
  }) = InvalidScore;
}
```

```dart
// Exception type
class InvalidScoreActionException implements Exception {
  final String message;
  final String ruleCode;
  const InvalidScoreActionException(this.message, { required this.ruleCode });
}
```

---

## Module Registration

All modules are registered in a central registry at app startup. The registry is the **only** place where game type IDs map to module instances. Presentation-layer code never instantiates modules directly.

```dart
// lib/core/modules/game_module_registry.dart

class GameModuleRegistry {
  static final Map<String, GameModule> _modules = {};

  static void register(GameModule module) {
    assert(!_modules.containsKey(module.gameTypeId),
        'Duplicate game module: ${module.gameTypeId}');
    _modules[module.gameTypeId] = module;
  }

  static GameModule? get(String gameTypeId) => _modules[gameTypeId];

  static List<GameModule> get all => List.unmodifiable(_modules.values);
}

// lib/main.dart — Registration at startup (before runApp)
void _registerModules() {
  GameModuleRegistry.register(CustomGameModule());
  GameModuleRegistry.register(Darts501Module());
  GameModuleRegistry.register(Darts301Module());
  GameModuleRegistry.register(DartsCricketModule());
  GameModuleRegistry.register(DartsCutThroatCricketModule());
  GameModuleRegistry.register(DartsAroundTheClockModule());
  GameModuleRegistry.register(DartsShanghaiModule());
  GameModuleRegistry.register(DartsKillerModule());
  GameModuleRegistry.register(DartsHalveItModule());
  GameModuleRegistry.register(YahtzeeModule());
  GameModuleRegistry.register(Golf9Module());
  GameModuleRegistry.register(Golf18Module());
  GameModuleRegistry.register(MiniGolfModule());
  GameModuleRegistry.register(CribbageModule());
  GameModuleRegistry.register(BowlingModule());
  GameModuleRegistry.register(FarkleModule());
  GameModuleRegistry.register(UnoModule());
  GameModuleRegistry.register(DominoesModule());
}
```

**Adding a new game type** requires:
1. Creating `lib/features/modules/<name>/` with the four layers (data, domain, application, presentation).
2. Implementing `GameModule` in the domain layer.
3. Adding one `GameModuleRegistry.register(...)` call in `_registerModules()`.

No other file changes are required. ✅

---

## Invariants (enforced by tests)

1. `initialState()` MUST produce a state that passes `stateFromJson(state.toJson()) != null`.
2. `applyAction()` MUST be pure: calling it twice with the same arguments returns equal states.
3. `leaderboard()` MUST return exactly as many entries as there are players in the session.
4. `leaderboard()` entries MUST have contiguous ranks starting at 1 (ties share rank, next rank skips).
5. Once `checkWinCondition()` returns non-null, subsequent calls with the same state MUST return the same result.
6. `validateScore()` MUST return `InvalidScore` for any action that would cause `applyAction()` to throw.

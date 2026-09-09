# SkorKeeper

**The all-in-one scoring & game tools app** — replaces scorecards, notepads, dice, timers, and
more for board games, card games, darts, golf, cribbage, Yahtzee, and beyond.

Available on **iOS** and **Android**. Works fully offline. No account required.

---

## Features

### Scoring Modules
| Game | Notes |
|------|-------|
| Custom / Freeform | Spreadsheet-style grid for any game, 1–10 players |
| Darts | 301, 501, 701, Cricket, Cut-Throat Cricket, Around the Clock, Shanghai, Killer, Halve It |
| Yahtzee | Full official scorecard with upper/lower bonuses |
| Golf / Mini Golf | 9 or 18 holes, par tracking, eagle/birdie/bogey labels |
| Cribbage | Visual board with two-peg system, wins at 121 |
| Bowling | 10-frame state machine, spare/strike/perfect game |
| Farkle | 6-dice, opening threshold, bank/farkle actions |
| Dominoes | Pip-count rounds, low score wins |
| UNO / Card Penalty | High-score-loses tracker with configurable target |

### Tools
Dice Roller (shake-to-roll, all die types) · Coin Flipper · Spinner (customizable segments) ·
Timer / Hourglass · Stopwatch · Lives Counter · Notepad · Tally Counter · Random Team Picker

### Design
- Minnesota Timberwolves primary palette — `#0C2340` · `#236192` · `#9ea2a2` · `#78BE20`
- Prince alternate palette — `#221C35` · `#981D97`
- Full light & dark mode
- Smooth 300 ms transitions on mid-range devices

---

## Prerequisites

| Tool | Minimum version | Install |
|------|----------------|---------|
| Flutter | 3.22.0 | [flutter.dev/get-started](https://docs.flutter.dev/get-started/install) |
| Dart SDK | 3.8.0 | Bundled with Flutter |
| Xcode | 15.0 *(iOS only)* | Mac App Store |
| Android Studio / SDK | API 26+ | [developer.android.com](https://developer.android.com/studio) |

Verify your environment:

```bash
flutter doctor
```

All items should show a green ✓ for your target platform(s).

---

## Getting Started

### 1. Clone the repo

```bash
git clone <repo-url>
cd SkorKeeper/skorkeeper
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Generate code (Drift, Freezed, Riverpod)

Run this once after cloning, and again any time you modify a `*.drift`, `@freezed`, or
`@riverpod`-annotated file:

```bash
dart run build_runner build --delete-conflicting-outputs
```

For continuous generation during development:

```bash
dart run build_runner watch --delete-conflicting-outputs
```

### 4. Run the app

**On a connected device or emulator:**

```bash
flutter run
```

**Target a specific platform explicitly:**

```bash
flutter run -d android   # Android emulator or device
flutter run -d ios       # iOS simulator or device (Mac only)
```

**List available devices:**

```bash
flutter devices
```

---

## Development Workflow

### Run tests

```bash
flutter test
```

### Analyze code

```bash
flutter analyze
```

### Format code

```bash
dart format lib/ test/
```

### Build release APK (Android)

```bash
flutter build apk --release
```

### Build release IPA (iOS — Mac only)

```bash
flutter build ipa --release
```

### Update the app icon

The launcher icon is generated from `assets/icons/SkorKeeper Logo.png` via the
`flutter_launcher_icons` package (config lives in `pubspec.yaml`). After replacing that image
file with a new logo, run the combined refresh script from the `skorkeeper/` folder:

```bash
chmod +x ./scripts/refresh-icon.sh   # only needed once
./scripts/refresh-icon.sh
```

This does everything needed in one shot: regenerates the icon files for Android/iOS,
uninstalls the app from the connected device (Android launchers cache icons and often won't
show a new one otherwise), does a clean rebuild, and installs the fresh release APK.

**Manual steps**, if you'd rather run them individually or need to troubleshoot:

```bash
# 1. Regenerate icon files from assets/icons/SkorKeeper Logo.png
flutter pub get
dart run flutter_launcher_icons

# 2. Force-refresh the icon on a connected Android device
adb uninstall com.schlosserstudio.skorkeeper
flutter clean
flutter pub get
flutter build apk --release
adb install build/app/outputs/flutter-apk/app-release.apk
```

If `adb` isn't on your PATH, it's typically at `~/Library/Android/sdk/platform-tools/adb`
(macOS) or `~/Android/Sdk/platform-tools/adb` (Linux).

---

## Useful adb commands (Android)

```bash
adb devices                                  # list connected devices/emulators
adb uninstall com.schlosserstudio.skorkeeper      # remove the app entirely
adb install <path-to.apk>                    # install an APK on the connected device
adb logcat *:E                               # stream device logs (errors only)
adb shell pm clear com.schlosserstudio.skorkeeper # wipe app data/prefs without uninstalling
```

---

## Project Structure

```
lib/
├── core/
│   ├── theme/          # ColorTokens, AppTextStyles, AppTheme (light/dark, both palettes)
│   ├── router/         # go_router route tree (StatefulShellRoute, 4 tab branches)
│   ├── database/       # Drift AppDatabase, tables, DAOs
│   └── providers/      # Riverpod providers (db, prefs, sessions, history)
├── modules/
│   ├── game_module.dart          # GameModule abstract interface + registry
│   ├── custom/                   # Freeform / spreadsheet scoring
│   ├── darts/                    # 9 dart game variants + DartsBloc
│   ├── yahtzee/                  # Scorecard + YahtzeeCubit
│   ├── golf/                     # Golf / Mini Golf + GolfCubit
│   ├── cribbage/                 # Visual board + CribbageCubit
│   ├── bowling/                  # 10-frame + BowlingCubit
│   ├── farkle/                   # FarkleCubit
│   ├── dominoes/                 # DominoesCubit
│   └── uno/                      # UNO penalty tracker
├── tools/
│   ├── dice/           # Dice roller (shake-to-roll)
│   ├── coin/           # Coin flipper (Rive animation)
│   ├── spinner/        # Customizable spinner (Rive)
│   ├── timer/          # Countdown + hourglass (Lottie)
│   ├── stopwatch/      # Stopwatch
│   ├── lives/          # Lives / health counter
│   ├── notepad/        # Persisted notepad
│   ├── tally/          # Persisted tally counter
│   └── team_picker/    # Random team picker
├── history/            # History list, filters, detail view
├── settings/           # Theme, palette, audio/haptic prefs
└── shared/             # Shared widgets (ScoreCell, LeaderboardRow, NumericKeypad, etc.)

assets/
├── animations/         # Lottie JSON + Rive files
├── sounds/             # WAV audio effects
└── fonts/              # Custom typefaces

specs/                  # Design artifacts (spec, plan, tasks, contracts, data model)
```

---

## Key Dependencies

| Package | Purpose |
|---------|---------|
| `go_router` | Navigation with persistent tab stacks |
| `flutter_riverpod` + `riverpod_annotation` | App-wide state management |
| `flutter_bloc` + `bloc` | Per-game state machines |
| `drift` + `sqlite3_flutter_libs` | Local SQLite persistence with reactive streams |
| `shared_preferences` | Lightweight user preferences |
| `flutter_animate` | Code-driven UI animations |
| `rive` | Interactive animations (coin flip, spinner) |
| `lottie` | After Effects exports (win screen, hourglass) |
| `just_audio` + `audio_session` | Audio with iOS mute-switch support |
| `sensors_plus` | Accelerometer for shake-to-roll dice |
| `freezed` + `json_serializable` | Immutable domain models |
| `build_runner` + `drift_dev` + `riverpod_generator` | Code generation |

---

## Minimum OS Support

| Platform | Minimum version |
|----------|----------------|
| Android | 8.0 (API 26) |
| iOS | 14.0 |

---

## Design Tokens

| Token | Hex | Role |
|-------|-----|------|
| Midnight Navy | `#0C2340` | Primary surface / dark backgrounds |
| Lake Blue | `#236192` | Primary accent / interactive elements |
| Moonlight Silver | `#9ea2a2` | Neutral / secondary text |
| Association Green | `#78BE20` | Action / success / CTA |
| Prince Purple | `#221C35` | Alternate primary (Prince palette) |
| Prince Violet | `#981D97` | Alternate accent (Prince palette) |

Switch between palettes in **Settings → Accent Color**.

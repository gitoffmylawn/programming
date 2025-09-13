## Flutter Pac-Man Game

A classic Pac-Man game implementation built with Flutter for Android and iOS.

### Features

- **Classic Pac-Man Gameplay**: Control Pac-Man to collect dots while avoiding ghosts
- **Multiple Maps/Levels**: Three unique maps with different layouts and challenges:
  - Level 1: Classic Maze - Traditional Pac-Man style layout
  - Level 2: Speed Run - Simplified corridors for faster gameplay  
  - Level 3: Spiral Challenge - Complex spiral pattern for advanced players
- **Touch Controls**: Intuitive directional buttons for movement
- **Scoring System**: Earn points for collecting dots and eating vulnerable ghosts
- **Ghost AI**: Ghosts pursue Pac-Man and become vulnerable when big dots are eaten
- **Lives System**: Multiple lives with position reset on collision
- **Responsive Design**: Adapts to different screen sizes

### Project Structure

```
flutter_pacman/
├── lib/
│   ├── main.dart           # App entry point and main menu navigation
│   ├── game_screen.dart    # Core game logic, rendering, and controls
│   └── map_data.dart       # Level layouts and map definitions
├── assets/
│   └── images/             # Placeholder graphics and game assets
├── android/                # Android-specific configuration
├── ios/                    # iOS-specific configuration
└── pubspec.yaml           # Flutter dependencies and project config
```

### Game Mechanics

- **Movement**: Touch directional controls to move Pac-Man
- **Dots**: Collect small dots (10 points) and big dots (50 points)
- **Power Pellets**: Big dots make ghosts vulnerable for limited time
- **Ghosts**: Avoid ghosts or eat them when blue (200 points)
- **Lives**: Start with 3 lives, lose one when caught by ghost
- **Win Condition**: Collect all dots to complete the level

### Code Features

- **Well-commented code** for clarity and maintainability
- **Modular design** with separate concerns for UI, game logic, and data
- **Responsive layout** that adapts to different screen sizes
- **Smooth animations** for Pac-Man mouth and character movement
- **Haptic feedback** for enhanced mobile gaming experience
- **Game state management** with pause, restart, and navigation

### Getting Started

1. Ensure Flutter SDK is installed
2. Run `flutter pub get` to install dependencies
3. Connect device or start emulator
4. Run `flutter run` to launch the game

### Dependencies

- Flutter SDK 3.0.0+
- Material Design components
- No external packages required

This implementation provides a complete, playable Pac-Man experience with multiple levels and classic gameplay mechanics, all built using Flutter's native capabilities.
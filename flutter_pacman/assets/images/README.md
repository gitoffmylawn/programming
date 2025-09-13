# Placeholder Graphics for Flutter Pac-Man Game

This directory would contain the following placeholder graphics in a real implementation:

## Required Assets:

### Character Graphics:
- `pacman.png` - Yellow circle with mouth opening animation frames
- `ghost_red.png` - Red ghost sprite
- `ghost_pink.png` - Pink ghost sprite  
- `ghost_cyan.png` - Cyan ghost sprite
- `ghost_orange.png` - Orange ghost sprite
- `ghost_vulnerable.png` - Blue vulnerable ghost state

### Game Elements:
- `dot.png` - Small yellow dot (2x2 pixels)
- `big_dot.png` - Large yellow power pellet (8x8 pixels)
- `wall.png` - Blue wall tile texture
- `background.png` - Black game board background

### UI Graphics:
- `heart.png` - Red heart for lives display
- `trophy.png` - Gold trophy for win screen
- `game_over.png` - Game over text graphic

## Implementation Notes:

Since this is a code-only implementation, all graphics are rendered using:
- Flutter's Container widgets with BoxDecoration
- CustomPainter classes for character animations
- Material Design icons for UI elements
- Color-based rendering for all game elements

The actual graphics would be simple pixel art style images to maintain the retro Pac-Man aesthetic.

## Asset Loading:

In pubspec.yaml, assets are declared in the flutter section:
```yaml
flutter:
  assets:
    - assets/images/
```

Assets would be loaded using:
```dart
Image.asset('assets/images/pacman.png')
```

For this demonstration, all visuals are created programmatically using Flutter's rendering capabilities.
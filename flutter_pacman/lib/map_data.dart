import 'package:flutter/material.dart';

/// Enum for different tile types in the game map
enum TileType {
  wall,      // Walls that block movement
  dot,       // Small dots to collect for points  
  bigDot,    // Big dots that make ghosts vulnerable
  empty,     // Empty walkable space
  pacman,    // Pac-Man starting position
  ghost,     // Ghost starting position
}

/// Represents a single tile in the game map
class MapTile {
  final TileType type;
  final int x;
  final int y;
  
  const MapTile({
    required this.type,
    required this.x, 
    required this.y,
  });
}

/// Game map data containing layout and metadata
class GameMap {
  final String name;
  final List<List<TileType>> layout;
  final int width;
  final int height;
  final Color themeColor;
  
  const GameMap({
    required this.name,
    required this.layout,
    required this.width,
    required this.height,
    required this.themeColor,
  });
  
  /// Get tile type at specific coordinates
  TileType getTileAt(int x, int y) {
    if (x < 0 || x >= width || y < 0 || y >= height) {
      return TileType.wall; // Out of bounds treated as walls
    }
    return layout[y][x];
  }
  
  /// Check if tile is walkable (not a wall)
  bool isWalkable(int x, int y) {
    final tile = getTileAt(x, y);
    return tile != TileType.wall;
  }
}

/// Collection of all available game maps/levels
class MapData {
  
  /// Classic Pac-Man style map - Level 1
  static const GameMap level1 = GameMap(
    name: "Classic Maze",
    themeColor: Colors.blue,
    width: 19,
    height: 21,
    layout: [
      // Row 0
      [TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall],
      // Row 1
      [TileType.wall, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.wall, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.wall],
      // Row 2
      [TileType.wall, TileType.bigDot, TileType.wall, TileType.wall, TileType.wall, TileType.dot, TileType.wall, TileType.wall, TileType.dot, TileType.wall, TileType.dot, TileType.wall, TileType.wall, TileType.dot, TileType.wall, TileType.wall, TileType.wall, TileType.bigDot, TileType.wall],
      // Row 3
      [TileType.wall, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.wall],
      // Row 4
      [TileType.wall, TileType.dot, TileType.wall, TileType.wall, TileType.wall, TileType.dot, TileType.wall, TileType.dot, TileType.wall, TileType.wall, TileType.wall, TileType.dot, TileType.wall, TileType.dot, TileType.wall, TileType.wall, TileType.wall, TileType.dot, TileType.wall],
      // Row 5
      [TileType.wall, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.wall, TileType.dot, TileType.dot, TileType.wall, TileType.dot, TileType.dot, TileType.wall, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.wall],
      // Row 6
      [TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.dot, TileType.wall, TileType.wall, TileType.empty, TileType.wall, TileType.empty, TileType.wall, TileType.wall, TileType.dot, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall],
      // Row 7 - Ghost area
      [TileType.empty, TileType.empty, TileType.empty, TileType.empty, TileType.empty, TileType.dot, TileType.wall, TileType.empty, TileType.ghost, TileType.empty, TileType.ghost, TileType.empty, TileType.wall, TileType.dot, TileType.empty, TileType.empty, TileType.empty, TileType.empty, TileType.empty],
      // Row 8
      [TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.dot, TileType.wall, TileType.empty, TileType.ghost, TileType.empty, TileType.ghost, TileType.empty, TileType.wall, TileType.dot, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall],
      // Row 9
      [TileType.wall, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.wall, TileType.wall, TileType.empty, TileType.wall, TileType.empty, TileType.wall, TileType.wall, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.wall],
      // Row 10 - Pac-Man starting position
      [TileType.wall, TileType.dot, TileType.wall, TileType.wall, TileType.wall, TileType.dot, TileType.wall, TileType.dot, TileType.dot, TileType.pacman, TileType.dot, TileType.dot, TileType.wall, TileType.dot, TileType.wall, TileType.wall, TileType.wall, TileType.dot, TileType.wall],
      // Row 11
      [TileType.wall, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.wall],
      // Row 12
      [TileType.wall, TileType.bigDot, TileType.wall, TileType.wall, TileType.wall, TileType.dot, TileType.wall, TileType.wall, TileType.dot, TileType.wall, TileType.dot, TileType.wall, TileType.wall, TileType.dot, TileType.wall, TileType.wall, TileType.wall, TileType.bigDot, TileType.wall],
      // Row 13
      [TileType.wall, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.wall, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.wall],
      // Rows 14-20 (remaining rows)
      [TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall],
      [TileType.wall, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.wall, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.wall],
      [TileType.wall, TileType.dot, TileType.wall, TileType.wall, TileType.wall, TileType.dot, TileType.wall, TileType.wall, TileType.dot, TileType.wall, TileType.dot, TileType.wall, TileType.wall, TileType.dot, TileType.wall, TileType.wall, TileType.wall, TileType.dot, TileType.wall],
      [TileType.wall, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.wall],
      [TileType.wall, TileType.bigDot, TileType.wall, TileType.wall, TileType.wall, TileType.dot, TileType.wall, TileType.wall, TileType.dot, TileType.wall, TileType.dot, TileType.wall, TileType.wall, TileType.dot, TileType.wall, TileType.wall, TileType.wall, TileType.bigDot, TileType.wall],
      [TileType.wall, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.wall, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.wall],
      [TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall],
    ],
  );

  /// Simple corridor map - Level 2  
  static const GameMap level2 = GameMap(
    name: "Speed Run",
    themeColor: Colors.green,
    width: 15,
    height: 15,
    layout: [
      // Simplified corridor design for faster gameplay
      [TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall],
      [TileType.wall, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.bigDot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.wall],
      [TileType.wall, TileType.dot, TileType.wall, TileType.wall, TileType.dot, TileType.wall, TileType.dot, TileType.wall, TileType.dot, TileType.wall, TileType.dot, TileType.wall, TileType.wall, TileType.dot, TileType.wall],
      [TileType.wall, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.wall, TileType.dot, TileType.wall, TileType.dot, TileType.wall, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.wall],
      [TileType.wall, TileType.dot, TileType.wall, TileType.wall, TileType.dot, TileType.dot, TileType.dot, TileType.wall, TileType.dot, TileType.dot, TileType.dot, TileType.wall, TileType.wall, TileType.dot, TileType.wall],
      [TileType.wall, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.wall, TileType.dot, TileType.wall, TileType.dot, TileType.wall, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.wall],
      [TileType.wall, TileType.dot, TileType.wall, TileType.wall, TileType.dot, TileType.wall, TileType.dot, TileType.empty, TileType.dot, TileType.wall, TileType.dot, TileType.wall, TileType.wall, TileType.dot, TileType.wall],
      [TileType.wall, TileType.bigDot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.pacman, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.bigDot, TileType.wall],
      [TileType.wall, TileType.dot, TileType.wall, TileType.wall, TileType.dot, TileType.wall, TileType.dot, TileType.ghost, TileType.dot, TileType.wall, TileType.dot, TileType.wall, TileType.wall, TileType.dot, TileType.wall],
      [TileType.wall, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.wall, TileType.dot, TileType.wall, TileType.dot, TileType.wall, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.wall],
      [TileType.wall, TileType.dot, TileType.wall, TileType.wall, TileType.dot, TileType.dot, TileType.dot, TileType.wall, TileType.dot, TileType.dot, TileType.dot, TileType.wall, TileType.wall, TileType.dot, TileType.wall],
      [TileType.wall, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.wall, TileType.dot, TileType.wall, TileType.dot, TileType.wall, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.wall],
      [TileType.wall, TileType.dot, TileType.wall, TileType.wall, TileType.dot, TileType.wall, TileType.dot, TileType.wall, TileType.dot, TileType.wall, TileType.dot, TileType.wall, TileType.wall, TileType.dot, TileType.wall],
      [TileType.wall, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.bigDot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.wall],
      [TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall],
    ],
  );

  /// Spiral challenge map - Level 3
  static const GameMap level3 = GameMap(
    name: "Spiral Challenge", 
    themeColor: Colors.purple,
    width: 17,
    height: 17,
    layout: [
      // Spiral pattern for challenging gameplay
      [TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall],
      [TileType.wall, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.bigDot, TileType.wall],
      [TileType.wall, TileType.dot, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.dot, TileType.wall],
      [TileType.wall, TileType.dot, TileType.wall, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.wall, TileType.dot, TileType.wall],
      [TileType.wall, TileType.dot, TileType.wall, TileType.dot, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.dot, TileType.wall, TileType.dot, TileType.wall],
      [TileType.wall, TileType.dot, TileType.wall, TileType.dot, TileType.wall, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.wall, TileType.dot, TileType.wall, TileType.dot, TileType.wall],
      [TileType.wall, TileType.dot, TileType.wall, TileType.dot, TileType.wall, TileType.dot, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.dot, TileType.wall, TileType.dot, TileType.wall, TileType.dot, TileType.wall],
      [TileType.wall, TileType.dot, TileType.wall, TileType.dot, TileType.wall, TileType.dot, TileType.wall, TileType.dot, TileType.dot, TileType.dot, TileType.wall, TileType.dot, TileType.wall, TileType.dot, TileType.wall, TileType.dot, TileType.wall],
      [TileType.wall, TileType.dot, TileType.wall, TileType.dot, TileType.wall, TileType.dot, TileType.wall, TileType.dot, TileType.pacman, TileType.dot, TileType.wall, TileType.dot, TileType.wall, TileType.dot, TileType.wall, TileType.dot, TileType.wall],
      [TileType.wall, TileType.dot, TileType.wall, TileType.dot, TileType.wall, TileType.dot, TileType.wall, TileType.dot, TileType.ghost, TileType.dot, TileType.wall, TileType.dot, TileType.wall, TileType.dot, TileType.wall, TileType.dot, TileType.wall],
      [TileType.wall, TileType.dot, TileType.wall, TileType.dot, TileType.wall, TileType.dot, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.dot, TileType.wall, TileType.dot, TileType.wall, TileType.dot, TileType.wall],
      [TileType.wall, TileType.dot, TileType.wall, TileType.dot, TileType.wall, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.wall, TileType.dot, TileType.wall, TileType.dot, TileType.wall],
      [TileType.wall, TileType.dot, TileType.wall, TileType.dot, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.dot, TileType.wall, TileType.dot, TileType.wall],
      [TileType.wall, TileType.dot, TileType.wall, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.wall, TileType.dot, TileType.wall],
      [TileType.wall, TileType.dot, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.dot, TileType.wall],
      [TileType.wall, TileType.bigDot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.dot, TileType.wall],
      [TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall, TileType.wall],
    ],
  );

  /// Get all available maps
  static List<GameMap> getAllMaps() {
    return [level1, level2, level3];
  }
  
  /// Get map by index
  static GameMap getMapByIndex(int index) {
    final maps = getAllMaps();
    if (index >= 0 && index < maps.length) {
      return maps[index];
    }
    return level1; // Default to first level
  }
}
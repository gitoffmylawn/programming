import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'map_data.dart';

/// Enum for game character directions
enum Direction { up, down, left, right, none }

/// Represents game character position and movement
class GameCharacter {
  double x;
  double y;
  Direction direction;
  Direction nextDirection;
  
  GameCharacter({
    required this.x,
    required this.y,
    this.direction = Direction.none,
    this.nextDirection = Direction.none,
  });
}

/// Ghost character with AI behavior
class Ghost extends GameCharacter {
  final Color color;
  bool isVulnerable;
  int vulnerableTimer;
  
  Ghost({
    required double x,
    required double y,
    required this.color,
    this.isVulnerable = false,
    this.vulnerableTimer = 0,
  }) : super(x: x, y: y);
}

/// Main game screen with game logic and rendering
class GameScreen extends StatefulWidget {
  final int mapIndex;
  
  const GameScreen({
    super.key,
    required this.mapIndex,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  late GameMap currentMap;
  late GameCharacter pacman;
  late List<Ghost> ghosts;
  late List<List<TileType>> gameBoard;
  late Timer gameTimer;
  late AnimationController _pacmanAnimationController;
  
  // Game state variables
  int score = 0;
  int lives = 3;
  int dotsRemaining = 0;
  bool gameRunning = false;
  bool gameWon = false;
  bool gameOver = false;
  
  // Game settings
  static const double gameSpeed = 200.0; // milliseconds between moves
  static const int vulnerableDuration = 100; // Ghost vulnerable time
  
  @override
  void initState() {
    super.initState();
    
    // Set up animations
    _pacmanAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    )..repeat(reverse: true);
    
    // Initialize game
    _initializeGame();
  }

  @override
  void dispose() {
    gameTimer.cancel();
    _pacmanAnimationController.dispose();
    super.dispose();
  }

  /// Initialize game state and characters
  void _initializeGame() {
    currentMap = MapData.getMapByIndex(widget.mapIndex);
    
    // Copy map layout to game board
    gameBoard = currentMap.layout.map((row) => List<TileType>.from(row)).toList();
    
    // Find character starting positions and count dots
    ghosts = [];
    dotsRemaining = 0;
    
    for (int y = 0; y < currentMap.height; y++) {
      for (int x = 0; x < currentMap.width; x++) {
        final tile = gameBoard[y][x];
        
        switch (tile) {
          case TileType.pacman:
            pacman = GameCharacter(x: x.toDouble(), y: y.toDouble());
            gameBoard[y][x] = TileType.empty; // Clear starting position
            break;
            
          case TileType.ghost:
            ghosts.add(Ghost(
              x: x.toDouble(),
              y: y.toDouble(),
              color: _getGhostColor(ghosts.length),
            ));
            gameBoard[y][x] = TileType.empty; // Clear starting position
            break;
            
          case TileType.dot:
          case TileType.bigDot:
            dotsRemaining++;
            break;
            
          default:
            break;
        }
      }
    }
    
    // Start game loop
    _startGameLoop();
  }

  /// Get unique color for each ghost
  Color _getGhostColor(int index) {
    const colors = [
      Colors.red,
      Colors.pink,
      Colors.cyan,
      Colors.orange,
    ];
    return colors[index % colors.length];
  }

  /// Start the main game loop
  void _startGameLoop() {
    gameRunning = true;
    gameTimer = Timer.periodic(
      const Duration(milliseconds: gameSpeed.toInt()),
      (timer) => _updateGame(),
    );
  }

  /// Main game update logic
  void _updateGame() {
    if (!gameRunning) return;
    
    setState(() {
      // Update Pac-Man movement
      _updatePacmanMovement();
      
      // Update ghost movement and vulnerability
      _updateGhosts();
      
      // Check collisions
      _checkCollisions();
      
      // Check win condition
      if (dotsRemaining <= 0) {
        _winGame();
      }
    });
  }

  /// Update Pac-Man position and direction
  void _updatePacmanMovement() {
    // Try to change direction if next direction is set
    if (pacman.nextDirection != Direction.none) {
      final newPos = _getNextPosition(pacman.x, pacman.y, pacman.nextDirection);
      if (currentMap.isWalkable(newPos.dx.round(), newPos.dy.round())) {
        pacman.direction = pacman.nextDirection;
        pacman.nextDirection = Direction.none;
      }
    }
    
    // Move in current direction
    if (pacman.direction != Direction.none) {
      final newPos = _getNextPosition(pacman.x, pacman.y, pacman.direction);
      if (currentMap.isWalkable(newPos.dx.round(), newPos.dy.round())) {
        pacman.x = newPos.dx;
        pacman.y = newPos.dy;
        
        // Collect dots
        _collectDot(pacman.x.round(), pacman.y.round());
      } else {
        // Stop if hit wall
        pacman.direction = Direction.none;
      }
    }
  }

  /// Update ghost positions and states
  void _updateGhosts() {
    for (final ghost in ghosts) {
      // Update vulnerability timer
      if (ghost.isVulnerable) {
        ghost.vulnerableTimer--;
        if (ghost.vulnerableTimer <= 0) {
          ghost.isVulnerable = false;
        }
      }
      
      // Simple AI: move towards Pac-Man or randomly if vulnerable
      if (ghost.isVulnerable) {
        _moveGhostRandomly(ghost);
      } else {
        _moveGhostTowardsPacman(ghost);
      }
    }
  }

  /// Move ghost towards Pac-Man using simple pathfinding
  void _moveGhostTowardsPacman(Ghost ghost) {
    final directions = [Direction.up, Direction.down, Direction.left, Direction.right];
    Direction bestDirection = Direction.none;
    double bestDistance = double.infinity;
    
    for (final direction in directions) {
      final newPos = _getNextPosition(ghost.x, ghost.y, direction);
      if (currentMap.isWalkable(newPos.dx.round(), newPos.dy.round())) {
        final distance = _getDistance(newPos.dx, newPos.dy, pacman.x, pacman.y);
        if (distance < bestDistance) {
          bestDistance = distance;
          bestDirection = direction;
        }
      }
    }
    
    if (bestDirection != Direction.none) {
      final newPos = _getNextPosition(ghost.x, ghost.y, bestDirection);
      ghost.x = newPos.dx;
      ghost.y = newPos.dy;
      ghost.direction = bestDirection;
    }
  }

  /// Move ghost randomly when vulnerable
  void _moveGhostRandomly(Ghost ghost) {
    final directions = [Direction.up, Direction.down, Direction.left, Direction.right];
    final random = Random();
    
    // Try random directions until finding a valid one
    for (int attempts = 0; attempts < 4; attempts++) {
      final direction = directions[random.nextInt(directions.length)];
      final newPos = _getNextPosition(ghost.x, ghost.y, direction);
      if (currentMap.isWalkable(newPos.dx.round(), newPos.dy.round())) {
        ghost.x = newPos.dx;
        ghost.y = newPos.dy;
        ghost.direction = direction;
        break;
      }
    }
  }

  /// Get next position based on current position and direction
  Offset _getNextPosition(double x, double y, Direction direction) {
    switch (direction) {
      case Direction.up:
        return Offset(x, y - 1);
      case Direction.down:
        return Offset(x, y + 1);
      case Direction.left:
        return Offset(x - 1, y);
      case Direction.right:
        return Offset(x + 1, y);
      case Direction.none:
        return Offset(x, y);
    }
  }

  /// Calculate distance between two points
  double _getDistance(double x1, double y1, double x2, double y2) {
    return sqrt(pow(x2 - x1, 2) + pow(y2 - y1, 2));
  }

  /// Collect dot at specified position
  void _collectDot(int x, int y) {
    if (y >= 0 && y < gameBoard.length && x >= 0 && x < gameBoard[y].length) {
      final tile = gameBoard[y][x];
      
      if (tile == TileType.dot) {
        gameBoard[y][x] = TileType.empty;
        score += 10;
        dotsRemaining--;
        HapticFeedback.selectionClick();
        
      } else if (tile == TileType.bigDot) {
        gameBoard[y][x] = TileType.empty;
        score += 50;
        dotsRemaining--;
        
        // Make all ghosts vulnerable
        for (final ghost in ghosts) {
          ghost.isVulnerable = true;
          ghost.vulnerableTimer = vulnerableDuration;
        }
        
        HapticFeedback.mediumImpact();
      }
    }
  }

  /// Check collisions between Pac-Man and ghosts
  void _checkCollisions() {
    for (final ghost in ghosts) {
      if ((pacman.x - ghost.x).abs() < 0.8 && (pacman.y - ghost.y).abs() < 0.8) {
        if (ghost.isVulnerable) {
          // Eat the ghost
          score += 200;
          ghost.isVulnerable = false;
          ghost.vulnerableTimer = 0;
          HapticFeedback.heavyImpact();
          
          // Respawn ghost at original position
          _respawnGhost(ghost);
        } else {
          // Pac-Man loses a life
          _loseLife();
        }
      }
    }
  }

  /// Respawn ghost at starting position
  void _respawnGhost(Ghost ghost) {
    // Find a ghost starting position on the map
    for (int y = 0; y < currentMap.height; y++) {
      for (int x = 0; x < currentMap.width; x++) {
        if (currentMap.layout[y][x] == TileType.ghost) {
          ghost.x = x.toDouble();
          ghost.y = y.toDouble();
          return;
        }
      }
    }
  }

  /// Handle Pac-Man losing a life
  void _loseLife() {
    lives--;
    HapticFeedback.heavyImpact();
    
    if (lives <= 0) {
      _gameOver();
    } else {
      // Reset positions but keep game state
      _resetPositions();
    }
  }

  /// Reset character positions without resetting collected dots
  void _resetPositions() {
    // Reset Pac-Man to starting position
    for (int y = 0; y < currentMap.height; y++) {
      for (int x = 0; x < currentMap.width; x++) {
        if (currentMap.layout[y][x] == TileType.pacman) {
          pacman.x = x.toDouble();
          pacman.y = y.toDouble();
          pacman.direction = Direction.none;
          pacman.nextDirection = Direction.none;
          break;
        }
      }
    }
    
    // Reset ghosts
    int ghostIndex = 0;
    for (int y = 0; y < currentMap.height; y++) {
      for (int x = 0; x < currentMap.width; x++) {
        if (currentMap.layout[y][x] == TileType.ghost && ghostIndex < ghosts.length) {
          ghosts[ghostIndex].x = x.toDouble();
          ghosts[ghostIndex].y = y.toDouble();
          ghosts[ghostIndex].direction = Direction.none;
          ghosts[ghostIndex].isVulnerable = false;
          ghosts[ghostIndex].vulnerableTimer = 0;
          ghostIndex++;
        }
      }
    }
  }

  /// Handle game over
  void _gameOver() {
    gameRunning = false;
    gameOver = true;
    gameTimer.cancel();
  }

  /// Handle game win
  void _winGame() {
    gameRunning = false;
    gameWon = true;
    gameTimer.cancel();
  }

  /// Handle touch controls for movement
  void _handleSwipe(Direction direction) {
    if (gameRunning) {
      pacman.nextDirection = direction;
    }
  }

  /// Restart the current level
  void _restartGame() {
    setState(() {
      score = 0;
      lives = 3;
      gameRunning = false;
      gameWon = false;
      gameOver = false;
      gameTimer.cancel();
      _initializeGame();
    });
  }

  /// Return to main menu
  void _returnToMenu() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Game UI Header
            _buildGameHeader(),
            
            // Game Board
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: currentMap.themeColor, width: 3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _buildGameBoard(),
              ),
            ),
            
            // Touch Controls
            _buildTouchControls(),
            
            // Game Over Overlay
            if (gameOver || gameWon) _buildGameOverOverlay(),
          ],
        ),
      ),
    );
  }

  /// Build game header with score and lives
  Widget _buildGameHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button
          IconButton(
            onPressed: _returnToMenu,
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          
          // Score
          Text(
            'Score: $score',
            style: const TextStyle(
              color: Colors.yellow,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          // Lives
          Row(
            children: List.generate(
              lives,
              (index) => const Icon(
                Icons.favorite,
                color: Colors.red,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build the main game board
  Widget _buildGameBoard() {
    return AspectRatio(
      aspectRatio: currentMap.width / currentMap.height,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final tileSize = min(
            constraints.maxWidth / currentMap.width,
            constraints.maxHeight / currentMap.height,
          );
          
          return Stack(
            children: [
              // Game tiles
              for (int y = 0; y < currentMap.height; y++)
                for (int x = 0; x < currentMap.width; x++)
                  _buildTile(x, y, tileSize),
              
              // Pac-Man
              _buildPacman(tileSize),
              
              // Ghosts
              for (final ghost in ghosts)
                _buildGhost(ghost, tileSize),
            ],
          );
        },
      ),
    );
  }

  /// Build individual game tile
  Widget _buildTile(int x, int y, double tileSize) {
    final tile = gameBoard[y][x];
    
    return Positioned(
      left: x * tileSize,
      top: y * tileSize,
      width: tileSize,
      height: tileSize,
      child: Container(
        decoration: BoxDecoration(
          color: _getTileColor(tile),
          border: tile == TileType.wall
              ? Border.all(color: currentMap.themeColor.withOpacity(0.3))
              : null,
        ),
        child: _getTileContent(tile, tileSize),
      ),
    );
  }

  /// Get tile background color
  Color _getTileColor(TileType tile) {
    switch (tile) {
      case TileType.wall:
        return currentMap.themeColor.withOpacity(0.8);
      default:
        return Colors.black;
    }
  }

  /// Get tile content widget
  Widget? _getTileContent(TileType tile, double tileSize) {
    switch (tile) {
      case TileType.dot:
        return Center(
          child: Container(
            width: tileSize * 0.2,
            height: tileSize * 0.2,
            decoration: const BoxDecoration(
              color: Colors.yellow,
              shape: BoxShape.circle,
            ),
          ),
        );
      
      case TileType.bigDot:
        return Center(
          child: Container(
            width: tileSize * 0.5,
            height: tileSize * 0.5,
            decoration: const BoxDecoration(
              color: Colors.yellow,
              shape: BoxShape.circle,
            ),
          ),
        );
      
      default:
        return null;
    }
  }

  /// Build Pac-Man character
  Widget _buildPacman(double tileSize) {
    return AnimatedBuilder(
      animation: _pacmanAnimationController,
      builder: (context, child) {
        return Positioned(
          left: pacman.x * tileSize + tileSize * 0.1,
          top: pacman.y * tileSize + tileSize * 0.1,
          width: tileSize * 0.8,
          height: tileSize * 0.8,
          child: Transform.rotate(
            angle: _getPacmanRotation(),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.yellow,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.yellowAccent.withOpacity(0.6),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: CustomPaint(
                painter: PacmanPainter(_pacmanAnimationController.value),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Get Pac-Man rotation based on direction
  double _getPacmanRotation() {
    switch (pacman.direction) {
      case Direction.right:
        return 0;
      case Direction.down:
        return pi / 2;
      case Direction.left:
        return pi;
      case Direction.up:
        return -pi / 2;
      default:
        return 0;
    }
  }

  /// Build ghost character
  Widget _buildGhost(Ghost ghost, double tileSize) {
    return Positioned(
      left: ghost.x * tileSize + tileSize * 0.1,
      top: ghost.y * tileSize + tileSize * 0.1,
      width: tileSize * 0.8,
      height: tileSize * 0.8,
      child: Container(
        decoration: BoxDecoration(
          color: ghost.isVulnerable ? Colors.blue : ghost.color,
          borderRadius: BorderRadius.circular(tileSize * 0.4),
          boxShadow: [
            BoxShadow(
              color: (ghost.isVulnerable ? Colors.blue : ghost.color).withOpacity(0.6),
              blurRadius: 3,
              spreadRadius: 1,
            ),
          ],
        ),
        child: CustomPaint(
          painter: GhostPainter(ghost.isVulnerable),
        ),
      ),
    );
  }

  /// Build touch control interface
  Widget _buildTouchControls() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Up button
          GestureDetector(
            onTap: () => _handleSwipe(Direction.up),
            child: _buildControlButton(Icons.keyboard_arrow_up),
          ),
          
          const SizedBox(height: 10),
          
          // Left, Down, Right buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () => _handleSwipe(Direction.left),
                child: _buildControlButton(Icons.keyboard_arrow_left),
              ),
              GestureDetector(
                onTap: () => _handleSwipe(Direction.down),
                child: _buildControlButton(Icons.keyboard_arrow_down),
              ),
              GestureDetector(
                onTap: () => _handleSwipe(Direction.right),
                child: _buildControlButton(Icons.keyboard_arrow_right),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Build individual control button
  Widget _buildControlButton(IconData icon) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withOpacity(0.5)),
      ),
      child: Icon(
        icon,
        color: Colors.white,
        size: 30,
      ),
    );
  }

  /// Build game over overlay
  Widget _buildGameOverOverlay() {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.8),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(30),
            margin: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.yellow, width: 2),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  gameWon ? '🎉 Level Complete!' : '💀 Game Over',
                  style: TextStyle(
                    color: gameWon ? Colors.green : Colors.red,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                const SizedBox(height: 20),
                
                Text(
                  'Final Score: $score',
                  style: const TextStyle(
                    color: Colors.yellow,
                    fontSize: 22,
                  ),
                ),
                
                const SizedBox(height: 30),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: _restartGame,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Play Again'),
                    ),
                    
                    ElevatedButton(
                      onPressed: _returnToMenu,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Main Menu'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Custom painter for Pac-Man mouth animation
class PacmanPainter extends CustomPainter {
  final double animationValue;
  
  PacmanPainter(this.animationValue);
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    
    // Draw mouth opening
    final sweepAngle = pi / 3 * animationValue; // Mouth opens and closes
    
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -sweepAngle / 2,
      sweepAngle,
      true,
      paint,
    );
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Custom painter for ghost eyes
class GhostPainter extends CustomPainter {
  final bool isVulnerable;
  
  GhostPainter(this.isVulnerable);
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isVulnerable ? Colors.white : Colors.white
      ..style = PaintingStyle.fill;
    
    // Draw eyes
    final eyeRadius = size.width * 0.08;
    final leftEye = Offset(size.width * 0.3, size.height * 0.3);
    final rightEye = Offset(size.width * 0.7, size.height * 0.3);
    
    canvas.drawCircle(leftEye, eyeRadius, paint);
    canvas.drawCircle(rightEye, eyeRadius, paint);
    
    // Draw pupils
    paint.color = Colors.black;
    final pupilRadius = eyeRadius * 0.5;
    canvas.drawCircle(leftEye, pupilRadius, paint);
    canvas.drawCircle(rightEye, pupilRadius, paint);
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
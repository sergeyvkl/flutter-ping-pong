import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const PongApp());
}

class PongApp extends StatelessWidget {
  const PongApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ping Pong Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MainMenuScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: _AnimatedBackgroundPainter(),
            ),
          ),
        
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'PING PONG',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Arial',
                  shadows: [
                    Shadow(
                        blurRadius: 10,
                        color: Colors.blue,
                        offset: Offset(0, 0),
                    ),
                  ]
                ),
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                  )
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      //builder: (context) => const PongGameScreen(gameMode: GameMode.singlePlayer),
                      builder: (context) => const SettingsScreen(gameMode: GameMode.singlePlayer),
                    ),
                  );
                },
                child: const Text(
                  'Single Player',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                  )
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingsScreen(
                          gameMode: GameMode.multiplayer),
                    ),
                  );
                },
                child: const Text(
                  'Multiplayer',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                  )
                ),
                onPressed: () {
                  // В будущем можно добавить онлайн-режим
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Online mode coming soon!')),
                  );
                },
                child: const Text(
                  'Online Play',
                  style: TextStyle(fontSize: 20),
                ),
              ),

              const SizedBox(height: 40),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HowToPlayScreen(),
                    ),
                  );
                },
                child: const Text(
                  'How to Play',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              )

            ],
          ),
        ),
        ]
      ),
    );
  }
}

class _AnimatedBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue.withOpacity(0.05)
      ..style = PaintingStyle.fill;

    // Рисуем случайные круги для анимированного фона
    final random = Random(0);
    for (int i = 0; i < 20; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = random.nextDouble() * 30 + 10;
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class HowToPlayScreen extends StatelessWidget {
  const HowToPlayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('How to Play'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Controls:',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              '- Drag up/down to move your paddle\n'
              '- Tap to start/pause the game\n'
              '- Try to hit the ball past your opponent',
              style: TextStyle(color: Colors.white70, fontSize: 18),
            ),
            const SizedBox(height: 30),
            const Text(
              'Game Modes:',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Single Player: Play against AI\n'
              'Multiplayer: Play with a friend on the same device\n'
              'Online: Coming soon!',
              style: TextStyle(color: Colors.white70, fontSize: 18),
            ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Back to Menu'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum GameMode { singlePlayer, multiplayer, online }
enum Difficulty { easy, medium, hard }

class SettingsScreen extends StatefulWidget {
  final GameMode gameMode;

  const SettingsScreen({super.key, required this.gameMode});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Difficulty _difficulty = Difficulty.medium;
  bool _soundEnabled = true;
  bool _particlesEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
            '${widget.gameMode == GameMode.singlePlayer ? 'Single Player' : 'Multiplayer'} Settings'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.gameMode == GameMode.singlePlayer) ...[
                const Text(
                  'Difficulty:',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _buildDifficultyButton(Difficulty.easy, 'Easy'),
                    const SizedBox(width: 10),
                    _buildDifficultyButton(Difficulty.medium, 'Medium'),
                    const SizedBox(width: 10),
                    _buildDifficultyButton(Difficulty.hard, 'Hard'),
                  ],
                ),
                const SizedBox(height: 30),
              ],
              const Text(
                'Options:',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              const SizedBox(height: 10),
              SwitchListTile(
                 title: const Text(
                  'Sound Effects',
                  style: TextStyle(color: Colors.white70),
                 ),
                 value: _soundEnabled,
                 onChanged: (value) {
                  setState(() {
                    _soundEnabled = value;
                  });
                }, 
              ),
              SwitchListTile(
                 title: const Text(
                  'Particle Effects',
                  style: TextStyle(color: Colors.white70),
                 ),
                 value: _particlesEnabled,
                 onChanged: (value) {
                  setState(() {
                    _particlesEnabled = value;
                  });
                }, 
              ),
              const Spacer(),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40, 
                      vertical: 15
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PongGameScreen(
                          gameMode: widget.gameMode,
                          difficulty: _difficulty,
                          soundEnabled: _soundEnabled,
                          particlesEnabled: _particlesEnabled,
                        ),
                      ),
                    );
                  },                  
                  child: const Text(
                    'Start Game',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              )
            ],
          ),
       ),
    );
  }

  Widget _buildDifficultyButton(Difficulty difficulty, String text) {
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: _difficulty == difficulty
              ? Colors.blue
              : Colors.grey[800],
        ),
        onPressed: () {
          setState(() {
            _difficulty = difficulty;
          });
        },
        child: Text(text),
      ),
    );
  }
}

class PongGameScreen extends StatefulWidget {
  final GameMode gameMode;
  final Difficulty difficulty;
  final bool soundEnabled;
  final bool particlesEnabled;

  const PongGameScreen({
    super.key,
    required this.gameMode,
    this.difficulty = Difficulty.medium,
    this.soundEnabled = true,
    this.particlesEnabled = true,
  });

  @override
  State<PongGameScreen> createState() => _PongGameScreenState();
}

class _PongGameScreenState extends State<PongGameScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  // Игровые переменные
  double _playerPaddleY = 0.5;
  double _computerPaddleY = 0.5;
  double _ballX = 0.5;
  double _ballY = 0.5;
  double _ballSpeedX = 0.01;
  double _ballSpeedY = 0.01;
  int _playerScore = 0;
  int _computerScore = 0;
  bool _gameStarted = false;
  bool _gamePaused = false;
  final double _paddleWidth = 0.02;
  final double _paddleHeight = 0.2;
  final double _ballSize = 0.03;
  final double _gameWidth = 1.0;
  final double _gameHeight = 1.0;
  double _aiDifficulty = 0.03;

  // Текстуры и изображения
  ui.Image? _ballImage;
  ui.Image? _playerPaddleImage;
  ui.Image? _computerPaddleImage;
  bool _imagesLoaded = false;

  // Частицы
  final List<Particle> _particles = [];

  @override
  void initState() {
    super.initState();
    _loadImages();
    _setDifficulty();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 16), // ~60 FPS
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller)
      ..addListener(() {
        _updateGame();
      });
    _controller.repeat();
    _resetBall();
  }

  void _setDifficulty() {
    switch (widget.difficulty) {
      case Difficulty.easy:
        _aiDifficulty = 0.02;
        break;
      case Difficulty.medium:
        _aiDifficulty = 0.03;
        break;
      case Difficulty.hard:
        _aiDifficulty = 0.045;
        break;
    }
  }

  Future<void> _loadImages() async {
    try {
      final ballData = await rootBundle.load('assets/images/ball.png');
      final playerPaddleData =
          await rootBundle.load('assets/images/player_paddle.png');
      final computerPaddleData =
          await rootBundle.load('assets/images/computer_paddle.png');

      final ballBytes = ballData.buffer.asUint8List();
      final playerPaddleBytes = playerPaddleData.buffer.asUint8List();
      final computerPaddleBytes = computerPaddleData.buffer.asUint8List();

      _ballImage = await decodeImageFromList(ballBytes);
      _playerPaddleImage = await decodeImageFromList(playerPaddleBytes);
      _computerPaddleImage = await decodeImageFromList(computerPaddleBytes);

      setState(() {
        _imagesLoaded = true;
      });
    } catch (e) {
      // Если изображения не загружены, используем стандартную отрисовку
      debugPrint('Error loading images: $e');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateGame() {
    if (!_gameStarted || _gamePaused) return;

    // Движение мяча
    _ballX += _ballSpeedX;
    _ballY += _ballSpeedY;

    // Отскок от верхней и нижней стенок
    if (_ballY <= 0 || _ballY >= 1) {
      _ballSpeedY = -_ballSpeedY;
      _addParticles(_ballX, _ballY, Colors.white);
    }

    // Отскок от ракетки игрока
    if (_ballX <= _paddleWidth &&
        _ballY >= _playerPaddleY - _paddleHeight / 2 &&
        _ballY <= _playerPaddleY + _paddleHeight / 2) {
      _ballSpeedX = -_ballSpeedX * 1.05;
      double hitPosition = (_ballY - _playerPaddleY) / (_paddleHeight / 2);
      _ballSpeedY = hitPosition * 0.03;
      _addParticles(_ballX, _ballY, Colors.blue);
    }

    // Отскок от ракетки компьютера
    if (_ballX >= 1 - _paddleWidth &&
        _ballY >= _computerPaddleY - _paddleHeight / 2 &&
        _ballY <= _computerPaddleY + _paddleHeight / 2) {
      _ballSpeedX = -_ballSpeedX * 1.05;
      double hitPosition = (_ballY - _computerPaddleY) / (_paddleHeight / 2);
      _ballSpeedY = hitPosition * 0.03;
      _addParticles(_ballX, _ballY, Colors.red);
    }

    // Гол за компьютер
    if (_ballX <= 0) {
      _computerScore++;
      _resetBall();
      _gameStarted = false;
    }

    // Гол за игрока
    if (_ballX >= 1) {
      _playerScore++;
      _resetBall();
      _gameStarted = false;
    }

    // ИИ компьютера
    if (widget.gameMode == GameMode.singlePlayer) {
      if (_computerPaddleY < _ballY - _aiDifficulty) {
        _computerPaddleY += _aiDifficulty * 1.5;
      } else if (_computerPaddleY > _ballY + _aiDifficulty) {
        _computerPaddleY -= _aiDifficulty * 1.5;
      }
    }

    // Обновление частиц
    if (widget.particlesEnabled) {
      _updateParticles();
    }

    setState(() {});
  }

  void _addParticles(double x, double y, Color color) {
    if (!widget.particlesEnabled) return;

    final random = Random();
    for (int i = 0; i < 10; i++) {
      _particles.add(Particle(
        x: x,
        y: y,
        vx: random.nextDouble() * 0.02 - 0.01,
        vy: random.nextDouble() * 0.02 - 0.01,
        radius: random.nextDouble() * 3 + 1,
        color: color.withOpacity(random.nextDouble() * 0.5 + 0.5),
        life: random.nextInt(20) + 10,
      ));
    }
  }

  void _updateParticles() {
    _particles.removeWhere((particle) => particle.life <= 0);
    for (var particle in _particles) {
      particle.update();
    }
  }

  void _resetBall() {
    _ballX = 0.5;
    _ballY = 0.5;
    final random = Random();
    _ballSpeedX = 0.01 * (random.nextBool() ? 1 : -1);
    _ballSpeedY = 0.01 * (random.nextDouble() * 2 - 1);
    _particles.clear();
  }

  void _startGame() {
    setState(() {
      _gameStarted = true;
      _gamePaused = false;
    });
  }

  void _togglePause() {
    setState(() {
      _gamePaused = !_gamePaused;
    });
  }

  void _onVerticalDragUpdate(DragUpdateDetails details, BoxConstraints constraints) {
    if (widget.gameMode == GameMode.multiplayer) {
      // В мультиплеере второй игрок управляет правой ракеткой
      final renderBox = context.findRenderObject() as RenderBox;
      final localPosition = renderBox.globalToLocal(details.globalPosition);
      setState(() {
        _computerPaddleY = localPosition.dy / constraints.maxHeight;
        _computerPaddleY = _computerPaddleY.clamp(
            _paddleHeight / 2, 1 - _paddleHeight / 2);
      });
    } else {
      final renderBox = context.findRenderObject() as RenderBox;
      final localPosition = renderBox.globalToLocal(details.globalPosition);
      setState(() {
        _playerPaddleY = localPosition.dy / constraints.maxHeight;
        _playerPaddleY = _playerPaddleY.clamp(
            _paddleHeight / 2, 1 - _paddleHeight / 2);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return GestureDetector(
            onTap: () {
              if (!_gameStarted) {
                _startGame();
              } else {
                _togglePause();
              }
            },
            onVerticalDragUpdate: (details) =>
                _onVerticalDragUpdate(details, constraints),
            child: Stack(
              children: [
                // Игровое поле
                CustomPaint(
                  size: Size(constraints.maxWidth, constraints.maxHeight),
                  painter: _PongPainter(
                    playerPaddleY: _playerPaddleY,
                    computerPaddleY: _computerPaddleY,
                    ballX: _ballX,
                    ballY: _ballY,
                    playerScore: _playerScore,
                    computerScore: _computerScore,
                    gameStarted: _gameStarted,
                    gamePaused: _gamePaused,
                    gameMode: widget.gameMode,
                    ballImage: _ballImage,
                    playerPaddleImage: _playerPaddleImage,
                    computerPaddleImage: _computerPaddleImage,
                    imagesLoaded: _imagesLoaded,
                    particles: widget.particlesEnabled ? _particles : [],
                  ),
                ),
                // Сообщение о начале игры
                if (!_gameStarted)
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.gameMode == GameMode.singlePlayer
                              ? 'Tap to start vs Computer'
                              : 'Tap to start vs Player',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          '$_playerScore : $_computerScore',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                // Сообщение о паузе
                if (_gamePaused)
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Game Paused',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          '$_playerScore : $_computerScore',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Tap to continue',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                // Кнопка назад
                Positioned(
                  top: 40,
                  left: 20,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class Particle {
  double x;
  double y;
  double vx;
  double vy;
  double radius;
  Color color;
  int life;

  Particle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.radius,
    required this.color,
    required this.life,
  });

  void update() {
    x += vx;
    y += vy;
    life--;
    radius = max(0, radius - 0.1);
  }
}

class _PongPainter extends CustomPainter {
  final double playerPaddleY;
  final double computerPaddleY;
  final double ballX;
  final double ballY;
  final int playerScore;
  final int computerScore;
  final bool gameStarted;
  final bool gamePaused;
  final GameMode gameMode;
  final ui.Image? ballImage;
  final ui.Image? playerPaddleImage;
  final ui.Image? computerPaddleImage;
  final bool imagesLoaded;
  final List<Particle> particles;

  _PongPainter({
    required this.playerPaddleY,
    required this.computerPaddleY,
    required this.ballX,
    required this.ballY,
    required this.playerScore,
    required this.computerScore,
    required this.gameStarted,
    required this.gamePaused,
    required this.gameMode,
    required this.ballImage,
    required this.playerPaddleImage,
    required this.computerPaddleImage,
    required this.imagesLoaded,
    required this.particles,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Фон
    final bgPaint = Paint()..color = Colors.black;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // Отрисовка центральной линии
    final centerLinePaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (double i = 0; i < size.height; i += 20) {
      canvas.drawLine(
        Offset(size.width / 2, i),
        Offset(size.width / 2, i + 10),
        centerLinePaint,
      );
    }

    // Отрисовка частиц
    for (final particle in particles) {
      final paint = Paint()..color = particle.color;
      canvas.drawCircle(
        Offset(particle.x * size.width, particle.y * size.height),
        particle.radius,
        paint,
      );
    }

    // Отрисовка ракетки игрока (слева)
    if (imagesLoaded && playerPaddleImage != null) {
      // Текстурированная ракетка
      final srcRect = Rect.fromLTWH(
        0,
        0,
        playerPaddleImage!.width.toDouble(),
        playerPaddleImage!.height.toDouble(),
      );
      final dstRect = Rect.fromCenter(
        center: Offset(size.width * 0.02, playerPaddleY * size.height),
        width: size.width * 0.04,
        height: size.height * 0.2,
      );
      canvas.drawImageRect(playerPaddleImage!, srcRect, dstRect, Paint());
    } else {
      // Простая ракетка
      final paint = Paint()
        ..color = Colors.blue
        ..style = PaintingStyle.fill;
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset(size.width * 0.02, playerPaddleY * size.height),
          width: size.width * 0.04,
          height: size.height * 0.2,
        ),
        paint,
      );
    }

    // Отрисовка ракетки компьютера или второго игрока (справа)
    if (imagesLoaded && computerPaddleImage != null) {
      // Текстурированная ракетка
      final srcRect = Rect.fromLTWH(
        0,
        0,
        computerPaddleImage!.width.toDouble(),
        computerPaddleImage!.height.toDouble(),
      );
      final dstRect = Rect.fromCenter(
        center: Offset(size.width * 0.98, computerPaddleY * size.height),
        width: size.width * 0.04,
        height: size.height * 0.2,
      );
      canvas.drawImageRect(computerPaddleImage!, srcRect, dstRect, Paint());
    } else {
      // Простая ракетка
      final paint = Paint()
        ..color = gameMode == GameMode.singlePlayer ? Colors.red : Colors.green
        ..style = PaintingStyle.fill;
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset(size.width * 0.98, computerPaddleY * size.height),
          width: size.width * 0.04,
          height: size.height * 0.2,
        ),
        paint,
      );
    }

    // Отрисовка мяча
    if (imagesLoaded && ballImage != null) {
      // Текстурированный мяч
      final srcRect = Rect.fromLTWH(
        0,
        0,
        ballImage!.width.toDouble(),
        ballImage!.height.toDouble(),
      );
      final dstRect = Rect.fromCenter(
        center: Offset(ballX * size.width, ballY * size.height),
        width: size.width * 0.03,
        height: size.width * 0.03,
      );
      canvas.drawImageRect(ballImage!, srcRect, dstRect, Paint());
    } else {
      // Простой мяч
      final paint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;
      canvas.drawCircle(
        Offset(ballX * size.width, ballY * size.height),
        size.width * 0.015,
        paint,
      );
    }

    // Добавляем свечение мяча
    if (gameStarted && !gamePaused) {
      final glowPaint = Paint()
        ..color = Colors.white.withOpacity(0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

      canvas.drawCircle(
        Offset(ballX * size.width, ballY * size.height),
        size.width * 0.025,
        glowPaint,
      );
    }

    // Отрисовка счета
    final textStyle = TextStyle(
      color: Colors.white,
      fontSize: size.width * 0.1,
      fontWeight: FontWeight.bold,
    );

    final textSpan = TextSpan(
      text: '$playerScore',
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(size.width * 0.25 - textPainter.width / 2, size.height * 0.1),
    );

    final textSpan2 = TextSpan(
      text: '$computerScore',
      style: textStyle,
    );
    final textPainter2 = TextPainter(
      text: textSpan2,
      textDirection: TextDirection.ltr,
    );
    textPainter2.layout();
    textPainter2.paint(
      canvas,
      Offset(size.width * 0.75 - textPainter2.width / 2, size.height * 0.1),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

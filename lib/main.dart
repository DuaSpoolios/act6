import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rocket Launch Controller',
      theme:ThemeData(
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),
      home: const LaunchController(),
    );
  }
}

class LaunchController extends StatefulWidget {
  const LaunchController({super.key});

  @override
  State<LaunchController> createState() => _LaunchControllerState();
}

class _LaunchControllerState extends State<LaunchController> {
  static const int _min = 0;
  static const int _max = 100;

  int _counter = 0;
  bool _shownLiftoffDialog = false;

  void _setCounter(int value) {
    final clamped = value.clamp(_min, _max);
    final reachedLiftoff = clamped == _max;

    setState(() {
      _counter = clamped;
    });

    if (reachedLiftoff && !_shownLiftoffDialog) {
      _shownLiftoffDialog = true;
      _showLiftoffDialog();
    }
    if (!reachedLiftoff) {
      // allow the dialog to show again if user drops below 100
      _shownLiftoffDialog = false;
    }
  }

  void _increment() => _setCounter(_counter + 1);
  void _decrement() => _setCounter(_counter - 1);
  void _reset() => _setCounter(0);

  Color _numberColorFor(int value) {
    if (value == 0) return Colors.red;          // exactly 0 -> Red
    if (value > 50) return Colors.green;        // above 50 -> Green
    return Colors.orange;                        // 1..50 -> Yellow/Orange
  }

  Future<void> _showLiftoffDialog() async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('LIFTOFF! 🚀'),
          content: const Text(
            'Congratulations, Cadet!\nYour rocket has reached maximum launch value (100).',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rocket Launch Controller'),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          CustomPaint(
            size: Size.infinite,
            painter: StarryBackground(),
          ),

          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _counter == _max ? 'LIFTOFF! 🚀' : '$_counter',
                      style: TextStyle(
                        fontSize: 72,
                        fontWeight: FontWeight.w900,
                        color: _numberColorFor(_counter),
                      ),
                    ),
                    const SizedBox(height: 24),


                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Slider(
                          min: _min.toDouble(),
                          max: _max.toDouble(),
                          value: _counter.toDouble(),
                          onChanged: (v) => _setCounter(v.toInt()),
                          activeColor: Colors.blue,
                          inactiveColor: Colors.grey,
                        ),
                        Row(
                          mainAxisAlignment:MainAxisAlignment.spaceBetween,
                          children: const [
                            Text('0'),
                            Text('100'),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      alignment: WrapAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _counter> _min ? _decrement : null,
                          icon: const Icon(Icons.remove),
                          label: const Text('Decrement'),
                        ),
                        ElevatedButton.icon(
                          onPressed: _counter < _max ? _increment : null,
                          icon: const Icon(Icons.local_fire_department),
                          label: const Text('Ignite (+1)'),
                        ),
                        ElevatedButton.icon(
                          onPressed: _counter != 0 ? _reset : null,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Reset'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class StarryBackground extends CustomPainter {
  final Random _rand = Random();
  final int starCount = 120;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;
    for (int i = 0; i < starCount; i++) {
      final dx = _rand.nextDouble() * size.width;
      final dy = _rand.nextDouble() * size.height;
      final radius = _rand.nextDouble() * 1.5 + 0.5; 
      canvas.drawCircle(Offset(dx, dy), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate)=> false;
}

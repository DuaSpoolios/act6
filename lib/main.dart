import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rocket Launch Controller',
      theme: ThemeData(
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
    // Clamp to 0..100 and update UI
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
      // if the value dips below 100 again, allow showing dialog on future 100s
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
    final numberColor = _numberColorFor(_counter);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rocket Launch Controller'),
        centerTitle: true,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Display panel
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: Column(
                    children: [
                      Text(
                        _counter == _max ? 'LIFTOFF!' : 'Fuel Level',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '$_counter',
                        style: TextStyle(
                          fontSize: 72,
                          fontWeight: FontWeight.w900,
                          color: numberColor,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Slider (0..100)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Slider(
                      min: _min.toDouble(),
                      max: _max.toDouble(),
                      value: _counter.toDouble(),
                      onChanged: (v) => _setCounter(v.toInt()),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('0'),
                        Text('100'),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Buttons row: Decrement, Ignite, Reset
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _counter > _min ? _decrement : null,
                      icon: const Icon(Icons.remove),
                      label: const Text('Decrement'),
                    ),
                    FilledButton.icon(
                      onPressed: _counter < _max ? _increment : null,
                      icon: const Icon(Icons.local_fire_department),
                      label: const Text('Ignite (+1)'),
                    ),
                    OutlinedButton.icon(
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
    );
  }
}

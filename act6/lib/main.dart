import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rocket Launch Controller',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const CounterWidget(),
    );
  }
}

class CounterWidget extends StatefulWidget {
  const CounterWidget({super.key});

  @override
  _CounterWidgetState createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  int _counter = 0;

  /// Get color based on counter value
  Color _getTextColor() {
    if (_counter == 0) return Colors.red;
    if (_counter > 50) return Colors.green;
    return Colors.orange;
  }

  /// Show popup at liftoff
  void _showLiftoffPopup() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("🚀 LIFTOFF!"),
        content: const Text(
          "Congratulations, cadet! Your rocket has launched successfully!",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void _incrementCounter() {
    setState(() {
      if (_counter < 100) {
        _counter++;
        if (_counter == 100) {
          _showLiftoffPopup();
        }
      }
    });
  }

  void _decrementCounter() {
    setState(() {
      if (_counter > 0) {
        _counter--;
      }
    });
  }

  void _resetCounter() {
    setState(() {
      _counter = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rocket Launch Controller'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Counter display
          Center(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Text(
                _counter == 100 ? "LIFTOFF!" : '$_counter',
                style: TextStyle(
                  fontSize: 50.0,
                  fontWeight: FontWeight.bold,
                  color: _counter == 100 ? Colors.blue : _getTextColor(),
                ),
              ),
            ),
          ),

          // Slider
          Slider(
            min: 0,
            max: 100,
            value: _counter.toDouble(),
            onChanged: (double value) {
              setState(() {
                _counter = value.toInt();
                if (_counter == 100) {
                  _showLiftoffPopup();
                }
              });
            },
            activeColor: Colors.blue,
            inactiveColor: Colors.grey,
          ),

          const SizedBox(height: 20),

          // Control buttons
          Wrap(
            spacing: 12,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _incrementCounter,
                child: const Text("Ignite +1"),
              ),
              ElevatedButton(
                onPressed: _decrementCounter,
                child: const Text("Decrement -1"),
              ),
              ElevatedButton(
                onPressed: _resetCounter,
                child: const Text("Reset"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

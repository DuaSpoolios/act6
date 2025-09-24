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
      _shownLiftoffDialog = false;
    }
  }

  void _increment() => _setCounter(_counter + 1);
  void _decrement() => _setCounter(_counter - 1);
  void _reset() => _setCounter(0);

  Color _numberColorFor(int value) {
    if (value == 0) return Colors.red;
    if (value > 50) return Colors.green;
    return Colors.orange;
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
2}


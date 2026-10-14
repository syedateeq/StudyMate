import 'dart:async';
import 'package:flutter/material.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  static const int _totalSeconds = 25 * 60;
  int _remainingSeconds = _totalSeconds;
  int _completedSessions = 0;
  Timer? _timer;
  bool _isRunning = false;

  double get _progress =>
      (_totalSeconds - _remainingSeconds) / _totalSeconds;

  String get _formattedTime {
    final minutes = _remainingSeconds ~/ 60;
    final seconds = _remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void _startTimer() {
    if (_isRunning) return;
    setState(() => _isRunning = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds <= 0) {
        timer.cancel();
        setState(() {
          _isRunning = false;
          _completedSessions++;
        });
        _showCompletionDialog();
        return;
      }
      setState(() => _remainingSeconds--);
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() => _isRunning = false);
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _remainingSeconds = _totalSeconds;
      _isRunning = false;
    });
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Row(
          children: const [
            Text('🎉 ', style: TextStyle(fontSize: 28)),
            Text('Session Complete!'),
          ],
        ),
        content: const Text(
          'Great job! You completed a 25-minute focus session.\n\nTake a short break before your next session.',
        ),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              _resetTimer();
            },
            child: const Text('Start New Session'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          children: [
            // Header
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pomodoro Timer',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Focus for 25 minutes, then take a short break.',
                    style: TextStyle(
                      fontSize: 14,
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Timer circle
            SizedBox(
              width: 240,
              height: 240,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 240,
                    height: 240,
                    child: CircularProgressIndicator(
                      value: _progress,
                      strokeWidth: 10,
                      backgroundColor:
                          colorScheme.primary.withValues(alpha: 0.12),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _isRunning
                            ? colorScheme.primary
                            : colorScheme.primary.withValues(alpha: 0.5),
                      ),
                      strokeCap: StrokeCap.round,
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _formattedTime,
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _isRunning ? 'Focusing...' : 'Ready',
                        style: TextStyle(
                          fontSize: 14,
                          color:
                              colorScheme.onSurface.withValues(alpha: 0.5),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Control buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _controlButton(
                  icon: Icons.restart_alt,
                  label: 'Reset',
                  color: Colors.orange,
                  onPressed: _resetTimer,
                ),
                const SizedBox(width: 20),
                SizedBox(
                  width: 80,
                  height: 80,
                  child: FilledButton(
                    onPressed: _isRunning ? _pauseTimer : _startTimer,
                    style: FilledButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: EdgeInsets.zero,
                    ),
                    child: Icon(
                      _isRunning ? Icons.pause : Icons.play_arrow,
                      size: 36,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                _controlButton(
                  icon: Icons.stop,
                  label: 'Stop',
                  color: Colors.red,
                  onPressed: () {
                    _pauseTimer();
                    _resetTimer();
                  },
                ),
              ],
            ),

            const SizedBox(height: 40),

            // Session info
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: BorderSide(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.emoji_events,
                          color: colorScheme.primary, size: 28),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Current Session',
                          style: TextStyle(
                            fontSize: 13,
                            color: colorScheme.onSurface
                                .withValues(alpha: 0.5),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Study Sessions Completed: $_completedSessions',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _controlButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Column(
      children: [
        IconButton.outlined(
          onPressed: onPressed,
          icon: Icon(icon, color: color),
          iconSize: 28,
          style: IconButton.styleFrom(
            side: BorderSide(color: color.withValues(alpha: 0.3)),
            padding: const EdgeInsets.all(14),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

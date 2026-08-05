import 'dart:math';

import 'package:flutter/material.dart';

import '../../../ui/painters/spinner_painter.dart';

class SpinnerScreen extends StatefulWidget {
  const SpinnerScreen({super.key});

  @override
  State<SpinnerScreen> createState() => _SpinnerScreenState();
}

class _SpinnerScreenState extends State<SpinnerScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final _random = Random();
  static const _segmentColors = <Color>[
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.red,
    Colors.teal,
  ];
  List<SpinnerSegment> _segments = const [
    SpinnerSegment(label: 'A', color: Colors.blue),
    SpinnerSegment(label: 'B', color: Colors.green),
    SpinnerSegment(label: 'C', color: Colors.orange),
    SpinnerSegment(label: 'D', color: Colors.purple),
  ];
  double _angle = 0;
  double _spinStartAngle = 0;
  double _spinTargetAngle = 0;
  int? _winnerIndex;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 3))
          ..addListener(() {
            if (!mounted) {
              return;
            }
            setState(() {
              _angle =
                  Curves.decelerate.transform(_controller.value) *
                      (_spinTargetAngle - _spinStartAngle) +
                  _spinStartAngle;
            });
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              final sweep = 2 * pi / _segments.length;
              final normalized = (_angle % (2 * pi) + 2 * pi) % (2 * pi);
              final pointerAngle = (2 * pi - normalized) % (2 * pi);
              setState(() {
                _winnerIndex =
                    (pointerAngle / sweep).floor() % _segments.length;
              });
            }
          });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _spin() {
    if (_controller.isAnimating || _segments.isEmpty) {
      return;
    }
    final extraTurns = 4 + _random.nextDouble() * 4;
    _spinStartAngle = _angle;
    _spinTargetAngle = _angle + (pi * 2 * extraTurns);
    _controller
      ..reset()
      ..forward();
  }

  Future<void> _addSegment() async {
    final controller = TextEditingController(
      text: String.fromCharCode(65 + _segments.length),
    );
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add segment'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Label'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
            child: const Text('Add'),
          ),
        ],
      ),
    );
    if (result == null || result.isEmpty) {
      return;
    }
    setState(() {
      _segments = [
        ..._segments,
        SpinnerSegment(
          label: result,
          color: _segmentColors[_segments.length % _segmentColors.length],
        ),
      ];
      _winnerIndex = null;
    });
  }

  void _removeSegment(int index) {
    if (_controller.isAnimating || _segments.length <= 2) {
      return;
    }
    setState(() {
      _segments = [
        for (var i = 0; i < _segments.length; i++)
          if (i != index) _segments[i],
      ];
      _winnerIndex = null;
    });
  }

  void _editSegment(int index) async {
    final controller = TextEditingController(text: _segments[index].label);
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rename segment'),
        content: TextField(controller: controller),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (result == null || result.isEmpty) {
      return;
    }
    setState(() {
      _segments = [
        for (var i = 0; i < _segments.length; i++)
          if (i == index)
            SpinnerSegment(label: result, color: _segments[index].color)
          else
            _segments[i],
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Spinner')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _controller.isAnimating ? null : _spin,
        icon: const Icon(Icons.play_arrow),
        label: const Text('Spin'),
        tooltip: 'Spin wheel',
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: SizedBox(
              width: 280,
              height: 280,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                    size: const Size.square(280),
                    painter: SpinnerPainter(
                      segments: _segments,
                      rotationAngle: _angle,
                      highlightedIndex: _winnerIndex,
                    ),
                  ),
                  const Positioned(
                    top: 0,
                    child: Icon(Icons.arrow_drop_down, size: 42),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (_winnerIndex != null)
            Text(
              'Winner: ${_segments[_winnerIndex!].label}',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
          const SizedBox(height: 16),
          Text('Segments', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: OutlinedButton.icon(
              onPressed: _controller.isAnimating ? null : _addSegment,
              icon: const Icon(Icons.add),
              label: const Text('Add Segment'),
            ),
          ),
          const SizedBox(height: 8),
          for (var i = 0; i < _segments.length; i++)
            ListTile(
              leading: CircleAvatar(backgroundColor: _segments[i].color),
              title: Text(_segments[i].label),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    tooltip: 'Rename segment',
                    onPressed: _controller.isAnimating
                        ? null
                        : () => _editSegment(i),
                    icon: const Icon(Icons.edit_outlined),
                  ),
                  IconButton(
                    tooltip: 'Remove segment',
                    onPressed: _controller.isAnimating || _segments.length <= 2
                        ? null
                        : () => _removeSegment(i),
                    icon: const Icon(Icons.remove_circle_outline),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class NumericKeypad extends StatefulWidget {
  const NumericKeypad({
    required this.onSubmitted,
    super.key,
    this.title = 'Enter score',
    this.allowNegative = false,
  });

  final ValueChanged<int> onSubmitted;
  final String title;
  final bool allowNegative;

  @override
  State<NumericKeypad> createState() => _NumericKeypadState();
}

class _NumericKeypadState extends State<NumericKeypad> {
  String _buffer = '';

  void _append(String digit) {
    setState(() {
      _buffer += digit;
    });
  }

  void _toggleNegative() {
    if (!widget.allowNegative) {
      return;
    }
    setState(() {
      if (_buffer.startsWith('-')) {
        _buffer = _buffer.substring(1);
      } else {
        _buffer = '-' + _buffer;
      }
    });
  }

  void _backspace() {
    if (_buffer.isEmpty) {
      return;
    }
    setState(() {
      _buffer = _buffer.substring(0, _buffer.length - 1);
    });
  }

  void _submit() {
    final value = int.tryParse(_buffer);
    if (value == null) {
      return;
    }
    widget.onSubmitted(value);
    setState(() {
      _buffer = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    const buttons = <String>['1', '2', '3', '4', '5', '6', '7', '8', '9'];
    return Column(
      children: [
        Text(widget.title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Theme.of(context).colorScheme.surface,
          ),
          child: Text(
            _buffer.isEmpty ? '0' : _buffer,
            textAlign: TextAlign.end,
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1.8,
          children: [
            for (final button in buttons)
              Semantics(
                button: true,
                label: 'Enter $button',
                child: FilledButton(
                  onPressed: () => _append(button),
                  child: Text(
                    button,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            Semantics(
              button: true,
              label: 'Toggle negative value',
              child: FilledButton.tonal(
                onPressed: widget.allowNegative ? _toggleNegative : null,
                child: const Text('+/-'),
              ),
            ),
            Semantics(
              button: true,
              label: 'Enter 0',
              child: FilledButton(
                onPressed: () => _append('0'),
                child: const Text(
                  '0',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            Semantics(
              button: true,
              label: 'Delete last digit',
              child: FilledButton.tonalIcon(
                onPressed: _backspace,
                icon: const Icon(Icons.backspace_outlined),
                label: const Text('Del'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: Semantics(
            button: true,
            label: 'Confirm numeric entry',
            child: FilledButton.icon(
              onPressed: _submit,
              icon: const Icon(Icons.check),
              label: const Text('Add score'),
            ),
          ),
        ),
      ],
    );
  }
}

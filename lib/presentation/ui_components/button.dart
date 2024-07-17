import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String text;
  final void Function() onPressed;
  final bool isEnabled;

  const Button({
    super.key,
    required this.text,
    required this.onPressed,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        if (isEnabled) onPressed();
      },
      child: Container(
        width: double.infinity,
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isEnabled ? theme.colorScheme.primary : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(text, style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white)),
      ),
    );
  }
}

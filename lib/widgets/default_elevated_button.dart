import 'package:flutter/material.dart';

class DefaultElevatedButton extends StatelessWidget {
  String label;
  VoidCallback onPreessed;

  DefaultElevatedButton({
    super.key,
    required this.label,
    required this.onPreessed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPreessed,
      style: ElevatedButton.styleFrom(
        fixedSize: Size(MediaQuery.sizeOf(context).width, 56),
      ),
      child: Text(label, style: Theme.of(context).textTheme.titleLarge),
    );
  }
}

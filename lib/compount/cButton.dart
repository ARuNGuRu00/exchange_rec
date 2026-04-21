import 'package:flutter/material.dart';

class Cbutton extends StatelessWidget {
  final String butValue;
  final double fSize = 20;
  final Function(String) onTap;
  const Cbutton({super.key, required this.butValue, required this.onTap});

  @override
  Widget build(BuildContext context) {
    IconData? icon;
    if (butValue == "flip") {
      icon = Icons.flip_camera_android_outlined;
    }
    if (butValue == "clear") {
      icon = Icons.fast_rewind;
    }
    if (butValue == "back") {
      icon = Icons.backspace;
    }
    return ElevatedButton(
      style: ButtonStyle(
        foregroundColor: WidgetStatePropertyAll(
          Theme.of(context).colorScheme.onPrimary,
        ),
        backgroundColor: WidgetStatePropertyAll(
          Theme.of(context).colorScheme.secondary,
        ),
        overlayColor: WidgetStatePropertyAll(Colors.transparent),
        elevation: WidgetStatePropertyAll(0),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      onPressed: () => onTap(butValue),
      child: icon != null
          ? Icon(icon, size: fSize + 3)
          : Text(
              butValue,
              style: TextStyle(
                fontSize: fSize,
                // color: Theme.of(context).textTheme.bodyLarge,
              ), //const Color.fromARGB(255, 239, 239, 239),
            ),
    );
  }
}

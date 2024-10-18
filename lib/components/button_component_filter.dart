import 'package:flutter/material.dart';

class ButtonFilterComponent extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final bool pressed;

  ButtonFilterComponent({
    required this.icon,
    required this.label,
    required this.onPressed,
    required this.pressed
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: pressed?Colors.blue:Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon,color: pressed?Colors.white:Colors.grey),
          const SizedBox(width: 8.0),
          Text(label, style: TextStyle(fontSize: 16.0, color: pressed?Colors.white:Colors.grey)),
        ],
      ),
    );
  }
}
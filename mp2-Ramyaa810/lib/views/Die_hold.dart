// ignore: file_names
import 'package:flutter/material.dart';

class DieHold extends StatefulWidget {
  final int? value;
  final bool isHeld;

  const DieHold({super.key, required this.value, required this.isHeld});

  @override
  State<DieHold> createState() => _DieState();
}

class _DieState extends State<DieHold> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(8),
        color: widget.isHeld ? Colors.blue : Colors.white,
      ),
      child: Center(
        child: Text(
          widget.value != null ? '${widget.value}' : '',
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
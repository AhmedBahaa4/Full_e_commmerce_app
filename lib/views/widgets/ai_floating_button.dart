// ignore_for_file: file_names

import 'package:flutter/material.dart';

class AiFloatingButton extends StatefulWidget {
  const AiFloatingButton({super.key});

  @override
  State<AiFloatingButton> createState() => _AiFloatingButtonState();
}

class _AiFloatingButtonState extends State<AiFloatingButton> {
  Offset position = const Offset(300, 500);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: Draggable(
        feedback: aiButton(),
        childWhenDragging: const SizedBox(),
        onDragEnd: (details) {
          setState(() {
            position = details.offset;
          });
        },
        child: aiButton(),
      ),
    );
  }

  Widget aiButton() {
    return FloatingActionButton(
      backgroundColor: Colors.black,
      onPressed: () {
        // open chat screen
      },
      child: const Icon(Icons.smart_toy, color: Colors.white),
    );
  }
}

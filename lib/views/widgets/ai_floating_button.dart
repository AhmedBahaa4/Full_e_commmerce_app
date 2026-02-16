// ignore_for_file: file_names

import 'package:flutter/material.dart';

class AiFloatingButton extends StatefulWidget {
  const AiFloatingButton({super.key});

  @override
  State<AiFloatingButton> createState() => _AiFloatingButtonState();
}

class _AiFloatingButtonState extends State<AiFloatingButton> {
  Offset position = Offset.zero;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;

    final size = MediaQuery.sizeOf(context);
    position = Offset(
      size.width - 72,
      (size.height * 0.72).clamp(120.0, size.height - 100),
    );
    _initialized = true;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: Draggable(
        feedback: aiButton(),
        childWhenDragging: const SizedBox(),
        onDragEnd: (details) {
          final parentBox = context.findRenderObject() as RenderBox?;
          final localOffset = parentBox != null
              ? parentBox.globalToLocal(details.offset)
              : details.offset;
          final maxX =
              (parentBox?.size.width ?? MediaQuery.sizeOf(context).width) - 64;
          final maxY =
              (parentBox?.size.height ?? MediaQuery.sizeOf(context).height) -
              64;

          setState(() {
            position = Offset(
              localOffset.dx.clamp(8.0, maxX),
              localOffset.dy.clamp(8.0, maxY),
            );
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

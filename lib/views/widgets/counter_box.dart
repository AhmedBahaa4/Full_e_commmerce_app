import 'package:e_commerc_app/utils/app_color.dart';
import 'package:flutter/material.dart';

class CounterBox extends StatelessWidget {
  final int value;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  const CounterBox({
    super.key,
    required this.value,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.grey),
        borderRadius: BorderRadius.circular(50),
        color: AppColors.greyshade,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          children: [
            IconButton(
              onPressed: onRemove,
              icon: const CircleAvatar(
                backgroundColor: AppColors.white,
                radius: 12,
                child: Icon(Icons.remove),
              ),
            ),
            Text(
              value.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            IconButton(
              onPressed: onAdd,
              icon: const CircleAvatar(
                backgroundColor: AppColors.white,
                radius: 12,
                child: Icon(Icons.add),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.grey5),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _CounterActionButton(icon: Icons.remove_rounded, onPressed: onRemove),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              '$value',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.black,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          _CounterActionButton(icon: Icons.add_rounded, onPressed: onAdd),
        ],
      ),
    );
  }
}

class _CounterActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _CounterActionButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.grey2,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onPressed,
        child: SizedBox(
          height: 30,
          width: 30,
          child: Icon(icon, color: AppColors.black, size: 18),
        ),
      ),
    );
  }
}

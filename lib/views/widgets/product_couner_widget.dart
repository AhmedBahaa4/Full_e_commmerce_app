import 'package:e_commerc_app/views/widgets/counter_box.dart';
import 'package:e_commerc_app/views_models/cubit/prodcut_details_page/product_deails_cubit.dart';
import 'package:flutter/material.dart';
class ProductCounterWidget extends StatelessWidget {
  final String productId;
  final int value;
  final ProductDeailsCubit cubit;

  const ProductCounterWidget({
    super.key,
    required this.productId,
    required this.value,
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    return CounterBox(
      value: value,
      onAdd: () => cubit.incrementCounter(productId),
      onRemove: () => cubit.decrementCounter(productId),
    );
  }
}

import 'package:e_commerc_app/models/add_to_cart_model.dart';
import 'package:e_commerc_app/views/widgets/counter_box.dart';
import 'package:e_commerc_app/views_models/cubit/cart_cubit/cart_cubit.dart';
import 'package:flutter/material.dart';

class CartCounterWidget extends StatelessWidget {
  final AddToCartModel cartItem;
  final int value;
  final CartCubit cubit;

  const CartCounterWidget({
    super.key,
    required this.cartItem,
    required this.value,
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    return CounterBox(
      value: value,
      onAdd: () => cubit.incrementCounter(cartItem.id),
      onRemove: () => cubit.decrementCounter(cartItem.id),
    );
  }
}

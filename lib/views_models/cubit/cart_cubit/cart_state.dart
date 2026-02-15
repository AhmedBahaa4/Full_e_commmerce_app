part of 'cart_cubit.dart';

sealed class CartState {
  const CartState();
}

final class CartInitial extends CartState {}

final class CartLoading extends CartState {}

final class CartLoaded extends CartState {
  final List<AddToCartModel> cartItems;
  final double subTotal;
  final double shipping;
  const CartLoaded(this.cartItems, this.subTotal, this.shipping);
}

final class CartError extends CartState {
  final String message;
  const CartError({required this.message});
}

final class CartUpdate extends CartState {
  final List<AddToCartModel> updateCart;

  CartUpdate({required this.updateCart});
}

final class QuantityCounterLoaded extends CartState {
  final int value;
  final String productId;
  const QuantityCounterLoaded({required this.value, required this.productId});
}

final class SubTotalUpdated extends CartState {
  final double subTotal;
  final double shipping;
  const SubTotalUpdated({required this.subTotal, required this.shipping});
}

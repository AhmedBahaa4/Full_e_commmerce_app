part of 'check_out_cubit.dart';

sealed class CheckOutState {}

final class CheckOutInitial extends CheckOutState {}

final class CheckOutLoading extends CheckOutState {}

final class CheckOutLoaded extends CheckOutState {
  final List<AddToCartModel> cartItems;
  final double totalAmount;
  final int numberOfProducts;
  final PaymentCardModel? choosenpaymentCard;
  final LocationItemModel? chosenAdress;

  CheckOutLoaded({
    required this.cartItems,
    required this.totalAmount,
    required this.numberOfProducts,
    this.choosenpaymentCard,
    this.chosenAdress,
  });
}

final class CheckOutError extends CheckOutState {
  final String message;
  CheckOutError( {required this.message});
}

part of 'product_deails_cubit.dart';

sealed class ProductDeailsState {}

final class ProductDeailsInitial extends ProductDeailsState {}

final class ProductDetailsLoading extends ProductDeailsState {}

final class QuantityCounterLoaded extends ProductDeailsState {
  final int value;
  QuantityCounterLoaded({required this.value});
}

final class ProductDetailsLoaded extends ProductDeailsState {
  final ProductItemModel product;

  ProductDetailsLoaded({required this.product});
}

final class SizeSelected extends ProductDeailsState {
  final ProductSize size;
  SizeSelected({required this.size});
}
 final class ProductAddedToCart extends ProductDeailsState {
  
  final String productId;
  ProductAddedToCart({required this.productId});

 }
 final class ProductAddingToCart extends ProductDeailsState {}

 final class ProductAddedToCartError extends ProductDeailsState {
  
  final String message;
  ProductAddedToCartError({required this.message});
 }


final class ProductDetailsError extends ProductDeailsState {

  final String message;

  ProductDetailsError({required this.message});
}


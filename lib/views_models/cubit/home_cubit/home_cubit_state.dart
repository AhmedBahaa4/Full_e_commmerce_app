part of 'home_cubit.dart';

sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class HomeLoading extends HomeState {}

final class HomeLoaded extends HomeState {
  HomeLoaded({
    required this.products,
    required this.carouselItems,
    this.searchQuery = '',
  });
  final List<HomeCarouselItemModel> carouselItems;
  final List<ProductItemModel> products;
  final String searchQuery;
}

final class HomeError extends HomeState {
  HomeError({required this.message});
  final String message;
}

final class SetFavoriteLoading extends HomeState {
  final String productId;

  SetFavoriteLoading({required this.productId});
}

final class SetFavoriteSuccess extends HomeState {
  final bool isFavorite;
  final String productId;

  SetFavoriteSuccess({required this.isFavorite, required this.productId});
}

final class SetFavoriteError extends HomeState {
  final String message;
  final String productId;

  SetFavoriteError({required this.message, required this.productId});
}

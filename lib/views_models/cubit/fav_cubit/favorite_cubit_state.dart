part of 'favorite_cubit_cubit.dart';

sealed class FavoriteCubitState {}

final class FavoriteCubitInitial extends FavoriteCubitState {}

final class FavoriteLoading extends FavoriteCubitState {}

final class FavoriteLoaded extends FavoriteCubitState {
  final List<ProductItemModel> favoriteProducts;
  FavoriteLoaded({required this.favoriteProducts});
}

final class FavoriteError extends FavoriteCubitState {
  final String message;

  FavoriteError({required this.message});
}

final class FavoriteRmoved extends FavoriteCubitState {
  final String productId;

  FavoriteRmoved({required this.productId});
}

final class FavoriteRmoveving extends FavoriteCubitState {
  final String productId;

  FavoriteRmoveving({required this.productId});
}

final class FavoriteRmovevEror extends FavoriteCubitState {
  final String message;

  FavoriteRmovevEror({required this.message});
}

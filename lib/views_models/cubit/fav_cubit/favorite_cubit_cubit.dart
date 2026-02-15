import 'package:e_commerc_app/models/product_item_model.dart';
import 'package:e_commerc_app/services/auth_services.dart';
import 'package:e_commerc_app/services/favorite_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'favorite_cubit_state.dart';

class FavoriteCubit extends Cubit<FavoriteCubitState> {
  FavoriteCubit() : super(FavoriteCubitInitial());
  final favoriteServices = FavoriteServicesImpl();
  final authServices = AuthServicesImpl();

  Future<void> getFavoriteProducts() async {
    emit(FavoriteLoading());

    try {
      final currentUser = authServices.currentUser();
      if (currentUser == null) {
        emit(FavoriteLoaded(favoriteProducts: const <ProductItemModel>[]));
        return;
      }
      final favoriteProducts = await favoriteServices.getFavorites(
        currentUser.uid,
      );
      emit(FavoriteLoaded(favoriteProducts: favoriteProducts));
    } catch (e) {
      emit(FavoriteError(message: e.toString()));
    }
  }

  Future<void> removeFavorite(String productId) async {
    emit(FavoriteRmoveving(productId: productId));
    try {
      final currentUser = authServices.currentUser();
      if (currentUser == null) {
        emit(FavoriteRmovevEror(message: 'You need to login first'));
        return;
      }
      await favoriteServices.removeFavorite(currentUser.uid, productId);

      emit(FavoriteRmoved(productId: productId));
      final favoriteProducts = await favoriteServices.getFavorites(
        currentUser.uid,
      );
      emit(FavoriteLoaded(favoriteProducts: favoriteProducts));
    } catch (e) {
      emit(FavoriteRmovevEror(message: e.toString()));
    }
  }
}

import 'package:e_commerc_app/models/product_item_model.dart';
import 'package:e_commerc_app/services/auth_services.dart';
import 'package:e_commerc_app/services/favorite_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'favorite_cubit_state.dart';

class FavoriteCubit extends Cubit<FavoriteCubitState> {
  FavoriteCubit() : super(FavoriteCubitInitial());
  final favoriteServices = FavoriteServicesImpl();
  final authServices = AuthServicesImpl();
  List<ProductItemModel> _favoriteProducts = const <ProductItemModel>[];
  List<ProductItemModel> get favoriteProducts =>
      List<ProductItemModel>.unmodifiable(_favoriteProducts);

  Future<void> getFavoriteProducts({bool showLoading = true}) async {
    if (showLoading || state is! FavoriteLoaded) {
      emit(FavoriteLoading());
    }

    try {
      final currentUser = authServices.currentUser();
      if (currentUser == null) {
        _favoriteProducts = const <ProductItemModel>[];
        emit(FavoriteLoaded(favoriteProducts: favoriteProducts));
        return;
      }
      final fetchedFavorites = await favoriteServices.getFavorites(
        currentUser.uid,
      );
      _favoriteProducts = fetchedFavorites;
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
      _favoriteProducts = _favoriteProducts
          .where((product) => product.id != productId)
          .toList();
      emit(FavoriteLoaded(favoriteProducts: favoriteProducts));
    } catch (e) {
      emit(FavoriteRmovevEror(message: e.toString()));
    }
  }
}

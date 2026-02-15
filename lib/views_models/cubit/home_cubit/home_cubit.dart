import 'package:e_commerc_app/models/home_carousel_item_model.dart';
import 'package:e_commerc_app/models/product_item_model.dart';
import 'package:e_commerc_app/services/auth_services.dart';
import 'package:e_commerc_app/services/favorite_services.dart';
import 'package:e_commerc_app/services/home_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_cubit_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  final authServices = AuthServicesImpl();
  final homeServices = HomeServicesImpl();
  final favoriteServices = FavoriteServicesImpl();
  Future<void> getHomeData() async {
    emit(HomeLoading());

    try {
      final currentUser = authServices.currentUser();
      final products = await homeServices.fetchProducts();
      final homeCarouselItems = await homeServices.fetchHomeCarouselItems();
      final favoritesProducts = currentUser == null
          ? <ProductItemModel>[]
          : await favoriteServices.getFavorites(currentUser.uid);

      final List<ProductItemModel> finalProducts = products.map((product) {
        final isFavorite = favoritesProducts.any(
          (item) => item.id == product.id,
        );
        return product.copyWith(isFavorite: isFavorite);
      }).toList();

      emit(
        HomeLoaded(carouselItems: homeCarouselItems, products: finalProducts),
      );
    } catch (e) {
      emit(HomeError(message: e.toString()));
    }
  }

  Future<void> setFevorite(ProductItemModel product) async {
    emit(SetFavoriteLoading(productId: product.id));

    try {
      final currentUser = authServices.currentUser();
      if (currentUser == null) {
        emit(
          SetFavoriteError(
            message: 'You need to login first',
            productId: product.id,
          ),
        );
        return;
      }
      final userId = currentUser.uid;
      final favoriteProducts = await favoriteServices.getFavorites(userId);
      final isFavorite = favoriteProducts.any((item) => item.id == product.id);
      if (isFavorite) {
        await favoriteServices.removeFavorite(userId, product.id);
      } else {
        await favoriteServices.addFavorite(userId, product);
      }

      emit(SetFavoriteSuccess(isFavorite: !isFavorite, productId: product.id));
    } catch (e) {
      emit(SetFavoriteError(message: e.toString(), productId: product.id));
    }
  }
}

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

  List<ProductItemModel> _allProducts = const <ProductItemModel>[];
  List<HomeCarouselItemModel> _carouselItems = const <HomeCarouselItemModel>[];
  String _searchQuery = '';

  List<ProductItemModel> get allProducts =>
      List<ProductItemModel>.unmodifiable(_allProducts);
  String get searchQuery => _searchQuery;

  ProductItemModel? findProductById(String productId) {
    for (final product in _allProducts) {
      if (product.id == productId) {
        return product;
      }
    }
    return null;
  }

  bool isProductFavorite(String productId) {
    for (final product in _allProducts) {
      if (product.id == productId) {
        return product.isFavorite;
      }
    }
    return false;
  }

  Future<void> getHomeData() async {
    final shouldShowLoading = state is! HomeLoaded;
    if (shouldShowLoading) {
      emit(HomeLoading());
    }

    try {
      final currentUser = authServices.currentUser();
      final productsFuture = homeServices.fetchProducts();
      final homeCarouselFuture = homeServices.fetchHomeCarouselItems();
      final favoritesFuture = currentUser == null
          ? Future.value(<ProductItemModel>[])
          : favoriteServices.getFavorites(currentUser.uid);

      final products = await productsFuture;
      final homeCarouselItems = await homeCarouselFuture;
      final favoritesProducts = await favoritesFuture;

      _allProducts = products.map((product) {
        final isFavorite = favoritesProducts.any(
          (item) => item.id == product.id,
        );
        return product.copyWith(isFavorite: isFavorite);
      }).toList();
      _carouselItems = homeCarouselItems;

      _emitHomeLoaded();
    } catch (e) {
      emit(HomeError(message: e.toString()));
    }
  }

  void setSearchQuery(String query) {
    final sanitized = query.trim();
    if (sanitized == _searchQuery) return;
    _searchQuery = sanitized;
    if (state is HomeLoaded) {
      _emitHomeLoaded();
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

      final productIndex = _allProducts.indexWhere(
        (item) => item.id == product.id,
      );
      bool isFavorite = productIndex != -1
          ? _allProducts[productIndex].isFavorite
          : false;

      if (productIndex == -1) {
        final favoriteProducts = await favoriteServices.getFavorites(
          currentUser.uid,
        );
        isFavorite = favoriteProducts.any((item) => item.id == product.id);
      }

      if (isFavorite) {
        await favoriteServices.removeFavorite(currentUser.uid, product.id);
      } else {
        await favoriteServices.addFavorite(currentUser.uid, product);
      }

      final updatedProduct = product.copyWith(isFavorite: !isFavorite);
      if (productIndex != -1) {
        final updatedProducts = List<ProductItemModel>.from(_allProducts);
        updatedProducts[productIndex] = updatedProduct;
        _allProducts = updatedProducts;
      } else {
        _allProducts = <ProductItemModel>[..._allProducts, updatedProduct];
      }

      emit(SetFavoriteSuccess(isFavorite: !isFavorite, productId: product.id));
      _emitHomeLoaded();
    } catch (e) {
      emit(SetFavoriteError(message: e.toString(), productId: product.id));
      if (_allProducts.isNotEmpty) {
        _emitHomeLoaded();
      }
    }
  }

  void _emitHomeLoaded() {
    emit(
      HomeLoaded(
        carouselItems: _carouselItems,
        products: _filteredProducts(_allProducts),
        searchQuery: _searchQuery,
      ),
    );
  }

  List<ProductItemModel> _filteredProducts(List<ProductItemModel> source) {
    final normalizedQuery = _searchQuery.toLowerCase();
    if (normalizedQuery.isEmpty) return source;

    return source.where((product) {
      final nameWords = product.name.toLowerCase().split(' ');
      final categoryWords = product.category.toLowerCase().split(' ');
      final matchesName = nameWords.any(
        (word) => word.startsWith(normalizedQuery),
      );
      final matchesCategory = categoryWords.any(
        (word) => word.startsWith(normalizedQuery),
      );
      return matchesName || matchesCategory;
    }).toList();
  }
}

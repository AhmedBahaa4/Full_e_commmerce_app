import 'package:e_commerc_app/models/category_model.dart';
import 'package:e_commerc_app/models/product_item_model.dart';
import 'package:e_commerc_app/utils/app_color.dart';
import 'package:e_commerc_app/utils/app_routes.dart';
import 'package:e_commerc_app/utils/responsive_helper.dart';
import 'package:e_commerc_app/views/widgets/product_item.dart';
import 'package:e_commerc_app/views_models/cubit/home_cubit/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryProductsPage extends StatefulWidget {
  final CategoryModel category;
  const CategoryProductsPage({super.key, required this.category});

  @override
  State<CategoryProductsPage> createState() => _CategoryProductsPageState();
}

class _CategoryProductsPageState extends State<CategoryProductsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final homeCubit = context.read<HomeCubit>();
      if (homeCubit.state is! HomeLoaded && homeCubit.state is! HomeLoading) {
        homeCubit.getHomeData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.category.name), centerTitle: true),
      body: BlocBuilder<HomeCubit, HomeState>(
        buildWhen: (previous, current) =>
            current is HomeLoading ||
            current is HomeLoaded ||
            current is HomeError,
        builder: (context, state) {
          if (state is HomeLoading || state is HomeInitial) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          if (state is HomeError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(state.message, textAlign: TextAlign.center),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => context.read<HomeCubit>().getHomeData(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is! HomeLoaded) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          final loadedState = state;
          final filteredProducts = _filterProductsByCategory(
            loadedState.products,
          );

          if (filteredProducts.isEmpty) {
            return Center(
              child: Text(
                'No products found for ${widget.category.name}',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: AppColors.grey),
              ),
            );
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              final maxContentWidth = ResponsiveHelper.maxContentWidth(context);
              final availableWidth = constraints.maxWidth > maxContentWidth
                  ? maxContentWidth
                  : constraints.maxWidth;
              final gridCount = ResponsiveHelper.productGridCount(
                availableWidth,
              );

              return Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxContentWidth),
                  child: GridView.builder(
                    padding: EdgeInsets.all(
                      ResponsiveHelper.horizontalPadding(context),
                    ),
                    itemCount: filteredProducts.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: gridCount,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: ResponsiveHelper.isLandscape(context)
                          ? 0.98
                          : 0.72,
                    ),
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      return InkWell(
                        onTap: () => Navigator.of(context, rootNavigator: true)
                            .pushNamed(
                              AppRoutes.productDetailsRoute,
                              arguments: product.id,
                            ),
                        child: ProductItem(productItem: product),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  List<ProductItemModel> _filterProductsByCategory(
    List<ProductItemModel> products,
  ) {
    final selected = widget.category.name.trim().toLowerCase();
    if (selected == 'new arrivals') {
      return products;
    }

    return products.where((product) {
      return product.category.trim().toLowerCase() == selected;
    }).toList();
  }
}

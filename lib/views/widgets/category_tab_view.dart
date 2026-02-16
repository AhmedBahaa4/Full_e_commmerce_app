import 'package:e_commerc_app/models/category_model.dart';
import 'package:e_commerc_app/utils/app_routes.dart';
import 'package:e_commerc_app/views_models/cubit/category_cubit/cubit/category_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryTabView extends StatelessWidget {
  const CategoryTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CategoryCubit()..getCategories(),
      child: BlocBuilder<CategoryCubit, CategoryState>(
        builder: (context, state) {
          if (state is CategoryLoading) {
            return const Center(child: CircularProgressIndicator.adaptive());
          } else if (state is CategoryLoaded) {
            return ListView.builder(
              itemCount: state.categories.length,
              itemBuilder: (BuildContext context, int index) {
                final category = state.categories[index];
                final isEven = index % 2 == 0;

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 12,
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context, rootNavigator: true).pushNamed(
                        AppRoutes.categoryProductsRoute,
                        arguments: category,
                      );
                    },
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        color: category.bgColor,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: isEven
                              ? [
                                  Expanded(
                                    flex: 3,
                                    child: _buildTextSection(context, category),
                                  ),
                                  const SizedBox(width: 12),
                                  Flexible(
                                    flex: 2,
                                    child: _buildImageSection(
                                      context,
                                      category,
                                    ),
                                  ),
                                ]
                              : [
                                  Flexible(
                                    flex: 2,
                                    child: _buildImageSection(
                                      context,
                                      category,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    flex: 3,
                                    child: _buildTextSection(context, category),
                                  ),
                                ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('Error loading categories'));
          }
        },
      ),
    );
  }

  Widget _buildTextSection(BuildContext context, CategoryModel category) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          category.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: category.textcolor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${category.productsCount} Products',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: category.textcolor,
          ),
        ),
      ],
    );
  }

  Widget _buildImageSection(BuildContext context, CategoryModel category) {
    if (category.imageUrl != null) {
      final imageWidth = (MediaQuery.sizeOf(context).width * 0.24).clamp(
        90.0,
        140.0,
      );
      final imagePath = category.imageUrl!;
      final imageWidget = imagePath.startsWith('http')
          ? Image.network(
              imagePath,
              width: imageWidth.toDouble(),
              height: imageWidth.toDouble() * 0.8,
              fit: BoxFit.cover,
            )
          : Image.asset(
              imagePath,
              width: imageWidth.toDouble(),
              height: imageWidth.toDouble() * 0.8,
              fit: BoxFit.cover,
            );
      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: imageWidget,
      );
    }
    return const SizedBox.shrink();
  }
}

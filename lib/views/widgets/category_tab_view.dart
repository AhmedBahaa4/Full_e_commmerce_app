import 'package:e_commerc_app/models/category_model.dart';
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
                final isEven = index % 2 == 0; // نحدد الزوجي والفردي

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 16,
                  ),
                  child: InkWell(
                    onTap: () {
                      // هنا تقدر تفتح صفحة تفاصيل الكاتيجوري مثلا
                    },
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        color: category.bgColor,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: isEven
                              ? [
                                  // النصوص الأول (شمال)
                                  _buildTextSection(context, category),
                                  // الصورة يمين
                                  _buildImageSection(category),
                                ]
                              : [
                                  // الصورة الأول (شمال)
                                  _buildImageSection(category),
                                  // النصوص يمين
                                  _buildTextSection(context, category),
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
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: category.textcolor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${category.productsCount} Products',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: category.textcolor,
          ),
        ),
      ],
    );
  }

  Widget _buildImageSection(CategoryModel category) {
    if (category.imageUrl != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(
          category.imageUrl!,
          width: 125,
          height: 100,
          fit: BoxFit.cover,
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}

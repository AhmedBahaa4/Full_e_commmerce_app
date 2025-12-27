import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerc_app/utils/app_color.dart';
import 'package:e_commerc_app/utils/app_routes.dart';
import 'package:e_commerc_app/views/widgets/AiFloatingButton%20.dart';

import 'package:e_commerc_app/views/widgets/product_item.dart';
import 'package:e_commerc_app/views_models/cubit/home_cubit/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';

class HomeTabView extends StatelessWidget {
  const HomeTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(

      bloc: BlocProvider.of<HomeCubit>(context),
      buildWhen: (previous, current) => current is HomeLoading || current is HomeLoaded,
      builder: (context, state) {
        if (state is HomeLoading) {
          return const Center(child: CircularProgressIndicator.adaptive());
        } else if (state is HomeLoaded) {
          return Stack(
            children: [
               SingleChildScrollView(
              child: Column(
                children: [
                  FlutterCarousel.builder(
                    itemCount: state.carouselItems.length,
                    itemBuilder:
                        (BuildContext context, int index, int realIndex) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(13),
                              child: CachedNetworkImage(
                                imageUrl: state.carouselItems[index].imgUrl,
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                    const Center(child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) => const Icon(
                                  Icons.error,
                                  color: AppColors.red,
                                  size: 30,
                                ),
                              ),
                            ),
                          );
                        },
            
                    options: FlutterCarouselOptions(
                      height: 180,
            
                      autoPlay: true,
                      enlargeCenterPage: true,
                      viewportFraction: 0.9,
                      aspectRatio: 16 / 9,
                      initialPage: 0,
                      enableInfiniteScroll: true,
                      reverse: false,
                      showIndicator: true,
                      autoPlayCurve: Curves.fastOutSlowIn,
                      autoPlayInterval: const Duration(seconds: 3),
                      autoPlayAnimationDuration: const Duration(
                        milliseconds: 800,
                      ),
                      slideIndicator: CircularWaveSlideIndicator(),
                      pauseAutoPlayOnTouch: true,
                    ),
                  ),
            
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'New Arrivals 🔥',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Text(
                        'See All',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.strongblue,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
            
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 2,
                      crossAxisSpacing: 16,
                    ),
                    itemCount: state.products.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () =>
                            Navigator.of(context, rootNavigator: true).pushNamed(
                              AppRoutes.productDetailsRoute,
                              arguments: state.products[index].id,
                            ),
            
                        child: ProductItem(productItem: state.products[index]),
                      );
                    },
                  ),
                ],
              ),
            ),
           const AiFloatingButton(),

            ]
            
          );
        } else if (state is HomeError) {
          return Center(
            child: Text(
              state.message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.red,
                fontSize: 18,
              ),
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}

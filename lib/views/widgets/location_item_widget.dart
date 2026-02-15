import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerc_app/models/location_item_model.dart';
import 'package:e_commerc_app/utils/app_color.dart';
import 'package:flutter/material.dart';

class LocationItemWidget extends StatelessWidget {
  final Color borderColor;
  final VoidCallback onTap;
  final LocationItemModel location;
  const LocationItemWidget({
    super.key,
    this.borderColor = AppColors.grey,
    required this.onTap,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    location.city,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    '${location.city}, ${location.country}',
                    style: Theme.of(
                      context,
                    ).textTheme.titleSmall!.copyWith(color: AppColors.grey),
                  ),
                ],
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(radius: 55, backgroundColor: borderColor),
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: CachedNetworkImageProvider(
                      location.imgurl,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.grey),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: BlocListener<ChooseLocationCubit, ChooseLocationState>(
                            bloc: cubit,
                            listenWhen: (previous, current) =>
                                current is LocationShosen,
                            listener: (context, state) {
                              if (state is LocationShosen) {
                                final selectedLocation = state.location;
                                // show snackbar only for the item that was selected
                                if (selectedLocation.id == location.id) {
                                  // ScaffoldMessenger.of(context).showSnackBar(
                                  //   SnackBar(
                                  //     content: Text(
                                  //       'Location selected: ${state.location.city}, ${state.location.country}',
                                  //     ),
                                  //     closeIconColor: AppColors.primary,
                                  //   ),
                                  // );
                                  
                                }
                              }
                            },
                            child: InkWell(
                              onTap: () {
                                cubit.selectLocation(location.id);
                              },
                              child: ListTile(
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: CachedNetworkImage(
                                    imageUrl: location.imgurl,
                                    width: 70,
                                    height: 70,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(
                                          Icons.error,
                                          color: Colors.red,
                                        ),
                                  ),
                                ),
                                title: Text(
                                  location.city,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                subtitle: Text(
                                  '${location.city}, ${location.country}',
                                  style: const TextStyle(color: AppColors.grey),
                                ),
                                trailing: const Icon(
                                  Icons.location_pin,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ),
                        ); */

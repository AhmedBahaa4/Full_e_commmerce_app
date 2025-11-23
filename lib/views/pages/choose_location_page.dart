import 'package:e_commerc_app/utils/app_color.dart';
import 'package:e_commerc_app/views/widgets/location_item_widget.dart';
import 'package:e_commerc_app/views/widgets/main_button.dart';
import 'package:e_commerc_app/views_models/cubit/choose-location_cubit/choose_location_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChooseLocationPage extends StatefulWidget {
  const ChooseLocationPage({super.key});

  @override
  State<ChooseLocationPage> createState() => _ChooseLocationPageState();
}

class _ChooseLocationPageState extends State<ChooseLocationPage> {
  final TextEditingController _locationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<ChooseLocationCubit>(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Address',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppColors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(
                'Choose your location',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Text(
                'Let\'s find an unforgettable event. Choose a location below to get started:',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w400,
                  color: AppColors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _locationController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: AppColors.greyshade,
                  prefixIcon: const Icon(
                    Icons.location_on_outlined,
                    color: AppColors.black2,
                  ),
                  prefixIconColor: AppColors.grey2,
                  hintText: 'Write your location city - country',
                  hintStyle: const TextStyle(color: AppColors.black2),
                  suffixIcon:
                      BlocConsumer<ChooseLocationCubit, ChooseLocationState>(
                        bloc: cubit,
                        listenWhen: (previous, current) =>
                            current is AddingLocation ||
                            current is LocationAdded ||
                            current is LocationAddedFailur ||
                            current is ConfirmedLocationLoaded,
                        listener: (context, state) {
                          if (state is LocationAdded) {
                            _locationController.clear();
                          } else if (state is ConfirmedLocationLoaded) {
                            Navigator.of(context).pop();
                          }
                        },
                        builder: (context, state) {
                          if (state is AddingLocation) {
                            return const Padding(
                              padding: EdgeInsets.all(12.0),
                              child: SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator.adaptive(
                                  strokeWidth: 2,
                                ),
                              ),
                            );
                          }
                          return IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              final locationText = _locationController.text;
                              if (locationText.isNotEmpty) {
                                cubit.addLocation(locationText);
                              }
                            },
                          );
                        },
                      ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Select Location:',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              BlocBuilder<ChooseLocationCubit, ChooseLocationState>(
                bloc: cubit,
                buildWhen: (previous, current) =>
                    current is FetchingLocations ||
                    current is FetchedLocations ||
                    current is FetchLocationsFailur,
                builder: (context, state) {
                  if (state is FetchingLocations) {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  } else if (state is FetchedLocations) {
                    final locations = state.locations;
                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: locations.length,
                      // ... باقي الـ imports والـ class زي ما هما

                      // داخل الـ ListView.builder:
                      itemBuilder: (context, index) {
                        final location = locations[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 0,
                          ),
                          child:
                              BlocBuilder<
                                ChooseLocationCubit,
                                ChooseLocationState
                              >(
                                bloc: cubit,
                                buildWhen: (previous, current) =>
                                    current is LocationShosen,
                                builder: (context, state) {
                                  // حدد if العنصر ده متسَلِك (selected) من الـ state أو من الـ cubit مباشرة
                                  final bool isSelectedFromState =
                                      state is LocationShosen &&
                                      state.location.id == location.id;
                                  final bool isSelectedFromCubit =
                                      cubit.selectedLocationId == location.id;

                                  final bool isSelected =
                                      isSelectedFromState ||
                                      isSelectedFromCubit;

                                  return LocationItemWidget(
                                    location: location,
                                    onTap: () {
                                      cubit.selectLocation(location.id);
                                    },
                                    borderColor: isSelected
                                        ? AppColors.primary
                                        : AppColors.grey,
                                  );
                                },
                              ),
                        );
                      },
                    );
                  } else if (state is FetchLocationsFailur) {
                    return Center(child: Text(state.errorMessage));
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
              const SizedBox(height: 24),
              BlocBuilder<ChooseLocationCubit, ChooseLocationState>(
                bloc: cubit,
                buildWhen: (previous, current) =>
                    current is ConfirmLocationLoading ||
                    current is ConfirmedLocationLoaded ||
                    current is ConfirmLocationFailur,
                builder: (context, state) {
                  if (state is ConfirmLocationLoading) {
                    return MainButton(
                      text: 'Confirm location',
                      isLoading: true,
                    );
                  } else if (state is ConfirmLocationFailur) {
                    return Center(child: Text(state.errorMessage));
                  }
                  return MainButton(
                    text: 'Confirm location',
                    onTap: () {
                      cubit.confirmLocation();
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

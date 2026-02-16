import 'package:e_commerc_app/utils/app_color.dart';
import 'package:e_commerc_app/utils/responsive_helper.dart';
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
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ChooseLocationCubit>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Shipping Address',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: BlocConsumer<ChooseLocationCubit, ChooseLocationState>(
          listener: (context, state) {
            if (state is LocationAdded) {
              _locationController.clear();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Address added successfully')),
              );
            } else if (state is LocationAddedFailur) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
            } else if (state is ConfirmLocationFailur) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
            } else if (state is ConfirmedLocationLoaded) {
              Navigator.of(context).pop();
            }
          },
          builder: (context, state) {
            final isAdding = state is AddingLocation;
            final isConfirming = state is ConfirmLocationLoading;
            final locations = cubit.locations;

            return LayoutBuilder(
              builder: (context, constraints) {
                final maxContentWidth = ResponsiveHelper.maxContentWidth(
                  context,
                );
                final horizontalPadding = ResponsiveHelper.horizontalPadding(
                  context,
                );

                return Align(
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxContentWidth),
                    child: Column(
                      children: [
                        Expanded(
                          child: RefreshIndicator(
                            onRefresh: cubit.fetchLocations,
                            child: ListView(
                              padding: EdgeInsets.fromLTRB(
                                horizontalPadding,
                                16,
                                horizontalPadding,
                                16,
                              ),
                              physics: const AlwaysScrollableScrollPhysics(),
                              children: [
                                const _LocationHeaderCard(),
                                const SizedBox(height: 16),
                                _AddLocationCard(
                                  controller: _locationController,
                                  isAdding: isAdding,
                                  onAdd: () {
                                    final value = _locationController.text
                                        .trim();
                                    if (value.isEmpty) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Enter location as: city - country',
                                          ),
                                        ),
                                      );
                                      return;
                                    }
                                    cubit.addLocation(value);
                                  },
                                ),
                                const SizedBox(height: 18),
                                Text(
                                  'Saved Addresses',
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(height: 10),
                                if (state is FetchingLocations &&
                                    locations.isEmpty)
                                  const Padding(
                                    padding: EdgeInsets.only(top: 20),
                                    child: Center(
                                      child:
                                          CircularProgressIndicator.adaptive(),
                                    ),
                                  ),
                                if (state is FetchLocationsFailur &&
                                    locations.isEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: Center(
                                      child: Text(
                                        state.errorMessage,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(color: AppColors.red),
                                      ),
                                    ),
                                  ),
                                if (locations.isEmpty &&
                                    state is! FetchingLocations &&
                                    state is! FetchLocationsFailur)
                                  const _EmptyLocationView(),
                                ...locations.map(
                                  (location) => Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: LocationItemWidget(
                                      location: location,
                                      onTap: () =>
                                          cubit.selectLocation(location.id),
                                      borderColor:
                                          cubit.selectedLocationId ==
                                              location.id
                                          ? AppColors.primary
                                          : AppColors.grey5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                            horizontalPadding,
                            8,
                            horizontalPadding,
                            MediaQuery.viewPaddingOf(context).bottom + 12,
                          ),
                          child: MainButton(
                            text: 'Confirm Address',
                            isLoading: isConfirming,
                            onTap: () => cubit.confirmLocation(),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _LocationHeaderCard extends StatelessWidget {
  const _LocationHeaderCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          colors: [Color(0xFF7043F7), Color(0xFF4D8EFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.location_on_outlined,
              color: AppColors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Choose Delivery Address',
                  style: TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 17,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Format: city - country',
                  style: TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AddLocationCard extends StatelessWidget {
  final TextEditingController controller;
  final bool isAdding;
  final VoidCallback onAdd;

  const _AddLocationCard({
    required this.controller,
    required this.isAdding,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.grey5),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                hintText: 'Cairo - Egypt',
                filled: true,
                fillColor: AppColors.grey2,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            height: 46,
            width: 46,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: isAdding ? null : onAdd,
              child: isAdding
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.white,
                      ),
                    )
                  : const Icon(Icons.add, color: AppColors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyLocationView extends StatelessWidget {
  const _EmptyLocationView();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.grey2,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.location_off_outlined,
            size: 34,
            color: AppColors.black2,
          ),
          const SizedBox(height: 8),
          Text(
            'No address saved yet',
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 2),
          Text(
            'Add one to continue checkout.',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.black2),
          ),
        ],
      ),
    );
  }
}

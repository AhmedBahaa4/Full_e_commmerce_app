import 'package:e_commerc_app/models/location_item_model.dart';
import 'package:e_commerc_app/services/auth_services.dart';
import 'package:e_commerc_app/services/location_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'choose_location_state.dart';

class ChooseLocationCubit extends Cubit<ChooseLocationState> {
  ChooseLocationCubit() : super(ChooseLocationInitial());
  final locationservices = LocationServicesImpl();
  final authservices = AuthServicesImpl();
  List<LocationItemModel> _locations = const <LocationItemModel>[];
  List<LocationItemModel> get locations =>
      List<LocationItemModel>.unmodifiable(_locations);
  String? selectedLocationId;
  LocationItemModel? selectedLocation;

  // fetch locations
  Future<void> fetchLocations() async {
    emit(FetchingLocations());
    try {
      final currentuser = authservices.currentUser();
      if (currentuser == null) {
        _locations = const <LocationItemModel>[];
        emit(FetchedLocations(locations: const <LocationItemModel>[]));
        return;
      }

      final locations = await locationservices.fetchLocations(currentuser.uid);
      _locations = locations;
      if (locations.isEmpty) {
        selectedLocationId = null;
        selectedLocation = null;
        emit(FetchedLocations(locations: locations));
        return;
      }

      for (var location in locations) {
        if (location.isChoosen) {
          selectedLocationId = location.id;
          selectedLocation = location;
        }
      }
      selectedLocationId ??= locations.first.id;
      selectedLocation ??= locations.first;

      emit(FetchedLocations(locations: locations));
      emit(LocationShosen(location: selectedLocation!));
    } catch (e) {
      emit(FetchLocationsFailur(errorMessage: e.toString()));
    }
  }

  Future<void> addLocation(String location) async {
    emit(AddingLocation());

    try {
      final splittedTLocations = location
          .split('-')
          .map((e) => e.trim())
          .toList();
      if (splittedTLocations.length < 2 ||
          splittedTLocations[0].isEmpty ||
          splittedTLocations[1].isEmpty) {
        emit(LocationAddedFailur(errorMessage: 'Use format: city - country'));
        return;
      }
      final currentUser = authservices.currentUser();
      if (currentUser == null) {
        emit(LocationAddedFailur(errorMessage: 'You need to login first'));
        return;
      }

      final chosenLocations = await locationservices.fetchLocations(
        currentUser.uid,
        isChoosen: true,
      );
      final locationItem = LocationItemModel(
        id: DateTime.now().toIso8601String(),
        city: splittedTLocations[0],
        country: splittedTLocations[1],
        isChoosen: chosenLocations.isEmpty,
      );

      await locationservices.setLocation(locationItem, currentUser.uid);

      selectedLocationId = locationItem.id;
      selectedLocation = locationItem;
      emit(LocationAdded());

      final locations = await locationservices.fetchLocations(currentUser.uid);
      _locations = locations;
      emit(FetchedLocations(locations: locations));
      emit(LocationShosen(location: locationItem));
    } catch (e) {
      emit(LocationAddedFailur(errorMessage: e.toString()));
    }
  }

  // select location
  Future<void> selectLocation(String id) async {
    try {
      selectedLocationId = id;
      final currentuser = authservices.currentUser();
      if (currentuser == null) {
        emit(FetchLocationsFailur(errorMessage: 'You need to login first'));
        return;
      }

      final chosenLocation = await locationservices.fetchSingleLocation(
        currentuser.uid,
        id,
      );
      selectedLocation = chosenLocation;
      emit(LocationShosen(location: chosenLocation));
    } catch (e) {
      emit(FetchLocationsFailur(errorMessage: e.toString()));
    }
  }
  // confirm location

  Future<void> confirmLocation() async {
    emit(ConfirmLocationLoading());

    try {
      final currentuser = authservices.currentUser();
      if (currentuser == null) {
        emit(ConfirmLocationFailur(errorMessage: 'You need to login first'));
        return;
      }
      if (selectedLocation == null) {
        emit(ConfirmLocationFailur(errorMessage: 'Please select a location'));
        return;
      }

      if (selectedLocation!.isChoosen) {
        emit(ConfirmedLocationLoaded());
        return;
      }

      var previousChosenLocation = (await locationservices.fetchLocations(
        currentuser.uid,
        isChoosen: true,
      ));
      if (previousChosenLocation.isNotEmpty) {
        var previousLocation = previousChosenLocation.first;
        previousLocation = previousLocation.copyWith(isChoosen: false);
        await locationservices.setLocation(previousLocation, currentuser.uid);
      }

      selectedLocation = selectedLocation!.copyWith(isChoosen: true);

      await locationservices.setLocation(selectedLocation!, currentuser.uid);
      _locations = _locations.map((location) {
        if (location.id == selectedLocation!.id) {
          return selectedLocation!;
        }
        if (location.isChoosen) {
          return location.copyWith(isChoosen: false);
        }
        return location;
      }).toList();

      emit(ConfirmedLocationLoaded());
    } catch (e) {
      emit(ConfirmLocationFailur(errorMessage: e.toString()));
    }
  }
}

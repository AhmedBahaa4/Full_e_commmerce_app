import 'package:e_commerc_app/models/location_item_model.dart';
import 'package:e_commerc_app/services/auth_services.dart';
import 'package:e_commerc_app/services/location_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'choose_location_state.dart';

class ChooseLocationCubit extends Cubit<ChooseLocationState> {
  ChooseLocationCubit() : super(ChooseLocationInitial());
  final locationservices = LocationServicesImpl();
  final authservices = AuthServicesImpl();
  String? selectedLocationId;
  LocationItemModel? selectedLocation;

  // fetch locations
  Future<void> fetchLocations() async {
    emit(FetchingLocations());
    try {
      final currentuser = authservices.currentUser();
      final locations = await locationservices.fetchLocations(currentuser!.uid);
      for (var location in locations) {
        if (location.isChoosen) {
          selectedLocationId = location.id;
          selectedLocation = location;
        }
        // if no location is chosen, select the first one by default
        selectedLocationId ??= locations.first.id;
        selectedLocation ??= locations.first;
      }

      emit(FetchedLocations(locations: locations));
      emit(LocationShosen(location: selectedLocation!));
    } catch (e) {
      emit(FetchLocationsFailur(errorMessage: e.toString()));
    }
  }

  Future<void> addLocation(String location) async {
    emit(AddingLocation());

    try {
      final splittedTLocations = location.split('-');
      final locationItem = LocationItemModel(
        id: DateTime.now().toIso8601String().toString(),
        city: splittedTLocations[0],
        country: splittedTLocations[1],
      );
      final currentUser = authservices.currentUser();
      await locationservices.setLocation(locationItem, currentUser!.uid);
      emit(LocationAdded());
      final currentuser = authservices.currentUser();
      final locations = await locationservices.fetchLocations(currentuser!.uid);
      emit(FetchedLocations(locations: locations));
    } catch (e) {
      emit(FetchLocationsFailur(errorMessage: e.toString()));
    }
  }

  // select location
  Future<void> selectLocation(String id) async {
    selectedLocationId = id;
    final currentuser = authservices.currentUser();

    final chosenLocation = await locationservices.fetchSingleLocation(
      currentuser!.uid,
      id,
    );
    selectedLocation = chosenLocation;
    emit(LocationShosen(location: chosenLocation));
  }
  // confirm location

  Future<void> confirmLocation() async {
    emit(ConfirmLocationLoading());

    try {
      final currentuser = authservices.currentUser();
      var previousChosenLocation = (await locationservices.fetchLocations(
        currentuser!.uid,
        isChoosen: true,
      ));
      if (previousChosenLocation.isNotEmpty) {
        var previousLocation = previousChosenLocation.first;
        previousLocation = previousLocation.copyWith(isChoosen: false);
        await locationservices.setLocation(previousLocation, currentuser.uid);
        await locationservices.setLocation(previousLocation, currentuser.uid);
      }

      selectedLocation = selectedLocation!.copyWith(isChoosen: true);

      await locationservices.setLocation(selectedLocation!, currentuser.uid);

      emit(ConfirmedLocationLoaded());
    } catch (e) {
      emit(ConfirmLocationFailur(errorMessage: e.toString()));
    }
  }
}

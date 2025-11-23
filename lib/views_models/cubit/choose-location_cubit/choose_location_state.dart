part of 'choose_location_cubit.dart';

sealed class ChooseLocationState {}

final class ChooseLocationInitial extends ChooseLocationState {}

final class FetchingLocations extends ChooseLocationState {}

final class FetchedLocations extends ChooseLocationState {
final  List<LocationItemModel> locations;
  FetchedLocations({required this.locations});
}

final class FetchLocationsFailur extends ChooseLocationState {
  final String errorMessage;
  FetchLocationsFailur({required this.errorMessage});
}



final class AddingLocation extends ChooseLocationState {}

final class LocationAdded extends ChooseLocationState {

}

final class LocationAddedFailur extends ChooseLocationState {
  final String errorMessage;
  LocationAddedFailur({required this.errorMessage});
}
  
final class LocationShosen extends ChooseLocationState {
 final LocationItemModel location;
  LocationShosen({ required this.location});

}  

final class ConfirmLocationLoading extends ChooseLocationState {}

final class ConfirmedLocationLoaded extends ChooseLocationState {

}

final class ConfirmLocationFailur extends ChooseLocationState {
  final String errorMessage;
  ConfirmLocationFailur({required this.errorMessage});
}
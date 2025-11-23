import 'package:e_commerc_app/models/location_item_model.dart';
import 'package:e_commerc_app/services/firestore_services.dart';
import 'package:e_commerc_app/utils/api_paths.dart';

abstract class LocationServices {
  // fetch all locations for a user
  Future<List<LocationItemModel>> fetchLocations(
    String userId, {
    bool isChoosen = false,
  });
  // add location for a user
  Future<void> setLocation(LocationItemModel location, String userId);
  //   fetch single location by id
  Future<LocationItemModel> fetchSingleLocation(
    String userId,
    String locationId,
  );
}

class LocationServicesImpl implements LocationServices {
  final firestoreServices = FirestoreServices.instance;
  // add location
  @override
  Future<void> setLocation(LocationItemModel location, String userId) async =>
      await firestoreServices.setData(
        path: ApiPaths.location(userId, location.id),
        data: location.toMap(),
      );
  // fetch all locations

  @override
  Future<List<LocationItemModel>> fetchLocations(
    String userId, {
    bool isChoosen = false,
  }) async => await firestoreServices.getCollection(
    path: ApiPaths.locations(userId),
    builder: (data, documentId) => LocationItemModel.fromMap(data),
    queryBuilder: isChoosen
        ? (query) => query.where('isChoosen', isEqualTo: true)
        : null,
  );
  // fetch single location by id
  @override
  Future<LocationItemModel> fetchSingleLocation(
    String userId,
    String locationId,
  ) async {
    return await firestoreServices.getDocument(
      path: ApiPaths.location(userId, locationId),
      builder: (data, documentId) => LocationItemModel.fromMap(data),
    );
  }
}

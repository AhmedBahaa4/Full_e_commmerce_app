// ignore_for_file: public_member_api_docs, sort_constructors_first
class LocationItemModel {
  final String id;
  final String imgurl;
  final String city;
  final String country;
  final bool isChoosen;

  const LocationItemModel({
    required this.id,
    this.imgurl =
        'https://previews.123rf.com/images/emojoez/emojoez1903/emojoez190300018/119684277-illustrations-design-concept-location-maps-with-road-follow-route-for-destination-drive-by-gps.jpg',
    required this.city,
    required this.country,
    this.isChoosen = false,
  });

  LocationItemModel copyWith({
    String? id,
    String? imgurl,
    String? city,
    String? country,
    bool? isChoosen,
  }) {
    return LocationItemModel(
      id: id ?? this.id,
      imgurl: imgurl ?? this.imgurl,
      city: city ?? this.city,
      country: country ?? this.country,
      isChoosen: isChoosen ?? this.isChoosen,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'imgurl': imgurl,
      'city': city,
      'country': country,
      'isChoosen': isChoosen,
    };
  }

  factory LocationItemModel.fromMap(Map<String, dynamic> map) {
    return LocationItemModel(
      id: map['id'] as String,
      imgurl: map['imgurl'] as String,
      city: map['city'] as String,
      country: map['country'] as String,
      isChoosen: map['isChoosen'] as bool,
    );
  }
}

List<LocationItemModel> dummyLocations = [
  const LocationItemModel(id: '1', city: 'Cairo', country: 'Egypt'),
  const LocationItemModel(id: '2', city: 'Giza  ', country: 'Egypt'),
  const LocationItemModel(id: '3', city: 'Alexandria', country: 'Egypt'),
];

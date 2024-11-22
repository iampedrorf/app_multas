class FineModel {
  String plate;
  String city;
  String state;
  double speed;
  double limit;
  double lat;
  double lng;
  bool isEmailSent;
  DateTime creationDate;

  FineModel({
    required this.plate,
    required this.city,
    required this.state,
    required this.speed,
    required this.limit,
    required this.lat,
    required this.lng,
    this.isEmailSent = false,
    required this.creationDate,
  });

  Map<String, dynamic> mapForInsert() {
    return {
      'plate': plate,
      'city': city,
      'state': state,
      'speed': speed,
      'limit': limit,
      'lat': lat,
      'lng': lng,
      'isEmailSent': isEmailSent,
      'creationDate': creationDate.toIso8601String(),
    };
  }

  factory FineModel.fromJson(Map<String, dynamic> json) {
    return FineModel(
      plate: json['plate'],
      city: json['city'],
      state: json['state'],
      speed: json['speed'],
      limit: json['limit'],
      lat: json['lat'],
      lng: json['lng'],
      isEmailSent: json['isEmailSent'] ?? false,
      creationDate: DateTime.parse(json['creationDate']),
    );
  }
}

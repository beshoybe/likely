class TripModel {
  String? id;
  final String bikeId;
  final String userId;
  final String startLocation;
  final DateTime startDateTime;
  DateTime? endDateTime;
  final TripStatus status;
  double? price;
  final String? image;
  TripModel({
    this.id,
    required this.bikeId,
    required this.userId,
    required this.startLocation,
    required this.startDateTime,
    this.endDateTime,
    required this.status,
    this.price,
    this.image,
  });
  factory TripModel.fromJson(Map<String, dynamic> data) {
    return TripModel(
      bikeId: data['bikeId'],
      userId: data['userId'],
      startLocation: data['startLocation'],
      startDateTime: DateTime.parse(data['startDateTime']),
      endDateTime: DateTime.tryParse(data['endDateTime'] ?? ''),
      status:
          data['status'] == 'started' ? TripStatus.started : TripStatus.ended,
      price: data['price'],
      image: data['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bikeId': bikeId,
      'userId': userId,
      'startLocation': startLocation,
      'startDateTime': startDateTime.toIso8601String(),
      'endDateTime': endDateTime?.toIso8601String(),
      'status': status == TripStatus.started ? 'started' : 'ended',
      'price': price,
      'image': image,
    };
  }
}

enum TripStatus { started, ended }

import 'package:uuid/uuid.dart';
import 'dart:io';

const uuid = Uuid();

class PlaceLocation {
  const PlaceLocation({
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  final double longitude;
  final double latitude;
  final String address;
}

class Place {
  Place({
    required this.title,
    required this.file,
    required this.placeLocation,
    String? id,
  }) : id = id ?? uuid.v4();

  final String id;
  final String title;
  final File file;
  final PlaceLocation placeLocation;
}

// ignore_for_file: empty_constructor_bodies, missing_return

import 'package:flutter/foundation.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Directions {
  final LatLngBounds bounds;
  final List<PointLatLng> polyLinePoints;
  final String totalDistance;
  final String totalDuration;

  const Directions({
    @required this.bounds,
    @required this.polyLinePoints,
    @required this.totalDistance,
    @required this.totalDuration,
  });

  factory Directions.fromMap(Map<String, dynamic> map) {
    //Check if route is not available
    if ((map['routes'] as List).isEmpty) return null;

    //Get route ionformation
    final data = Map<String, dynamic>.from(map['routes'][0]);

    //Bounds
    final northeast = data['bounds']['northeast'];
    final southwest = data['bounds']['southwest'];
    final bounds = LatLngBounds(
        northeast: LatLng(northeast['lat'], northeast['lng']),
        southwest: LatLng(southwest['lat'], northeast['lng']));

    //Distance and duration
    String distance = '';
    String duration = '';
    if ((data['legs'] as List).isNotEmpty) {
      final leg = data['legs'][0];
      distance = leg['distance']['text'];
      duration = leg['duration']['text'];
    }

    return Directions(
        bounds: bounds,
        polyLinePoints: PolylinePoints()
            .decodePolyline(data['overview_polyline']['points']),
        totalDistance: distance,
        totalDuration: duration);
  }
}
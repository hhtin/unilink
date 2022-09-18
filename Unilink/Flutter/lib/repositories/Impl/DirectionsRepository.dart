import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:unilink_flutter_app/env/.env.dart';
import 'package:unilink_flutter_app/models/directions_model.dart';

class DirectionRepository {
  static const String _baseUrl =
      'https://maps.googleapis.com/maps/api/directions/json?';

  final Dio _dio;

  DirectionRepository({Dio dio}) : _dio = dio ?? new Dio();

  Future<Directions> getDirections({
    @required LatLng origin,
    @required LatLng destination,
  }) async {
    try {
      final response = await _dio.get(_baseUrl, queryParameters: {
        'origin': '${origin.latitude},${origin.longitude}',
        'destination': '${destination.latitude},${destination.longitude}',
        'key': googleAPIKey,
      });

      //Check if response is successful
      if (response.statusCode == 200) {
        print(response.data);
        return Directions.fromMap(response.data);
      }
    } catch (e) {
      return null;
    }

    return null;
  }
}
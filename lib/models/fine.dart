import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../main.dart';

class FineModel {
  String id;
  String plate;
  String city;
  String state;
  double speed;
  double limit;
  double lat;
  double lng;
  String email;
  bool isEmailSent;
  DateTime creationDate;

  FineModel({
    required this.id,
    required this.plate,
    required this.city,
    required this.state,
    required this.speed,
    required this.limit,
    required this.lat,
    required this.lng,
    required this.email,
    this.isEmailSent = false,
    required this.creationDate,
  });

  Map<String, dynamic> mapForInsert() {
    return {
      'id': id,
      'plate': plate,
      'city': city,
      'state': state,
      'speed': speed,
      'limit': limit,
      'lat': lat,
      'lng': lng,
      'email': email,
      'isEmailSent': isEmailSent,
      'creationDate': creationDate.toIso8601String(),
    };
  }

  factory FineModel.fromJson(Map<String, dynamic> json) {
    print('JSON recibido: $json');
    return FineModel(
      id: json['_id'],
      plate: json['plate'],
      city: json['city'],
      state: json['state'],
      speed: (json['speed'] as num).toDouble(),
      limit: (json['limit'] as num).toDouble(),
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      email: json['email'],
      isEmailSent: json['isEmailSent'] ?? false,
      creationDate: DateTime.parse(json['creationDate']),
    );
  }
}

Future<List<FineModel>> getFines(BuildContext context) async {
  var url = Uri.parse("$api/api/fines");

  if (await InternetConnectionChecker().hasConnection) {
    try {
      var response = await http.get(url).timeout(
        Duration(seconds: 60),
        onTimeout: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Color(0xfffd687b),
              content: Text("Red inestable. Por favor, intente más tarde"),
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 1, milliseconds: 500),
            ),
          );
          return http.Response('{}', 408);
        },
      );

      print('Respuesta de fines: ${response.body}');
      if (response.statusCode == 200) {
        List<FineModel> fines = (jsonDecode(response.body) as List<dynamic>)
            .map((fineJson) => FineModel.fromJson(fineJson))
            .toList();
        return fines;
      } else if (response.statusCode == 401) {
        print('Token expirado, intentando renovar...');
        return await getFines(context);
      } else if (response.statusCode == 500) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Color(0xfffd687b),
            content: Text("Problemas técnicos (${response.statusCode})"),
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 3, milliseconds: 500),
          ),
        );
        print('Error 500: ${response.body}');
      } else {
        print('Error al obtener fines: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al obtener fines: $e');
    }
  } else {
    // Si no hay conexión a internet, simplemente regresamos una lista vacía
    print('Sin conexión a internet');
    return [];
  }
  return [];
}

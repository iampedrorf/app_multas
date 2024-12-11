import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:geolocator/geolocator.dart'; // Importamos Geolocator

import '../models/fine.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = {}; // Para almacenar los marcadores en el mapa.
  LatLng _currentLocation =
      LatLng(0.0, 0.0); // Inicializamos con coordenadas nulas.

  @override
  void initState() {
    super.initState();
    _getCurrentLocation(); // Obtener la ubicación actual cuando inicia
    _loadFines(); // Cargar las multas
  }

  // Función para obtener la ubicación actual
  Future<void> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
    });
    // Centrar la cámara en la ubicación actual
    _moveCameraToLocation();
  }

  // Mover la cámara al lugar actual
  Future<void> _moveCameraToLocation() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: _currentLocation,
          zoom: 14.0,
        ),
      ),
    );
  }

  // Llamar al método getFines y agregar los marcadores al mapa
  Future<void> _loadFines() async {
    List<FineModel> fines = await getFines(context); // Obtener las multas
    setState(() {
      _markers = fines.map((fine) {
        return Marker(
          markerId: MarkerId(fine.id),
          position: LatLng(fine.lat, fine.lng),
          infoWindow: InfoWindow(
            title: fine.plate,
            snippet: 'Speed: ${fine.speed} km/h',
          ),
        );
      }).toSet();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff6b4b3f),
        title: const Text(
          'Mapa',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: _currentLocation, // Ubicación inicial con la actual
          zoom: 14.0,
        ),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: _markers, // Mostrar los marcadores
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SelectLocationScreen extends StatefulWidget {
  final Function(double lat, double lng) onLocationSelected;

  const SelectLocationScreen({Key? key, required this.onLocationSelected})
      : super(key: key);

  @override
  _SelectLocationScreenState createState() => _SelectLocationScreenState();
}

class _SelectLocationScreenState extends State<SelectLocationScreen> {
  late GoogleMapController _controller;
  LatLng _selectedLocation =
      LatLng(19.432608, -99.133209); // Coordenadas predeterminadas

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
  }

  void _onTap(LatLng location) {
    setState(() {
      _selectedLocation = location;
    });
  }

  void _saveLocation() {
    widget.onLocationSelected(
        _selectedLocation.latitude, _selectedLocation.longitude);
    Navigator.pop(context); // Cierra la pantalla del mapa
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Seleccionar Ubicación"),
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _selectedLocation,
                zoom: 14,
              ),
              onTap: _onTap,
              markers: {
                Marker(
                  markerId: MarkerId('selectedLocation'),
                  position: _selectedLocation,
                ),
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _saveLocation,
              child: const Text("Guardar Ubicación"),
            ),
          ),
        ],
      ),
    );
  }
}

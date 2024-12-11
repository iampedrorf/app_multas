import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import '../main.dart';

class Permisos {
  Future<Position?> permisoUbicacionYGuardar() async {
    var statusLocation = await Permission.location.status;
    if (statusLocation.isGranted) {
      print('si hay permiso:)');
      // Obtener la posición actual
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      // Devolver la posición
      return position;
    } else if (statusLocation.isDenied) {
      print('no hay permiso:(');
      Map<Permission, PermissionStatus> status = await [
        Permission.location,
      ].request();
      if (await Permission.location.isPermanentlyDenied) {
        openAppSettings();
      }
      return null;
    } else {
      return null;
    }
  }
}
